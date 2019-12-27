
#  #TABA Assignment by Sakshi Srivastava, Krishnakanth Narupusetty,Abhinav Singh, Neha Dubey,Aswani kumar Javvadi

#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
if (!require(shiny)) {install.packages('shiny')}
if (!require(shiny)) {install.packages('dplyr')}
if (!require(shiny)) {install.packages('tidytext')}
if (!require(shiny)) {install.packages('textrank')}
if (!require(shiny)) {install.packages('text2vec')}
if (!require(shiny)) {install.packages('tm')}
if (!require(shiny)) {install.packages('tokenizers')}
if (!require(shiny)) {install.packages('wordcloud')}
if (!require(shiny)) {install.packages('slam')}
if (!require(shiny)) {install.packages('stringi')}
if (!require(shiny)) {install.packages('magrittr')}
if (!require(shiny)) {install.packages('tidyr')}
if (!require(shiny)) {install.packages('plotly')}


library(shiny)
library(dplyr)
library(tidytext)
library(textrank)
library(text2vec)
library(tm)
library(tokenizers)
library(wordcloud)
library(slam)
library(stringi)
library(magrittr)
library(tidyr)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel(" Shiny App"),
    
    # Sidebar with a slider input for number of bins
    sidebarPanel(
        
        fileInput("file", "Upload text(.txt) file"),
        
      
        textInput("filterw", ("Enter keyword list separated by comma(,) to create corpus file"), value = "engine,mileage,comfort,performance,interirorm,maintenance,price")
        
    ),
    
    mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Overview",h4(p("How to use this App")),
                             
                             p("To use this app you need a text file  format.\n\n 
                       To upload the  text file, click on Browse in left-sidebar panel and upload the txt file from your local machine. \n\n
                       Once the file is uploaded, the shinyapp will compute a filtered word corpus file,word cloud,bargraph in the back-end with default inputs and accordingly results will be displayed in various tabs.", align = "justify")),
                    
                    tabPanel("Example dataset", h4(p("Download Sample text file")), 
                             downloadButton('downloadData1', 'Download car  reviews txt file'),br(),br(),
                             p("Please note that download will not work with RStudio interface. Download will work only in web-browsers. So open this app in a web-browser and then download the example file. For opening this app in web-browser click on \"Open in Browser\" as shown below -"),
                             img(src = "example1.png")),
                    
                    tabPanel("Article Sentences",
                             h4(p("Original Article Sentences")),
                             tableOutput("article_sentences")),
                    
                    tabPanel("Keyword filter corpus ouput into sentences ", 
                             h4(p("Keyword filter corpus ouput ")),
                             tableOutput("corpus_output")),
                    
                    tabPanel("Keyword filter corpus ouput into string ", 
                             h4(p("Keyword filter corpus ouput ")),
                             tableOutput("corpus_output_string")),
                    
                    tabPanel("Word Cloud from main file ", 
                             h4(p("Word Cloud plot ")),
                             #plotOutput("wordcloudcorpusfile"),
                             sidebarLayout(
                               # Sidebar with a slider and selection inputs
                               sidebarPanel(
                                 
                                 sliderInput("freq",
                                             "Minimum Frequency:",
                                             min = 1,  max = 10, value = 15),
                                 sliderInput("max",
                                             "Maximum Number of Words:",
                                             min = 1,  max = 50,  value = 40)
                               ),
                               mainPanel(
                                 plotOutput("wordcloud")
                                 
                               ))),
                    

                    
                    tabPanel("Word Cloud from first corpus output file ", 
                             h4(p("Word Cloud plot ")),
                             #plotOutput("wordcloudcorpusfile"),
                             sidebarLayout(
                               # Sidebar with a slider and selection inputs
                               sidebarPanel(
                                 
                                 sliderInput("freq1",
                                             "Minimum Frequency:",
                                             min = 1,  max = 10, value = 15),
                                 sliderInput("max1",
                                             "Maximum Number of Words:",
                                             min = 1,  max = 20,  value = 100)
                               ),
                               mainPanel(
                                 plotOutput("wordcloudcorpusfile")
                                 
                               ))),
                    
                    
                    tabPanel("Word Cloud from corpus file using filter keyword ", 
                             h4(p("Word Cloud plot ")),
                             plotOutput("wordcloudcorpusfile1")),
                    
                    tabPanel("Bar Graph using keywords", 
                             h5(p("Bar plot ")),
                             plotOutput("barplot"))
              
                    
                   
        )  # tabSetPanel closes
        
    )  # mainPanel closes
    
)
)  # fluidPage() & ShinyUI() close