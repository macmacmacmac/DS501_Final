library(shiny)
library(ggplot2)

dataset <- diamonds

fluidPage(
  
  titlePanel("PREDICT YOUR HOUSE PRICE"),
  
  sidebarPanel(
    tags$head(tags$script('
                                var dimension = [0, 0];
                                $(document).on("shiny:connected", function(e) {
                                    dimension[0] = window.innerWidth;
                                    dimension[1] = window.innerHeight;
                                    Shiny.onInputChange("dimension", dimension);
                                });
                                $(window).resize(function(e) {
                                    dimension[0] = window.innerWidth;
                                    dimension[1] = window.innerHeight;
                                    Shiny.onInputChange("dimension", dimension);
                                });
                            ')),
    
    sliderInput('bathrooms', '#of bathrooms', min=0, max=8,
                value=4, step=1),
    
    sliderInput('squarefoot_living', 'squarefoot_living', min=0, max=15000,
                value=4, step=1),
    
    sliderInput('squarefoot_above', 'squarefoot_living', min=0, max=15000,
                value=4, step=1),
    
    
  ),
  
  mainPanel(
    textOutput(outputId = "prediction"),
  )
)
