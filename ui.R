library(ggplot2)
library(plotly)
library(bslib)
library(markdown)
library(shiny)
source('server.R')

unique_artist <- kb_df %>% 
  group_by(songName) %>% 
  mutate(artist_total = sum(count, na.rm = TRUE)) %>% 
  group_by(ogArtist) %>% 
  select(ogArtist, year, count) %>% 
  mutate(word_total = sum(count)) %>% 
  distinct(ogArtist, .keep_all = TRUE)


my_theme <- bs_theme(bg = "#0b3d91",
                     fg = "white", 
                     primary = "#FCC780")

my_theme <- bs_theme_update(my_theme, bootswatch = "sketchy")

# Home page tab
intro_tab <- tabPanel(
  # Title of tab
  "Overview",
  fluidPage(
    h1("Cens*rship in Kidz Bop Songs"),
    img(src = "https://upload.wikimedia.org/wikipedia/commons/9/96/KIDZBOP_Core_Logo_Treated.png",
        width = "600",
        height = "400"),
    h2("Introduction"),
    includeMarkdown("intro_text.md")
  )
)

# Tab 1
tab_1 <- tabPanel(
  "Censorship Over Time",
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "year_selection",
                  label = h3("Select Years:"),
                  min(min(kb_df$year)),
                  max(max(kb_df$year)),
                  sep = "",
                  step = 1,
                  value = c(2001,2019))
      ),
    mainPanel(
      plotlyOutput(outputId = "time_lineplot"),
      p("This plot shows the overall rate of censorship of KidzBop songs over time and provides insight to whether music for kids has gotten more or less censored over time. The songs in the dataset go as far back as 2001 and are as recent as 2019. A song's lyrics could be censored multiple times, some of those times involve unique instances of different censored words and how they are used in the lyrics, and other times where the same censored words and their respective lyrics were repeated. Total unique instances refers to the unique lyrics and circumstances that were censored in order to focus on the more thoughtful censorship choices that were being made. Repeated lyrics were not counted.
"),
      h2("Findings"),
      p("There is an overall positive trend: song lyrics have gotten more censored over time. The lowest amount of censored lyrics was in 2001 with 3, and the highest amount of censored lyrics was in 2019 with 123. In the early 2000's, the number of censored lyrics on Kidz Bop albums were not significantly different from each other. The first big jump occurred in 2006 with the instances of censored lyrics being nearly five times larger than the previous year. In 2007, the number of instances skyrocketed to 47. Since then, the trend has been mostly positive. While there have been drops in the instances of censored lyrics, those drops have never dipped below 20 since 2006 and many of the increases are above 47. The biggest jump between two years occurred between 2008 and 2009, with instances going from 22 to 58, a jump more than double the amount."),
      p("These observations prompt many questions. Have song lyrics actually gotten more explicit over time, according to the censorship standards Kidz Bop had back in 2001? Have pop songs in general become more explicit in recent years? Or have Kidz Bop's standards for censorship gotten more strict over time, with uncensored lyrics from years past being censored in current songs?"),
      p("Unfortunately, data on the number of songs on each year's Kidz Bop album, as well as what all of the songs on those albums were, was not in the data set. In order to get closer to answering these questions, we'd need to collect that information in order to see the proportion or rate of censored content in an album, as well as apply today's Kidz Bop censorship standards to the songs included in past albums to see if those standards themselves have changed."),
      p("Regarding the occasional drops in censorship, these drops could potentially be explained as either less overall censoring due to the song selection for that year's edition of Kidz Bop or a lack of representation for said year in the dataset. 2001 could have potentially had top hits that were just as worth censoring in 2019, but they simply are not represented as well. These drops also aren't consistent. They more so happen sporadically, which could also be a representation issue or a reflection of fluctuating trends."),
      p("Nonetheless, we do see a very noticeable positive trend that indicates that Kidz Bop lyrics have been more and more censored over time.")
    )
  )
)

# Tab 2
tab_2 <- tabPanel(
  "Censorship by Category",
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "category_selection",
        label = h4("Select Categories to Compare:"),
        choices = c(kb_df$category),
        # True allows you to select multiple choices...
        multiple = T,
        selected = c("alcohol & drugs", "sexual", "profanity")
      ),
#      sliderInput(
#        inputId = "year_selection",
#        label = h4("Select Years:"),
#        min = min(kb_df$year),
#        max = max(kb_df$year),
#        step = 1,
#        sep = "",
#        value = c(2012, 2016)
#      )
    ),
    mainPanel(
      plotlyOutput(outputId = "category_hist"),
      h2("Findings"),
      p("This visualization presents how frequently each category is censored in Kidz Bop songs in each year over the dataset's timeline. Interacting with the chart helps us answer the question, 'What kinds of words experience the most censorship? Do certain categories of censored words get more censored than others If so, why?', along with, 'How does censorship in Kidz Bop reflect values of parents (or those doing the censorship) over time?'.  "),
      p("Upon utilizing the chart's features, it is observed that lyrics under the 'alcohol & drugs', 'profanity', and 'sexual' categories tend to undergo more censorship than the other categories ('violence', 'identity', and 'other'). While this could suggest that language surrounding the more censored categories are policed more than the less censored categories, it is important to keep in mind that Kidz Bop covers the biggest pop hits of the year. Thus, the trends observed may better portray what 'categories' of music reach the most success in the charts rather than the values of parents.")
    )
  )
)


# Tab 3
tab_3 <- tabPanel(
  "Censorship by Artist",
  sidebarLayout(
    sidebar_panel_widget <- sidebarPanel(
      selectInput(
        inputId = "artist_select",
        label = h4("Select Artists to Compare:"),
        choices = unique_artist$ogArtist,
        # True allows you to select multiple choices...
        multiple = T,
        selected = c("Taylor Swift", 
                     "Bruno Mars",
                     "Green Day",
                     "Lady Gaga",
                     "Lil Nas X")
      ),
        checkboxGroupInput(
          inputId = "categories_selection",
          label = "Categories",
          choices = c("alcohol & drugs", 
                      "identity", 
                      "profanity", 
                      "sexual", 
                      "violence", 
                      "other"),
          selected = c("alcohol & drugs", 
                       "identity", 
                       "profanity", 
                       "sexual", 
                       "violence")
        )
      ),
    mainPanel(
      plotlyOutput(outputId = "scatter_plot"),
      h2("Findings"),
      p("This visualization presents a visual comparisons between artists and the amount of censored language attributed to them by Kidz Bop. The chart displays the number of curse words per category for each artist. The user can choose which categories and artists to compare. This way, the user can compare censorship by both category and by artist.It also lets us see what kinds of words are most censored for each artist compared to other artists as well as words in other categories for that same artist."),
      p("Interacting with the scatterplot helps us answer the question: 'How does censorship in Kidz Bop reflect values over time?', specifically looking at the cultural values of artist relevancy. Certain artists are more censored than others, but their songs still make the Kidz Bop tracklist because they are that socially relevant that kids would notice if the popular songs were missing. This shows the lengths to which people in the childrens' music industry will go to in order to stay relevant, and they do this by appealing to the values of children via their favorite artists and to parents via intense scensorship"),
    )
  )
)


# Conclusion tab
conclusion <- tabPanel(
  # Title of tab
  "Conclusion",
  fluidPage(
    h1("Summary"),
 "Overall, more song lyrics have been censored over time. This observation prompts the question of whether song lyrics have gotten more explicit over time, or if uncensored lyrics from years past are being censored in current songs.The most censored category of words overall is “Profanity,” which includes many/most swear words. We also see from the charts that “Identity” is the least censored category, and this includes words that describe gender and sexuality, such as “woman,” and “lesbian.” The “Other” category also sees the least censorship, which includes religiously-associated words and other words that are deemed to be inappropriate for children. While there does appear to be some upward trends in censorship for categories like “alcohol & drugs” and “profanity”, this doesn’t necessarily imply that Kidz Bop has become more strict on how they’re policing these lyrics. Oftentimes Kidz Bop will cover the most popular or highest charting songs of the year. Thus, these trends may better portray what “categories” of music are most successful among general society." )
)



ui <- navbarPage(
  theme = my_theme,
  "Cens*rship in Kidz Bop Songs",
  intro_tab,
  tab_1,
  tab_2,
  tab_3,
  conclusion
)




