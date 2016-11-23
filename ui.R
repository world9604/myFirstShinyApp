library(shiny)
library(ggplot2) 
library(DT)
library(plyr)

fluidPage(
  title = '통계분석',
  navbarPage("",
  tabPanel("엑셀 업로드",
    sidebarLayout(
     sidebarPanel( 
           fileInput('file1', 'CSV 파일선택', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
           tags$hr(),
           checkboxInput('header', 'Header', TRUE),
           radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'),','),
           radioButtons('quote', 'Quote', c(None='', 'Double Quote'='"', 'Single Quote'="'"), '"')
          ),
     mainPanel( 
     tabsetPanel(
       tabPanel('CSV 파일정보', DT::dataTableOutput('contents'))))
  
  )), 
  
  tabPanel("통계표",        
  sidebarLayout(
    
    sidebarPanel(width = 4,
                 uiOutput("reacDomains"),
                 dateRangeInput('dateRange',label = '날짜 선택', start = '2010-01-01', end = Sys.Date() + 2)
                 ),
    
    
    mainPanel( 
      tabsetPanel(
                  tabPanel('지수들', DT::dataTableOutput('mytable1')),
                  tabPanel('지수들 분포', plotOutput("Plot1", height = "600px")),
                  tabPanel('지수 추이1', highchartOutput("highchart2", height = "600px")),
                  tabPanel('지수 추이2',plotOutput("Plot2", height = "600px")),
                  tabPanel('단순상관관계',plotOutput("Plot3", height = "600px"))
                  )
            )
      )
    )
  )
)  
