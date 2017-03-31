rm(list=ls()) 
library(arules)
df <- read.table("C:\\Users\\NingYuan\\Data_SparseForm.csv", header = TRUE, sep = ",")
df$Id <- NULL
df$Date <- NULL
rule = c()

for (itm in list("A","B","C","D","E","F","G")) {
df.iter <- df
df.iter <- df.iter [substring(colnames(df.iter),0,1)==itm ]
trans <- as(data.matrix(df.iter),"transactions")
rule.iter <- apriori(trans, parameter = list(support=0.006,confidence=0.6))
rule <- c(rule, rule.iter )
}
inspect(head(rule[[1]],5))

idx2=1
for (itm in list("A","B","C","D","E","F","G")) {
set <- subset(rule[[idx2]] , subset = lift>1.2) 
inspect(set)
idx2<-idx2+1
}




