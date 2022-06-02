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
  
  # output tab 1
  
  output$time_lineplot <- renderPlotly({
    
    unique_og_lyrics <- kb_df %>%
      distinct(across(-count))
    
    total_censored <- unique_og_lyrics %>%
      group_by(year) %>%
      summarize(total_unique_instances = n())
    
    censorship_over_time <- ggplot(data = total_censored) +
      geom_line(mapping = aes(x = year, y = total_unique_instances)) +
      geom_point(mapping = aes(x = year, y = total_unique_instances)) +
      scale_x_continuous(breaks = seq(2001, 2019, by = 1)) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
      labs(
        title = "Rate of Censorship in KidzBop Songs Over Time",
        x = "Year (2001 to 2019)",
        y = "Total Unique Instances of Censorship"
      )
    
    ggplotly(censorship_over_time)
    
    return(time_lineplot)
    
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