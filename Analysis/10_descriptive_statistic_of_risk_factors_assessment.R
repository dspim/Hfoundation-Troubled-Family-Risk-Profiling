library(ggplot2)
library(dplyr)
## 
## Attaching package: 'dplyr'
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
rf <-  read.csv("SummaryRisk.csv",header = TRUE,fileEncoding = "BIG5") 
rf <- mutate(rf,風險編號2 = substring(rf$風險編號,0,1))
factor <-  filter(rf,風險編號2 != "N")
factor  <-  filter(factor,風險編號2 !="")
table(factor$風險編號2)
## 
##   A   B   C   D   E   F   G 
## 401 727 565 158  26 327 154
ggplot(factor,aes(x = 風險編號2,fill = 風險編號2)) +geom_bar() + theme(text = element_text(family = "楷體-繁 黑體",size = 10))+
  scale_fill_discrete(name="Riskfactor",breaks=c("A", "B", "C","D","E","F","G"),
labels=c("經濟功能", "教育功能","保護與照護功能","居住安全","生育功能","情感功能","其它"))
# Factor A
A <- filter(rf,風險編號2 == "A")
ggplot(rfc_A,aes(x = 風險編號,fill = 風險編號)) + 
       geom_bar() +
      theme(text = element_text(family = "楷體-繁 黑體",size = 7))


# Factor B
rfc_B <- filter(rf,風險編號2 == "B")
ggplot(rfc_B,aes(x = 風險編號,fill = 風險編號)) + 
       geom_bar() +
       theme(text = element_text(family = "楷體-繁 黑體",size = 7))

# Factor C
rfc_B <- filter(rf,風險編號2 == "B")
ggplot(rfc_B,aes(x = 風險編號,fill = 風險編號)) + 
       geom_bar() +
       theme(text = element_text(family = "楷體-繁 黑體",size = 7))

# Factor D
rfc_B <- filter(rf,風險編號2 == "B")
ggplot(rfc_B,aes(x = 風險編號,fill = 風險編號)) + 
       geom_bar() +
       theme(text = element_text(family = "楷體-繁 黑體",size = 7))

# Factor E
rfc_B <- filter(rf,風險編號2 == "B")
ggplot(rfc_B,aes(x = 風險編號,fill = 風險編號)) + 
       geom_bar() +
       theme(text = element_text(family = "楷體-繁 黑體",size = 7))

# Factor F
rfc_B <- filter(rf,風險編號2 == "B")
ggplot(rfc_B,aes(x = 風險編號,fill = 風險編號)) + 
       geom_bar() +
       theme(text = element_text(family = "楷體-繁 黑體",size = 7))

# Factor G
rfc_B <- filter(rf,風險編號2 == "B")
ggplot(rfc_B,aes(x = 風險編號,fill = 風險編號)) + 
       geom_bar() +
       theme(text = element_text(family = "楷體-繁 黑體",size = 7))



















