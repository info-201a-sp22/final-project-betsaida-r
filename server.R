library(ggplot2)
library(plotly)
library(dplyr)
library(tidyverse)

kb_df <- read.csv("https://raw.githubusercontent.com/the-pudding/data/master/kidz-bop/KB_censored-lyrics.csv", stringsAsFactors = F)

by_artist <- kb_df %>% 
  group_by(ogArtist) %>% 
  mutate(artist_total = sum(count, na.rm = TRUE))

by_category <- by_artist %>% 
  group_by(category) %>% 
  select(category, count) %>% 
  mutate(wordtotal = sum(count)) %>% 
  distinct(category, .keep_all = TRUE)

category_breakdown <- by_category %>% 
  group_by(category) %>% 
  mutate(percent_column = (paste0(round((wordtotal/2966)*100), "%")))

server <- function(input, output) {
  
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
    
    return(category_hist)
    
  }) #+
  
  # output tab 3
  output$category_pie <- renderPlotly({

    category_filtered <- category_breakdown %>% 
      filter(category %in% input$categories_selection)  
#      filter(year %in% input$years_selection)
    
    # make pie chart
#    pie_chart <- ggplot(category_filtered, 
##                        aes(x = year),
#                        aes(x = "",
#                            y = song_total,
#                            fill = category)) +
#      geom_bar(stat = "identity", width = 1) +
#      coord_polar("y", start = 0)
    
#    return(pie_chart)
    
    category_pie <- ggplot(data = category_breakdown,
                           aes(x = "",
                               y = wordtotal,
                               fill = category)) +
      geom_col() +
      coord_polar("y", start = 0) +
      theme(panel.background = element_blank(),
            axis.line = element_blank(),
            axis.text = element_blank(),
            axis.ticks = element_blank(),
            axis.title = element_blank(),
            plot.title = element_text(hjust = 0.5, size = 18)) +
      geom_text(aes(label = percent_column),
                position = position_stack(vjust = 0.5)) +
      labs(title = "Category Breakdown", 
           x = "", 
           y = "")
    
    return(category_pie)
    
  }) 
  
}