library(shinydashboard)
library(plotly)
load("loading.RData")
dashboardPage(skin = "green",
  
  dashboardHeader(
    title = "D4SG X 漢慈"
  ),
  
    

  dashboardSidebar(
    selectInput("dataset", 
                label ="個案代號:", 
                choices = names),
    
    sidebarMenu(
      menuItem("歷史資料", tabName = "past", icon = icon("address-book-o"),
			   menuItem("風險因子警示燈號", tabName = "light", icon = icon("lightbulb-o")),
               menuItem("風險因子組成比例", tabName = "pie", icon = icon("pie-chart")),
               menuItem("各類風險因子出現頻率", tabName = "bar", icon = icon("bar-chart")),
               menuItem("風險因子變化趨勢", tabName = "time", icon = icon("line-chart"))
              ),
      menuItem("此次資料", tabName = "present", icon = icon("user-o")),
      menuItem("未來風險預測", tabName = "future", icon = icon("user-circle"))
    )
    ),

  dashboardBody(
    tabItems(
      tabItem(tabName = "past",
              h2("Pesent!")
      ),
      tabItem(tabName = "light",
              fluidRow(
				box(
                  title = "歷史風險因子警示燈號", status = "primary", solidHeader = TRUE,
                  width = 12, collapsible = TRUE,
				  height=5,
                  plotlyOutput("TimeRiskLevels")
                )
              )
             ),
      tabItem(tabName = "pie",
              fluidRow(
                box(
                  title = "風險因子組成比例", status = "primary", solidHeader = TRUE,
                  width = 12, collapsible = TRUE,
                  plotlyOutput("Pie_Chart_new")
                )
              )
             ),
      
      tabItem(tabName = "bar",
              fluidRow(
                tabBox(
                  title = "各類風險因子出現頻率", side = "right", width = 12,
                  id = "tabset1", 
                  tabPanel('其他', plotlyOutput("Hist_G")),
                  tabPanel('情感', plotlyOutput("Hist_F")),
                  tabPanel('生育', plotlyOutput("Hist_E")),
                  tabPanel('居住', plotlyOutput("Hist_D")),
                  tabPanel('保護＆照顧', plotlyOutput("Hist_C")),
                  tabPanel('教育', plotlyOutput("Hist_B")),
                  tabPanel('經濟', plotlyOutput("Hist_A"))
                )
                
              )
             ),

      tabItem(tabName = "time",
              fluidRow(
                box(title = "主要風險因子", status = "info", solidHeader = TRUE,
                    width=4,
                    uiOutput("datavars")
                ),
                box(
                  title = "風險因子變化", status = "warning", solidHeader = TRUE,
                  width =8,
                  plotlyOutput("TimeplotNew")
                )
              )
            
              
             ),
      
      tabItem(tabName = "present",
              fluidRow(
                  valueBoxOutput(outputId = "RecentIntViewTime", width = 3),
                  valueBoxOutput(outputId = "FollowPeriod", width = 3),
                  box(title = "時間區間選擇", status = "info", solidHeader = TRUE,
                      uiOutput("TimePeriodChoose"))),
              
              fluidRow(
                  box(title = "現在發生危險因子", status = "info", solidHeader = TRUE, width = 4,
                      DT::dataTableOutput("RecentRiskFactor")),
                  box(title = "潛在發生危險因子", status = "info", solidHeader = TRUE, width = 4,
                      DT::dataTableOutput("PossibleRiskFactor")),
                  box(title = "未來發生危險因子", status = "info", solidHeader = TRUE, width = 4)
              )
      ),
      tabItem(tabName = "future",
              h2("Future!")
      )
    )
  )
    

)