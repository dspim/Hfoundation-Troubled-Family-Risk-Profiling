load("loading1.RData")
load("relationship_association.Rdata")
library(shiny)
library(ggplot2)
library(gridExtra)
library(grid)
library(plotly)
library(magrittr)
library(purrr)
library(lubridate)
library(stringr)
library(dplyr)

risk_mapping_table$dscpt = iconv(as.character(risk_mapping_table$dscpt), from = 'UTF-8')
high_level = 5
initial_risk_levels_table$level[initial_risk_levels_table$level==3] = high_level
risk_mapping_table$level[risk_mapping_table$level==3] = high_level
risk_mapping_table$dscpt = gsub("功","公",risk_mapping_table$dscpt)

# transform the date
transformTime <- function(date){
    date <- date %>% map(as.character) %>%
        str_split("/") %>%
        map(.,function(x){x[1] <- as.numeric(x[1])+1911;return(x)}) %>%
        map_chr(~reduce(.,paste,sep="-")) %>% ymd
    
    return(date)
}

large_zero <- function(number){
    return(number >0)} 

factor.summarise <- function(x, col){
    
    for (i in col){
        x[,i] <- sapply(x[,i],large_zero)
    }
    return(x)
}


# Define server logic required to summarize and view the selected
# dataset
shinyServer(function(input, output) {
  
  # Return the requested dataset
  datasetInput <- reactive({
    data[data[, 1] == input$dataset, 2:ncol(data)]  
  })
  get_initial_risk<- reactive({ 
	initial_risk_levels_table[initial_risk_levels_table$Id==input$dataset,"level"]
	
  })
  
  datasetTime <- reactive({
      datasetInput() %>% mutate(Date = transformTime(Date))
  })
  
  dataRecentFactor <- reactive({
      choose.time <-as.Date("1970-01-01") + as.numeric(input$RecentTimeChoose)
      tmp <- datasetTime()
      index <- tmp %>% filter(Date > choose.time) %>% dplyr::select(-Date) %>% summarise_each(funs(sum))
      colnames(tmp)[index > 0]
  })
  
  
  output$datavars <- renderUI({
    data <- datasetInput()
    data1 <- data[, -1]
    happenedname <- colnames(data1)[apply(data1, 2, sum) != 0]
	  names(happenedname) = risk_mapping_table$dscpt[match(happenedname,risk_mapping_table$index)]
	  selectInput("vars", label = "請選擇想要檢視的風險因子", happenedname,  multiple=TRUE, selectize=F, selected = happenedname[1:3])
  })

  ### New Pie chart
  output$Pie_Chart_new = renderPlotly({
    data <- datasetInput()
    data1 <- data[, -1]
    tofactor <-  LETTERS[1:7]
    name <- c('經濟', '教育', '保護＆照顧', '居住', '生育', '情感', '其他')
    count <- apply(data1, 2, sum)
    #print(count)
    count.type <- sapply(1:7, FUN = function(x){
      location <- grep(tofactor[x], colnames(data1))
      bprob <- sum(count[location])
      return(bprob)
    })
    plot_ly(labels = name, values = count.type, type = 'pie') %>%
      layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
  })
  
 

  ### Bar_chart_Single
  for(FactorType in LETTERS[1:7]){
    local({
      myFactor <- FactorType
      output[[paste0("Hist_",myFactor)]]= renderPlotly({
        data <- datasetInput()
        data1 <- data[, -1]
        count <- as.data.frame(as.table(apply(data1, 2, sum)))
        names(count)[1] <- "Factor"
        count %<>% filter(Freq!=0) %>% arrange(desc(Freq))
        loc2 <- grep(myFactor, count[, 1])
        subcount <- count[loc2, ]
		    plot_data = subcount[subcount[, 2] != 0,  ]
        plot_data$Factor = risk_mapping_table$dscpt[match(plot_data$Factor, risk_mapping_table$index)]
        plot_data$Factor = factor(as.character(plot_data$Factor), levels = as.character(plot_data$Factor))
        p <- plot_ly(plot_data, x = ~Factor, y = ~Freq, type = 'bar', color = ~Factor) %>%
             layout(yaxis = list(title = '頻率'), xaxis = list(title = '風險因子'), barmode = 'group')
        p
      })
    })
  }

  #### TimeplotNew
  output$TimeplotNew <- renderPlotly({
    data <- datasetInput()
    data1 <- data[, -1]
    loc1 <- which(colnames(data1) %in% input$vars)
    subdata <- data1[, loc1, drop = F]
    subdata$x <- 1:nrow(subdata)
    subdata_colnames = risk_mapping_table$dscpt[match(colnames(subdata), risk_mapping_table$index)]
    p <- plot_ly(subdata, x = ~x, y = as.formula(paste0("~",colnames(subdata)[1])), name = subdata_colnames[1], 
                type = 'scatter', mode = 'lines') 
    if(ncol(subdata)>2){
      for(i in 2:(ncol(subdata)-1)){
        p %<>% add_trace(y = as.formula(paste0("~", colnames(subdata)[i])), name = subdata_colnames[i], mode = 'lines')
      } 
    }
    xaxis = list(title = "時間點")
	  yaxis_list = list(title = "是否發生",
                      tickvals = c(0,1),
                      ticktext = c("否","是"),
                      range = c(-0.5, 1.5))
    p %>% layout(showlegend = T, xaxis = xaxis, yaxis = yaxis_list)
  })
  
  #### TimeRiskLevels
  output$TimeRiskLevels <- renderPlotly({
	data <- datasetInput()
	risk_score = risk_mapping_table[match(colnames(data)[-1], risk_mapping_table$index),"level"]

	df = data.frame(
	  Date = data$Date,
	  Risk=as.matrix(data[, -1]) %*% matrix(risk_score,ncol=1) /apply(as.matrix(data[, -1]),1,sum)
	)
	df$Level=1+(df$Risk >=1.5) +( df$Risk >=3)


	p <- plot_ly(type = "scatter",mode="markers")
	initial_risk_score = get_initial_risk()
	initial_risk_levels = 1+(initial_risk_score >=1.5) +( initial_risk_score >=3)
	p <- add_trace(p,
				   x = c(0,1)-.5, 
				   y = 0, 
				   mode = "lines",
				   line = list(color = c("green","yellow","red")[initial_risk_levels], width = 50),
				   showlegend = F,
				   hoverinfo = "text",
				   text = paste("[開案初期]<br>",
								"風險高低: ", c("低","中","高")[initial_risk_levels], "<br>")
				   #evaluate = T
	)

	for(i in 1:(nrow(df) - 1)){
	  p <- add_trace(p,
					 x = c(i,i+1)-.5, 
					 y = 0, 
					 mode = "lines",
					 line = list(color = c("green","yellow","red")[df$Level[i]], width = 50),
					 showlegend = F,
					 hoverinfo = "text",
					 text = paste("[第",i,"次訪談]<br>",
					   "風險高低: ", c("低","中","高")[df$Level[i]], "<br>",
								  "訪談時間: ", df$Date[i], "<br>")#,
					 #evaluate = T
	  )
	}
	yaxis_list = list(tickvals = 0,
					  ticktext = "警示燈號")
	xaxis_list = list(title = "訪談次數",
					  tickvals = 0:(nrow(df) - 1),
					  ticktext = c("初期",1:(nrow(df) - 1)))
	p %>% layout(showlegend = T,yaxis = yaxis_list,xaxis=xaxis_list)


  })
  
  output$RecentIntViewTime <- renderValueBox({
      valueBox(subtitle = "最近訪談時間", value = max(datasetTime()$Date), color="orange")
  })
  output$FollowPeriod <- renderValueBox({
      valueBox(subtitle = "開案時間", value =ymd(min(datasetTime()$Date)), color="orange")
  })
  
  output$TimePeriodChoose <- renderUI({
      sliderInput(inputId = "RecentTimeChoose",
                  label = "",
                  ticks = TRUE,
                  timeFormat = "%F",
                  min = min(datasetTime()$Date),
                  max = max(datasetTime()$Date),
                  value = max(datasetTime()$Date) )
  })
  
  output$RecentRiskFactor <- DT::renderDataTable({
      recentRiskFactor.select <- risk_mapping_table %>% filter(index %in% dataRecentFactor()) 
      colnames(recentRiskFactor.select) <- c("編碼", "解釋")
      DT::datatable(recentRiskFactor.select, options = list(orderClasses = TRUE))
      
  })
  output$PossibleRiskFactor <- DT::renderDataTable({
      possiblerisk <- relationship.association %>% filter(left %in% dataRecentFactor()) %>% with(right)
      recentRiskFactor.select <- risk_mapping_table %>% filter(index %in% possiblerisk & !(index %in% dataRecentFactor())) 
      colnames(recentRiskFactor.select) <- c("編碼", "解釋")
      DT::datatable(recentRiskFactor.select, options = list(orderClasses = TRUE))
  })
  

  
})

