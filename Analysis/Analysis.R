# Author: Abhishek Dharwadkar
# Date Created:  10/18/2016
# Description:  Analysis on the cleaned datafile for manhattan rolling sales data

# Load libraries gdata and plyr
# Please make sure these libraries are installed
#library(gdata)
#library(plyr)

# Read the cleaned comma delimited csv file whith header starting at row 1
manhattan.clean <- read.csv("..\\Data\\2011_manhattan_tidy.csv",header=TRUE)

# Check what variables are there and the their types
str(manhattan.clean)

# Explore the clean data with histograms
hist(manhattan.clean$gross.sqft)
hist(log10(manhattan.clean$gross.sqft))
hist(manhattan.clean$sale.price.n)
hist(log10(manhattan.clean$sale.price.n))

# Explore the data with scatterplots to check the effect of the size of the house on the sale price
plot(log10(manhattan.clean$gross.sqft),log10(manhattan.clean$sale.price.n), pch = 16, cex = 1.3, col = "blue", xlab = "Gross Sqft", ylab = "Sale Price")

# We can also explore the data by looking at the boxplots of the sale price by building class category
boxplot(log10(manhattan.clean$sale.price.n)~manhattan.clean$building.class.category)
