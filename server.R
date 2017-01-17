library(ggplot2);
library(DT);
library(reshape2);
library(xts);
library(shiny);


function(input, output) {
  #, 현재생활형편CSI, 현재경기판단CSI, 가게수입전망CSI, 소비지출전망CSI, 소비자심리지수, 선행종합지수, 선행지수.순환변동치, 동행종합지수, 동행지수.순환변동치             
  
  index <- NA;
  xts_index <- NA;
  
  
   output$contents <- DT::renderDataTable({
    
    inFile <- input$file1
    
    if (is.null(inFile))
    return(NULL)
    
     index <<- read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
     
      a<-paste(gsub(". ","/",index[,1]),"/01")
      a<-as.Date(a, format="%Y/%m /%d")
      index$시점<<-a
      
      xts_index <<- xts(index[,-1], index[,1])
      
      head(index)
      })
  
  
  
  output$reacDomains<- renderUI({
    checkboxGroupInput('show_vars', '표시 정보', names(index));
  })
  
  output$mytable1 <- DT::renderDataTable({
    
    
    DT::datatable(subset(index, select=c(input$show_vars), subset=(input$dateRange[1]<=시점 & input$dateRange[2]>=시점)))
    
    })

    output$Plot1 <- renderPlot({
    l0 <- subset(index, select=c(input$show_vars), subset=(input$dateRange[1]<=시점 & input$dateRange[2]>=시점))
    l1 <- melt(l0, id=c("시점"))
    ggplot(l1[ ], aes(x=variable, y=value, fill=variable) ) + 
          geom_boxplot(outlier.size=1, outlier.shape=21) +
          coord_flip()
    #boxplot(subset(index, select=c(input$show_vars), subset=(input$dateRange[1]<=시점 & input$dateRange[2]>=시점)))

  })
  
  output$highchart2 <-renderHighchart({
  
      highchart(type="stock")%>%
      hc_add_series_xts(xts_index[,1], name = "현재생활형편CSI")%>% 
      hc_add_series_xts(xts_index[,2], name = "현재경기판단CSI")%>% 
      hc_add_series_xts(xts_index[,3], name = "가게수입전망CSI")%>% 
      hc_add_series_xts(xts_index[,4], name = "소비지출전망CSI")%>% 
      hc_add_series_xts(xts_index[,5], name = "소비자심리지수")%>% 
      hc_add_series_xts(xts_index[,6], name = "선행종합지수")%>% 
      hc_add_series_xts(xts_index[,7], name = "선행지수.순환변동치")%>% 
      hc_add_series_xts(xts_index[,8], name = "동행종합지수")%>%
      hc_add_series_xts(xts_index[,9], name = "동행지수.순환변동치")%>%
      hc_legend(enabled = TRUE, align = "right", verticalAlign = "top", layout = "vertical", x = 0, y = 100)
    
    
    })        
  
  output$Plot3<- renderPlot({
    panel.cor <- function(x, y, digits=2, prefix="", cex.cor, ...) {
      usr <- par("usr")
      on.exit(par(usr))
      par(usr = c(0, 1, 0, 1))
      r <- abs(cor(x, y, use="complete.obs"))
      txt <- format(c(r, 0.123456789), digits=digits)[1]
      txt <- paste(prefix, txt, sep="")
      if(missing(cex.cor)) cex.cor <- 0.9/strwidth(txt)
      text(0.5, 0.5, txt, cex =  cex.cor * (1 + r) / 2)
    }
    pairs(subset(index, select=c(input$show_vars), subset=(input$dateRange[1]<=시점 & input$dateRange[2]>=시점)), upper.panel = panel.cor)
     
  })
  
  output$Plot2<- renderPlot({
    l0 <- subset(index, select=c(input$show_vars), subset=(input$dateRange[1]<=시점 & input$dateRange[2]>=시점))
    l1 <- melt(l0, id=c("시점"))  
      ggplot(l1[ ], aes(x=시점, y=value,color=variable) ) + 
      geom_line()
  })
  
}
