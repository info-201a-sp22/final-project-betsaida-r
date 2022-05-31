library(ggplot2)
library(plotly)
library(dplyr)

kb_df <- read.csv("https://raw.githubusercontent.com/the-pudding/data/master/kidz-bop/KB_censored-lyrics.csv", stringsAsFactors = F)

server <- function(input, output) {
  
  output$category_hist <- renderPlotly({
    
    filtered_df <- kb_df %>% 
      # Filter for category
      filter(category %in% input$category_selection) %>% 
      filter(year >= input$year_selection[1] & year >= input$year_selection[2])
    
    category_hist <- ggplot(data = filtered_df) +
      geom_histogram(aes(x = year, fill = category),
                     position = "dodge",
                     binwidth = 0.5) + 
      labs(title="Distribution of Censored Lyric Categories in Kidz Bop Over Time",
           x ="Year", 
           y = "Censorship Frequency")
    
    return(category_hist)
    
  })
  
}