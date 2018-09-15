## from link
## https://www.r-bloggers.com/implementing-apriori-algorithm-in-r/

library(dplyr)
library(plyr)
library(arules)
library(plumber)
library(jsonlite)
library(colorspace)
library(ggplot2)
library(jsonlite)

#' @filter cors
function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}
raw_data <- read.csv("~/Suggestion-Prediction-based-in-R-programming-Using-Apriori-algorithm/Raw Data.csv")
data <- read.csv("~/Suggestion-Prediction-based-in-R-programming-Using-Apriori-algorithm/Sample - Superstore.csv")
clean_data <- ddply(data, c("Order.ID","Order.Date","Ship.Mode","Segment","City","State","Region"), function(dd)paste(dd$Product.Name, collapse = ","))


#' Retun the summary from a particular category
#' @param val the category
#' @post /category
function(val){
  df_cat <- data.frame(Name=data$Product.Name[which(data$Category == val)])
  toJSON(lapply(df_cat, function(x){as.list(summary(x))}), pretty = TRUE, auto_unbox = TRUE)
}

#' Market Analysis
#' @get /market
function(){
  ins
}

#' Return the Shipping Mode and their count
#' @get /ship
function(){
  ships <- c()
  for (ship in unique(clean_data$Ship.Mode)){
    ships[ship] <- count(clean_data$Ship.Mode[which(clean_data$Ship.Mode == ship)])$freq
  }
  data.frame(label = unique(clean_data$Ship.Mode), value=ships)
}

#' Retun total Records in the CSV after Cleaning
#' @get /totalRecords
function(){
  length(data$Product.Name)
}

#' Total Products Sold
#' @get /totalProducts
function(){
  length(clean_data$V1)
}

#' Segement Pie Chart data
#' @get /segmentData
function(){
  df_seg <- data.frame(Name= clean_data$Segment)
  toJSON(summary(df_seg), force = T)
}

#' Total Users Data
#' @get /users 
function(){
  length(unique(data$Customer.Name))
}

#' Total Profit 
#' @get /profit
function(){
  round(sum(raw_data$Profit))
}

#' lolipop char -> profit
#' requires ggplot2
#' @png (width = 1100, height = 300)
#' @get /profitChart
function(){
  xLoli <- c(paste(head(substr(raw_data$Product.Name, start = 1, stop = 10),15), sep = "\n"))
  yLoli <- c(head(raw_data$Profit,15))
  loli <- ggplot(head(data,15), aes(x=xLoli, y=yLoli)) +
    geom_segment( aes(x=xLoli, xend=xLoli, y=1, yend=yLoli), color=rgb(0.46,0.63,0.82,1)) +
    geom_point( color=rgb(0.69,0.82,0.45), size=4) +
    theme_light() +
    theme(
      panel.grid.major.x = element_blank(),
      panel.border = element_blank(),
      axis.ticks.x = element_blank()
    ) +
    xlab("") +
    ylab("Profit / Loss")
  print(loli)
}

#' Apriori Chart
#' @png (width = 800, height = 500)
#' @get /apriori
function(){
  plot(basket_rules, method="graph", control=list(type="items"), measure = "support", shading = "lift")
}


function(){
  library(RColorBrewer)
  wordcloud::wordcloud(data$Product.Name, colors = brewer.pal(12, "Paired"), random.order = T)
}

data_2 <- head(data.frame(qty = raw_data$Quantity, product = paste(substr(raw_data$Product.Name, start = 1, stop = 10), sep = "\n")), 5)

#plot(data_2, method = "paracoord", control = list(reorder = TRUE))

data_sorted <- data[order(data$Order.ID),]
data_sorted$Order.ID <- as.numeric(data_sorted$Order.ID)

data_item <- ddply(data, c("Order.ID"), function(dd)paste(dd$Product.Name, collapse = ","))

data_item$Order.ID <- NULL
write.csv(data_item,"~/Suggestion-Prediction-based-in-R-programming-Using-Apriori-algorithm/link.csv")
trans <- read.transactions("~/Suggestion-Prediction-based-in-R-programming-Using-Apriori-algorithm/link.csv", format = "basket", sep=",", cols=1)
trans@itemInfo$labels <- gsub("\"","", trans@itemInfo$labels)
basket_rules <- apriori(trans,parameter = list(supp = 0.001, minlen = 1, target = "frequent itemsets" ))
ins <- inspect(basket_rules)
summary(basket_rules)
ins
grepl("Levels", ins$items)

#plot(basket_rules)
#arules::itemFrequencyPlot(trans, topN=5)
#plot(basket_rules,measure=c("support","lift"),shading="confidence",interactive=F)
#pie(trans)

#plot_ly(data = raw_data, color = ~State , colors = brewer.pal(12, "Paired"), x= ~Sales, y= ~Profit, type = "scatter", mode = "markers")


