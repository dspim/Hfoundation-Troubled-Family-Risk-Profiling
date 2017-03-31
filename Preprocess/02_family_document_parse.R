# case family document
setwd("/Users/Weitinglin/Documents/2015-2016 日常專案/2017 D4SG/家戶資料/")
library(docxtractr)
library(dplyr)
library(stringr)
library(purrr)
library(tibble)




# Input -------------------------------------------------------------------
#use the mac command textutil to convert all doc into docx
#system("for item in $(ls *.doc)\n do\n textutil -convert docx ${item}\n done\n")
case.names <-list.files(pattern = ".docx")

total.case.document <- data.frame(Id = character(),
                                  Geneder = factor(),
                                  Family_Category = character(),
                                  Monitor = logical(),
                                  Receive_Professional_Help = logical(),
                                  Social_Found = logical(),
                                  Special_Disease = logical(),
                                  Disable = logical(),
                                  Family_Problem_Summary = character(),
                                  School_Visit_Summary = character(),
                                  Family_Background_Summary = character(),
                                  Case_Receice_Resources = character() )
# parse the docx
for ( name in case.names){
 

test <- read_docx(name)
table_test <- docx_extract_tbl(test, 1, header=TRUE)

print(paste("Loading files:",name))
print(test)


# 代號 ----------------------------------------------------------------------

case.id <- colnames(table_test)[2] %>% as.character


# 性別 (case.gender) --------------------------------------------------------


gender_str <- table_test[1,4] %>% str_split_fixed("[:space:]+",2) %>% str_detect("■")

if (gender_str[1]){
    case.gender <- "M"
}

if (gender_str[2]){
    case.gender <- "F"
}

# 家庭類別 --------------------------------------------------------------------
case.family.category <- table_test[3,2] %>% str_extract_all("■\\S+|█[:space:]+\\S+|█\\S+|▓[:space:]+\\S+|▓\\S+") %>% unlist
case.family.category <- case.family.category %>% reduce(paste) %>% as.character



# 是否列管 --------------------------------------------------------------------
case.monitor <- table_test[4,2] %>% str_split_fixed("[:space:]+",2)
case.monitor <- case.monitor[1,1] %>% str_extract("■[:space:]+\\S|■\\S")

if (is.na(case.monitor)){
case.monitor <- table_test[4,2]  
case.monitor <- case.monitor %>% str_extract("■ \\S+|■[:space:]+\\S|■\\S|█[:space:]+\\S|█\\S|▓[:space:]+\\S|▓\\S")
}

if (str_detect(case.monitor,"否")){
    case.monitor <- F
}
if (str_detect(case.monitor,"是")){
    case.monitor <- T
}


# 專業協助 ------------------------------------------------------------------
case.prof <- table_test[5,2]
case.prof <- case.prof %>% str_split_fixed("：",3)

if (str_detect(case.prof[1,3],"無")){
    case.prof.assist <- F
} else if (str_detect(case.prof[1,1],"有")){
    case.prof.assist <- T
}


# 社會補助 --------------------------------------------------------------------
case.social.fund <- table_test[6,2] %>% str_extract_all("■\\S+|█[:space:]+\\S|█\\S") %>% unlist
case.social.fund <- case.social.fund %>% reduce(paste) %>% as.character

if ( identical(case.social.fund, character(0)) ){
    case.social.fund <- "無"
}

# 特殊疾病 --------------------------------------------------------------------


case.special.disease <- table_test[7,2] %>% str_extract_all("■\\S|█[:space:]+\\S|█\\S|▓\\S|▓[:space:]+\\S") %>% unlist

if (str_detect(case.special.disease,"有")){
    case.special.disease <- T
}

if (str_detect(case.special.disease,"無")){
    case.special.disease <- F
}


# 使否領有殘障手冊 ----------------------------------------------------------------


case.disable <- table_test[7,4] %>% str_extract_all("■\\S|█[:space:]+\\S|█\\S|▓\\S|▓[:space:]+\\S") %>% unlist

if ( identical(case.disable, character(0)) ){
    case.disable <- NA
}

if (!is.na(case.disable)){

    if (str_detect(case.disable,"是")){
        case.disable <- T
        }

    if (str_detect(case.disable,"否")){
        case.disable <- F
        }

}
# 家系圖 ---------------------------------------------------------------------

for (i in 1:nrow(table_test)){
    if (str_detect(table_test[i,1],"家  系  圖|家系圖")){
        post_family_line  <- i
    }
}


# 家庭問題摘要 ------------------------------------------------------------------

case.str.family.problem.summary <- table_test[post_family_line+2,1] %>% as.character()


# 學校訪視 ------------------------------------------------------------------

case.str.school.visit <- table_test[post_family_line+3,1] %>% as.character()


# 個案背景 ------------------------------------------------------------------

case.str.background <- table_test[post_family_line+4,1] %>% as.character()


# 評估與處理 -----------------------------------------------------------------

case.str.assessment <- table_test[post_family_line+5,1] %>% as.character()

 # 本會提供之資源 ---------------------------------------------------------------

case.receive.resource <- table_test[post_family_line+6,1]
case.receive.resource <- case.receive.resource %>% str_extract_all("■ \\S+。|█\\S+。|█ \\S+。|█\\S+。|▓ \\S+。|▓\\S+。") %>% unlist
case.receive.resource <- case.receive.resource %>% reduce(paste) %>% as.character()


# merge the data --------------------------------------------------------



case.document <- data.frame( case.id ,
                             case.gender,
                             case.family.category,
                             case.monitor,
                             case.prof.assist,
                             case.social.fund,
                             case.special.disease,
                             case.disable,
                             case.str.family.problem.summary,
                             case.str.school.visit,
                             case.str.background,
                             case.receive.resource)
colnames(case.document) <- c("Id", "Gender", "Family_Category", "Monitor", "Receive_Professional_Help",
                             "Social_Found", "Special_Disease", "Disable", "Family_Problem_Summary",
                             "School_Visit_Summary", "Family_Background_Summary", "Case_Received_Resources")

total.case.document <- rbind(total.case.document, case.document)
}




# add label ---------------------------------------------------------------
label <- c("",
  "",
  "家暴家庭(開案時即有)/兒少行為偏差(偷竊105.12/霸凌104.11)",
  "吸毒(開案時即有102.05入監服刑)/兒少行為偏差(偷竊105.12/霸凌105.04)",
  "",
  "家暴家庭(開案時即有)/兒少遭受霸凌(可能風險)",
  "家暴(可能風險)",
  "兒少遭受霸凌(可能風險)/家暴(言語暴力可能風險)/兒少偏差行為(偷竊可能風險)/疏於照顧(可能風險)",
  "",
  "自殺風險",
  "失業(106.02)",
  "自殺(102.12/105.01)/兒少偏差行為(偷竊105.12)",
  "吸毒(開案前即有/105.02再次被發現)/家暴(開案前即有)/酗酒(未來可能風險)",
  "家暴(105.03)/失業(105.11)/霸凌(霸凌或被霸凌:可能風險)",
  "家暴(105.01)/吸毒(104.08)/ 自殺(可能風險)",
  "失業(可能風險)/酗酒(可能風險)",
  "",
  "家暴(可能風險)/兒少行為偏差(偷竊105.04/用酒&檳榔105.04)/失業(可能風險)",
  "失業(104.06)/性侵及亂倫(可能風險)",
  "家暴(可能風險)/遭受霸凌(可能風險)",
  "家暴(可能風險)/吸毒(可能風險)/霸凌(可能風險)/兒少中輟(可能風險)",
  "兒少遭受霸凌(可能風險)",
  "家暴(開案時即有-前夫)",
  "兒少遭受霸凌(可能風險)",
  "酗酒(可能風險)",
  "",
  "吸毒(開案時即有)/兒少偏差行為(開案時即有，本會發現偷竊105.05/105.12)",
  "",
  "兒少偏差行為(偷竊105.09)",
  "家暴(開案時即有)/吸毒(開案時即有)/自殺(開案時即有/105.11)/失業(105.11)/疏於照顧(可能風險)",
  "性侵(可能風險)/酗酒(可能風險)",
  "兒少遭受霸凌(可能風險)/家暴(原生家庭)",
  "",
  "吸毒(開案前即有)/疏於照顧(開案前即有)/兒少偏差行為(偷竊103.10)",
  "",
  "疏於照顧(開案前即有)",
  "家暴(102.10)/兒少偏差行為(逃家103.09/暴力104.05、105.02)",
  "",
  "家暴(開案前即有)/疏於照顧(開案前即有)/兒少偏差行為(104.12、105.04、105.05)/棄養(未來可能風險)",
  "吸毒(開案前即有)",
  "兒少偏差行為(偷竊104.05)",
  "兒少偏差行為(偷竊103年)/疏於照顧(可能風險)",
  "",
  "",
  "疏於照顧(105年)",
  "",
  "家暴(開案前即有)/性侵(102年)/兒少偏差行為(可能風險)",
  "家暴(開案前即有)",
  "兒少行為偏差(性偏差102年)/兒少行為偏差(因性偏差未來可能觸法風險)",
  "兒少偏差行為(偷竊104.06)/疏於照顧(可能風險)",
  "家暴(開案前即有)/疏於照顧(開案前即有，103.10再發生)/兒少偏差行為(可能風險)",
  "",
  "",
  "",
  "家庭偷竊行為(105.06)",
  "",
  "",
  "")

total.case.document <- total.case.document %>% mutate(Risk_Labels = label)
write.csv(total.case.document,
          file = "Case_Family_Documents.csv",
          fileEncoding = "utf-8")




# test section ------------------------------------------------------------
case.id
case.gender
case.family.category
case.monitor
case.prof.assist
case.social.fund
case.special.disease
case.disable
case.str.family.problem.summary
case.str.school.visit
case.str.background
case.receive.resource


