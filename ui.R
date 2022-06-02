library(ggplot2)
library(plotly)
library(bslib)
library(markdown)
library(shiny)

kb_df <- read.csv("https://raw.githubusercontent.com/the-pudding/data/master/kidz-bop/KB_censored-lyrics.csv", stringsAsFactors = F)

# Home page tab
intro_tab <- tabPanel(
  # Title of tab
  "Overview",
  fluidPage(
    h1("Introduction")
  )
)

# Tab 1
tab_1 <- tabPanel(
  "Tab 1",
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
      h2("Findings")
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
    h1("Summary")
  )
)



ui <- navbarPage(
  #theme = ,
  "Cens*rship in Kidz Bop Songs",
  intro_tab,
  tab_1,
  tab_2,
  tab_3,
  conclusion
)




