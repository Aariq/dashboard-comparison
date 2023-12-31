library(shiny)
library(bslib)

library(ggplot2)
library(palmerpenguins)
data(penguins, package = "palmerpenguins")

ui <- page_navbar(
  title = "Penguins dashboard",
  theme = bs_theme(version = 5, bootswatch = "lux"),
  sidebar = sidebar(
    title = "Histogram controls",
    varSelectInput(
      "var", "Select variable",
      dplyr::select_if(penguins, is.numeric)
    ),
    numericInput("bins", "Number of bins", 30)
  ),
  nav_panel(
    "Plots",
    card(
      height = "60%",
      card_header("Histogram"),
      plotOutput("hist"),
      full_screen = TRUE
    ),
    card(
      height = "40%",
      card_header("Scatter"),
      plotOutput("scatter"),
      full_screen = TRUE
    )
  ),
  nav_panel(
    "About",
    card(
      card_body(
        p(
          "There's just plain text on this tab!  I think I have to use",
          code("htmltools"),
          "functions to do things like ",
          strong("bold"),
          ", ",
          tags$em("itallics"),
          ", ",
          code("code")
        ),
        tags$ul(
          tags$li("item 1"),
          tags$li("item 2")
        ),
        p("etc.")
      )
    )
  )
)

server <- function(input, output) {
  output$hist <- renderPlot({
    ggplot(penguins) +
      geom_histogram(aes(!!input$var), bins = input$bins) +
      theme_bw(base_size = 20)
  })
  output$scatter <- renderPlot({
    ggplot(penguins) +
      geom_point(aes(x = body_mass_g, y = !!input$var)) +
      theme_bw(base_size = 20)
  })
}

shinyApp(ui, server)