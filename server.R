library(ggplot2)
library(plotly)
library(dplyr)
library(tidyverse)

kb_df <- read.csv("https://raw.githubusercontent.com/the-pudding/data/master/kidz-bop/KB_censored-lyrics.csv", stringsAsFactors = F)

server <- function(input, output) {
  
  # output tab 1
  
  output$time_lineplot <- renderPlotly({
    
    unique_og_lyrics <- kb_df %>%
      distinct(across(-count))
    
    total_censored <- unique_og_lyrics %>%
      group_by(year) %>%
      summarize(total_unique_instances = n()) %>%
      filter(year >= input$year_selected[1] & year <= input$year_selected[2])
    
    censorship_over_time <- ggplot(data = total_censored) +
      geom_line(mapping = aes(x = year, y = total_unique_instances)) +
      geom_point(mapping = aes(x = year, y = total_unique_instances,
                               text = paste(
      "In the year", year, "there were", total_unique_instances, "unique instances
of censorship in the newest Kidz Bop record."))) +
      scale_x_continuous(breaks = seq(min(total_censored$year), 
                                      max(total_censored$year), by = 1)) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
      labs(
        title = "Rate of Censorship in Kidz Bop Songs Over Time",
        x = "Year (2001 to 2019)",
        y = "Total Unique Instances of Censorship"
      )
    
    ggplotly(censorship_over_time, tooltip = "text")
    
    return(censorship_over_time)
    
  })
  
  # output tab 2
  output$category_hist <- renderPlotly({
    
    filtered_df <- kb_df %>% 
      # Filter for category
      filter(category %in% input$category_selection) %>% 
      filter(year >= input$year_selection[1] & year <= input$year_selection[2])
  
    category_hist <- ggplot(data = filtered_df) +
      geom_histogram(aes(x = year, fill = category),
                     position = "dodge",
                     binwidth = 0.5) + 
      labs(title="Distribution of Censored Lyric Categories in Kidz Bop Over Time",
           x ="Year", 
           y = "Censorship Frequency")
#    updateSelectizeInput(session, 'category_selection', 
#                         choices = c("alcohol & drugs", "profanity", "sexual",
#                                     "identity", "other", "violence"), 
#                         server = TRUE)
    return(category_hist)
    
    
  }) #+
  
  # output tab 3
  output$scatter_plot <- renderPlotly({
    
    by_badword <- kb_df %>% 
      group_by(badword) %>% 
      mutate(word_total = sum(count, na.rm = TRUE))
    
    badword_filtered <- by_badword %>% 
      filter(ogArtist %in% input$artist_select) %>% 
      filter(category %in% input$categories_selection) 
    
    scattered_artist <- ggplot(data = badword_filtered) +
      geom_point(aes(x = category, 
                     y = ogArtist,
                     size = word_total)) + 
      labs(title="Censorship by Artist by Category",
           x ="", 
           y = "")
    
    return(scattered_artist) 
    
  })
  
}