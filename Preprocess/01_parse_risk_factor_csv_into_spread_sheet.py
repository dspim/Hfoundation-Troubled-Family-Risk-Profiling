#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sun Jan 22 00:37:53 2017

@author: kevin
"""
import pandas as pd
import re

#read the file
data = pd.read_csv('/Users/kevin/D4SG/SummaryRisk.csv', header=0, encoding='Big5').iloc[:,[0,1,3]]
data.columns = ['Id', 'Date', 'Category']

#deal with the colunm : Id
data['Id'] = map(lambda x: str(x[:3]), data['Id'])

#deal with the colunm : Category
for i in range(len(data)):
    try:
        if re.match('\w\d{2}', data['Category'][i]) is not None:
            data['Category'][i] = data['Category'][i][0] + '-' + data['Category'][i][1:3]
        elif data['Category'][i] == 'None':
            data['Category'][i] = float('nan')
    except:
        data['Category'][i] = float('nan')

data = data[data['Category'].notnull()]
data.index = range(len(data))

#deal with the colunm : Date
df_b = pd.DataFrame()
pat = ['\d{3}.\d{1,2}.\d{1,2}', '\d{3}/\d{1,2}/\d{1,2}']
for i in range(len(data)):
    if pd.isnull(data['Date'][i]) or data['Date'][i] == u'同上':
        data['Date'][i] = float('nan')
    else:
        if re.match(pat[0], data['Date'][i]) is not None:
            if len(re.findall(pat[0], data['Date'][i])) == 1:
                data['Date'][i] = '/'.join(map(lambda x: x.zfill(2), str(re.findall(pat[0], data['Date'][i])[0]).split('.')))
            else:
                tmp = []
                for j in range(2):
                    tmp.append('/'.join(map(lambda x: x.zfill(2), str(re.findall(pat[0], data['Date'][i])[j]).split('.'))))
                data['Date'][i] = tmp[0]
                tmp_data = pd.DataFrame(data.ix[i, :]).transpose()
                tmp_data['Date'] = tmp[1]
                df_b = df_b.append(tmp_data)

        elif re.findall(pat[1], data['Date'][i]) is not None:
            if len(re.findall(pat[1], data['Date'][i])) == 1:
                data['Date'][i] = str(data['Date'][i])
            else:
                tmp = []
                for j in range(2):
                    tmp.append(map(lambda x: str(x), re.findall(pat[1], data['Date'][i]))[j])
                data['Date'][i] = tmp[0]
                tmp_data = pd.DataFrame(data.ix[i,:]).transpose()
                tmp_data['Date'] = tmp[1]
                df_b = df_b.append(tmp_data)

data = data.fillna(method='ffill')

#data processing
df_a = pd.DataFrame()
for i in df_b.index:
    risk_cat = data[data['Date']==data.ix[i]['Date']][data['Id']==data.ix[i]['Id']]['Category']
    df_b_tmp = df_b.ix[i, :].to_frame().transpose()
    df_a_tmp = pd.concat([df_b_tmp.drop('Category', axis=1), risk_cat], axis=1, join='outer').fillna(method='ffill')
    df_a = df_a.append(df_a_tmp)
df_a = df_a.fillna(method='bfill')

data_tmp = data.append(df_a).sort(['Id', 'Date']).drop_duplicates(['Id', 'Date', 'Category'], keep='first')
final_data = pd.DataFrame(data_tmp.values.tolist(), columns=['Id', 'Date', 'Category'])

col_list = []
for i, j in [('A', 46), ('B', 40), ('C', 43), ('D', 11), ('E', 5), ('F', 15), ('G', 25)]:
    col_list = col_list + [i+"-"+"%.2d" % j for j in range(1, j+1)]

drop_list = []
for i in range(len(final_data)):
    if final_data['Category'][i] not in col_list:
        drop_list.append(i)

final_data = final_data.drop(final_data.index[drop_list])
final_data = final_data.set_index(['Id', 'Date'])

#create Sparse-form data
spar_mat = pd.DataFrame(0, index=final_data.index, columns=col_list).groupby(level=[0, 1]).first()
for i in range(len(final_data)):
    spar_mat.loc[final_data.index[i]][final_data.ix[i, 'Category']] = 1



