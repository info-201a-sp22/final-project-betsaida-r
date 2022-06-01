library(ggplot2)
library(plotly)
library(dplyr)

kb_df <- read.csv("https://raw.githubusercontent.com/the-pudding/data/master/kidz-bop/KB_censored-lyrics.csv", stringsAsFactors = F)

category_by_year <- kb_df %>% 
  group_by(year) %>% 
  mutate(song_total = sum(count, na.rm = TRUE)) %>% 
  select(year, song_total, category)

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
  output$pie_chart <- renderPlotly({

    category_filtered <- category_by_year %>% 
      filter(category %in% input$categories_selection) %>% 
      filter(year %in% input$years_selection)
    
    # make pie chart
    pie_chart <- ggplot(category_filtered, 
                        aes(x = "",
                            y = song_total,
                            fill = category)) +
      geom_bar(stat = "identity", width = 1) +
      coord_polar("y", start = 0)
    
    return(pie_chart)
    
  }) 
  
}