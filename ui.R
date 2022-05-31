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
      
    ),
  )
)

# Tab 2
tab_2 <- tabPanel(
  "Tab 2",
  sidebarLayout(
    sidebarPanel(
      
    ),
    mainPanel(
      
    ),
  )
)

# Tab 3
tab_3 <- tabPanel(
  "Tab 3",
  sidebarLayout(
    sidebarPanel(
      
    ),
    mainPanel(
      
    ),
  )
)

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




