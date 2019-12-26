
#TABA Assignment  by Sakshi Srivastava, Krishnakanth Narupusetty,Abhinav Singh, Neha Dubey,Aswani kumar Javvadi
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic  Reading txt file.
shinyServer(function(input, output) {
    
    
    dataset <- reactive({
        # Reading the .txt file
        if (is.null(input$file)) {return(NULL)}
        else {
            
            dataset = readLines(input$file$datapath)
            
            
            return(dataset)}
        
    })
    
require(dplyr)
require(magrittr)
require(tidytext)


    # Function to return sentences from a given text file used tiblle dataframe
    
text_clean = function(text_dump)  {
  corpus_output = tibble(text_dump) %>%
  unnest_tokens(sentence, text_dump, token = "sentences", to_lower=FALSE) %>%    # sentence-tokenizing the article   
  mutate(sentence_id = row_number()) %>%    # insert setence_id
  select(sentence_id, sentence)  # drop frivolous stuff  
  return(corpus_output)
}  




## From text file divide into sentence depends on the keywords provided in the text box
corpus_output <- reactive({
  
  dataset1 <<- text_clean(text_dump  = dataset())  # Dividing into sentences from a given file 

  
  mylist <- data.frame() # Copying the setences into a dataframe
  key=input$filterw  # Taking filter values
  key=gsub(",","|",key) # Seperating comman values and appending |(or)

       
  for (row in 1:nrow(dataset1)) {
    description <- dataset1[row, "sentence"]

    
    bool=grepl(tolower(key),tolower(description))
    if (bool==TRUE) {
      mylist<-rbind(mylist,description)  # Checking filter word is available in the sentence , if "yes" add into my list
    }
    }
     return(mylist)
  
    })

   
    output$corpus_output <- renderTable({ corpus_output() })
    
    
    ## From text file divide into a string  depends on the keywords provided in the text box (First outputfile)
    
    require(dplyr)
    require(magrittr)
    require(tidytext)
    
    ## load data into tibble
    corpus_output_string <- reactive({
      dataset1 <<- text_clean(text_dump  = dataset()) # Take the data from the file
      mylist <- data.frame()
      mystring<-NULL;
      key=input$filterw
      key=gsub(",","|",key) # Seperate the userinput from commas to form a "OR" conditon
      
      for (row in 1:nrow(dataset1)) {
        description <- dataset1[row, "sentence"]
        bool=grepl(tolower(key),tolower(description)) # Returning true or false depending on the userinput values and sentences
        
        if (bool==TRUE) { # If it is true form a sentence and a string
          mylist<-rbind(mylist,description)
          mystring<-paste(mystring,description,sep=" ") # Forming a string 

        }

      }

      return(mystring)
    })
    
    
    output$corpus_output_string <- renderTable({ corpus_output_string() })  #Rerurning as a string
    
  
     # Word cloud for the main file (user input file)
    
    library("tm")
    library("SnowballC")
    library("wordcloud")
    library("RColorBrewer")
      
    output$wordcloud <- renderPlot({
      t_data <- readLines(input$file$datapath)
      docs <- Corpus(VectorSource(t_data))
      # Data cleaning
      
      docs_data<-tm_map(docs,stripWhitespace)
      docs_data<-tm_map(docs_data,tolower)
      docs_data<-tm_map(docs_data,removeNumbers)
      docs_data<-tm_map(docs_data,removeNumbers)
      docs_data<-tm_map(docs_data,removePunctuation)
      docs_data<-tm_map(docs_data,removeWords, stopwords("english")) # General stop words in english
      docs_data<-tm_map(docs_data,removeWords, c("that","for","are","also","more","has","must","have","should","this","with"))
                        
      
      dtm <- TermDocumentMatrix(docs_data) # Creating document to matrix
      
      matr <- as.matrix(dtm) #matrix
      fre<- sort(rowSums(matr),decreasing=TRUE)  # Frequencies of the words
      d <- data.frame(word = names(fre),freq=fre)
     
      pal2 <- brewer.pal(8,"Dark2")
      
      
      #Creating the word cloud 
      wordcloud(words = d$word, freq = d$freq, min.freq = input$freq,
                max.words=input$max, random.order=FALSE, rot.per=0.35, 
                colors=pal2)
    })
    
    
    # Word cloud for the generated file from the keywords 
    library("tm")
    library("SnowballC")
    library("wordcloud")
    library("RColorBrewer")
    
     output$wordcloudcorpusfile <- renderPlot({
      dataset1 <<- text_clean(text_dump  = dataset())
      
      mylist <- data.frame()
      mystring<-NULL;
      key=input$filterw
      key=gsub(",","|",key)
      
      # print(mylist)
      for (row in 1:nrow(dataset1)) {
        description <- dataset1[row, "sentence"] # Creating string from the inputfile and filtered keywords
         bool=grepl(tolower(key),tolower(description))
        if (bool==TRUE) {
          mylist<-rbind(mylist,description)
          mystring<-paste(mystring,description,sep=" ") 

        }
        
      }


      t_data <- mystring # Word cloud for first out corpus string
      
      docs <- Corpus(VectorSource(t_data))
      # Cleaning the data 
      docs_data<-tm_map(docs,stripWhitespace)
      docs_data<-tm_map(docs_data,tolower)
      docs_data<-tm_map(docs_data,removeNumbers)
      docs_data<-tm_map(docs_data,removeNumbers)
      docs_data<-tm_map(docs_data,removePunctuation)
      docs_data<-tm_map(docs_data,removeWords, stopwords("english")) # General stop words in english
      docs_data<-tm_map(docs_data,removeWords, c("that","for","are","also","more","has","must","have","should","this","with"))
      
      dtm <- TermDocumentMatrix(docs_data)   # Creating document to matrix
      
      matr <- as.matrix(dtm) 
      fre <- sort(rowSums(matr),decreasing=TRUE)  #Frequencies of the words
      d <- data.frame(word = names(fre),freq=fre)
      
      pal2 <- brewer.pal(8,"Dark2") #Word cloud for corpus output
       
      wordcloud(words = d$word, freq = d$freq, min.freq = input$freq1,
                max.words=input$max1, random.order=FALSE, rot.per=0.35, 
                colors=pal2)
    })
    
    
     
     
     # Word cloud for the generated file from the keywords provided by the user (only keywords)
     library("tm")
     library("SnowballC")
     library("wordcloud")
     library("RColorBrewer")
     
       output$wordcloudcorpusfile1 <- renderPlot({
       dataset1 <<- text_clean(text_dump  = dataset())
      filedata <- readLines(input$file$datapath)
 
       filedata<-tolower(filedata)
      
       docs <- Corpus(VectorSource(filedata))
       
       dtm <- TermDocumentMatrix(docs)
       matr <- as.matrix(dtm)
       fre <- sort(rowSums(matr),decreasing=TRUE)
       d <- data.frame(word = names(fre),freq=fre)
       key=input$filterw
       key=tolower(key)
       wrd <- c(unlist(strsplit(key,",")))
   
       wrd_data <- d %>% filter(word %in% wrd)
       pal2 <- brewer.pal(8,"Dark2") #Word cloud for corpus output
       
       wordcloud(words = wrd_data$word, freq = d$freq, min.freq = input$freq1,
                 max.words=input$max1, random.order=FALSE, rot.per=0.35, 
                 colors=pal2)
     })
     

      # Bar plot for filter words 
       output$barplot <- renderPlot({
      filedata <- readLines(input$file$datapath)
      filedata<-tolower(filedata)
      docs <- Corpus(VectorSource(filedata))
      
      dtm <- TermDocumentMatrix(docs)
      matr <- as.matrix(dtm)
      fre <- sort(rowSums(matr),decreasing=TRUE)
      d <- data.frame(word = names(fre),freq=fre)
      
      key=input$filterw
      key=tolower(key)
      wrd <- c(unlist(strsplit(key,",")))
      wrd_data <- d %>% filter(word %in% wrd)
      par(mar=c(8,4,4,4))
    
      barplot(wrd_data$freq, las = 2, names.arg = wrd_data$word,
              col ="lightblue", main ="Most frequent words",
              ylab = "Word frequencies")
    })
    
    
    # Downloading sample file
    output$downloadData1 <- downloadHandler(
      filename = function() { "carreviews.txt" },
      content = function(file) {
        writeLines(readLines("data/carreviews.txt"), file)
      }
    )
    
    require(dplyr)
    require(magrittr)
    require(tidytext)
    
    ## Dividining the text file into sentences (first tab)
    article_sentences <- reactive({
        
        article_sentences = tibble(text = dataset()) %>%
            unnest_tokens(sentence, text, token = "sentences", to_lower=FALSE) %>%    # sentence-tokenizing the article   
            mutate(sentence_id = row_number()) %>%    # insert setence_id
            select(sentence_id, sentence)  # drop frivolous stuff
        
        return(article_sentences)
    })
    
    output$article_sentences <- renderTable({ article_sentences() })
   
    })
   


#num_sents <- reactive({ if (is.null(input$num)) {return(5)} })
#num_sents <- input$num

    
        
