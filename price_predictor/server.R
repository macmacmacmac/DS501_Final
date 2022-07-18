library(shiny)
library(ggplot2)
library(tidyverse)

dataset <- read.csv("https://raw.githubusercontent.com/macmacmacmac/ds501_casestudy/main/data.csv") %>% na.omit

dataset <- dataset[c(-4351, -4347, -4352)]
dataset <- dataset %>% dplyr::filter(price > 0)

normalize <- function(x, ...) {
  return((x - min(x, ...)) /(max(x, ...) - min(x, ...)))
}

city_occurences <- as.data.frame(table(dataset$city)) %>% arrange(Freq)
dataset$urbanness <- match(dataset$city, city_occurences$Var1)


dataset <- dataset[,-which(colnames(dataset) %in% c("date", "street", 
                                                    "statezip", 
                                                    "city", "country"))]

model.data <- as.data.frame(apply(dataset, 2, normalize))
model.data$price <- dataset$price
model.data <- model.data %>%
  mutate(price = log(price),
         ifelse(condition < 0.6, 0, condition-0.4),
         bedrooms = -1*bedrooms*bedrooms)

model.data.train <- model.data[sample(nrow(model.data), 0.8*nrow(model.data)),]
model.data.test <- model.data[sample(nrow(model.data), 0.2*nrow(model.data)),]

model = lm(price~ bathrooms +
             sqft_living +
             sqft_above,
           data = model.data.train)


function(input, output) {
  
  output$prediction <- renderText({
    predictors <- data.frame("sqft_living" = input$squarefoot_living,
                                      "bathrooms" = input$bathrooms,
                                      "sqft_above" = input$squarefoot_above)
    
    predictions <- data.frame(predict(model, predictors, interval = "confidence"))
    predictions <- round(predictions, 2)
    
    prediction <- paste("YOUR HOUSE WILL BE: ", 
                   as.character(predictions$lwr), 
                   "$ ON THE LOWER END AND", 
                   as.character(predictions$upr), 
                   "$ ON THE higher END @ 95% CONFIDENCE ")
    return(prediction)
    
  })

}
