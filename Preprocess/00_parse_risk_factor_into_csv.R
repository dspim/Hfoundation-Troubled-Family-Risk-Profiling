library(dplyr)
library(plyr)
library(data.table)
# a "real" Word doc
path <- "C:/Users/USER/Desktop/資料英雄"

setwd(path)
RiskUrl = list.files("會談風險因子")
RiskUrl = RiskUrl[-grep("~",RiskUrl)]
TimeTran = function(time){
NA_index = which(time!="")
s = cut(1:length(time), breaks = c(NA_index,NA_index[length(NA_index)]+1),include.lowest =T,right =F,labels = time[NA_index])
s = as.POSIXlt(as.Date(as.character(s)))
s$year =s$year + 1911
s = as.Date(s)
return(s)
}

RiskList=lapply(RiskUrl,function(file_name){
real_world_risk <-read_docx(paste0("會談風險因子/",file_name))
print(file_name)
if(docx_tbl_count(real_world_risk)!=1){
print (paste0(docx_tbl_count(real_world_risk)," : ",file_name))
}
Table_Risk <- lapply(1:docx_tbl_count(real_world_risk),function(i){
docx_extract_tbl(real_world_risk,i,header=F)
})
Table_Risk = do.call(rbind,Table_Risk)
Table_Risk = Table_Risk %>% filter(V1!="會談日期")
Table_Risk = Table_Risk[!apply(Table_Risk =="",1,all),]
Table_Risk =cbind(name = file_name,Table_Risk)
#Table_Risk$V1TimeTran
return(Table_Risk)
}
)

SummaryRisk = do.call(rbind,RiskList)
colnames(SummaryRisk) = c("name","會談日期","風險等級","風險編號","風險編號說明","處遇編號",
"處遇說明說明","會談社工" ,"會談志工","會談老師","會談其他","處遇社工","處遇日期","會談地點","備註")

write.csv(SummaryRisk,"SummaryRisk.csv",row.names = F)
