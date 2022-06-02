library(ggplot2)
library(plotly)
library(bslib)
library(markdown)
library(shiny)

kb_df <- read.csv("https://raw.githubusercontent.com/the-pudding/data/master/kidz-bop/KB_censored-lyrics.csv", stringsAsFactors = F)


my_theme <- bs_theme(bg = "#0b3d91",
                     fg = "white", 
                     primary = "#FCC780")

my_theme <- bs_theme_update(my_theme, bootswatch = "sketchy")

# Home page tab
intro_tab <- tabPanel(
  # Title of tab
  "Overview",
  fluidPage(
    includeMarkdown("README.md")
  )
)

# Tab 1
tab_1 <- tabPanel(
  "Censorship Over Time",
  sidebarLayout(
    sidebarPanel(
      
    ),
    mainPanel(
      
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
      sliderInput(
        inputId = "year_selection",
        label = h4("Select Years:"),
        min = min(kb_df$year),
        max = max(kb_df$year),
        step = 1,
        sep = "",
        value = c(2012, 2016)
      )
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
  "Category Breakdown",
  sidebarLayout(
    sidebarPanel(
#      sliderInput(
#        inputId = "years_selection",
#        label = h4("Select Years:"),
#        min = min(kb_df$year),
#        max = max(kb_df$year),
#        step = 1,
#        sep = "",
#        value = c(2012, 2016)
#      ),
      checkboxGroupInput(
        inputId = "categories_selection",
        label = h4("Select Categories to Compare:"),
        choices = c("alcohol & drugs", 
                    "identity",
                    "other",
                    "profanity",
                    "violence"),
        selected = c("alcohol & drugs", 
                     "identity",
                     "profanity",
                     "violence")
      )
    ),
    mainPanel(
      plotlyOutput(outputId = "category_pie"),
      h2("Findings")
    )
  )
)


# Conclusion tab
conclusion <- tabPanel(
  # Title of tab
  "Conclusion",
  fluidPage(
    h1("Summary"),
 "Overall, more song lyrics have been censored over time. This observation prompts the question of whether song lyrics have gotten more explicit over time, or if uncensored lyrics from years past are being censored in current songs.The most censored category of words overall is “Profanity,” which includes many/most swear words. We also see from the pie chart that “Identity” is the least censored category, and this includes words that describe gender and sexuality, such as “woman,” and “lesbian.” The “Other” category also sees the least censorship, which includes religiously-associated words and other words that are deemed to be inappropriate for children. While there does appear to be some upward trends in censorship for categories like “alcohol & drugs” and “profanity”, this doesn’t necessarily imply that Kidz Bop has become more strict on how they’re policing these lyrics. Oftentimes Kidz Bop will cover the most popular or highest charting songs of the year. Thus, these trends may better portray what “categories” of music are most successful among general society." )
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




