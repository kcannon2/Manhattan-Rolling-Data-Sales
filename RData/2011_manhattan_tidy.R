# Author: Vishi Cline
# Date Created:  10/17/2016
# Description:  Clean the datafile for manhattan rolling sales data

library(gdata)
library(plyr) 
# 
# Read the comma delimited csv file whith header starting at row 5 
manhattan <- read.csv(".\\2011_manhattan.csv",stringsAsFactors=FALSE,skip=4, header=TRUE)

## Check the data
head(manhattan,5)
summary(manhattan)
str(manhattan) 

## clean/format the data with regular expressions
## pattern "[^[:digit:]]" refers to members of the variable name that
## start with digits. We use the gsub command to replace them with a blank space.
# We create a new variable that is a "clean' version of sale.price.
# And sale.price.n is numeric, not a factor.
manhattan$SALE.PRICE.N <- as.numeric(gsub("[^[:digit:]]","", manhattan$SALE.PRICE))

## Get rid of leading digits in gross square feet, create new variable gross sqft and convert to numeric
## Get rid of leading digits in land square fee, create new variable land sqft and convert to numeric
## Convert building class as factor
## Convert Sale.Date as date
## convert type for year built variable to numeric
manhattan$gross.sqft <- as.numeric(gsub("[^[:digit:]]","", manhattan$GROSS.SQUARE.FEET))
manhattan$land.sqft <- as.numeric(gsub("[^[:digit:]]","", manhattan$LAND.SQUARE.FEET))
manhattan$SALE.DATE<-as.Date(manhattan$SALE.DATE, "%m/%d/%Y")
manhattan$BUILDING.CLASS.CATEGORY<-factor(manhattan$BUILDING.CLASS.CATEGORY)
manhattan$YEAR.BUILT<-as.numeric((as.character(manhattan$YEAR.BUILT)))

#confirm the variable data types
str(manhattan)

# Confirm that the sale.price.N, gross.sqft, and land.sqft variable don't contain null values
count(is.na(manhattan$SALE.PRICE.N))
count(is.na(manhattan$gross.sqft))
count(is.na(manhattan$land.sqft))

## make all variable names lower case
names(manhattan) <- tolower(names(manhattan)) 

## do a bit of exploration to make sure there's not anything
## weird going on with sale prices
# Note that we have 0 sale prices in our dataset and that
# the values are so large that the scale of the graph is not even
# sufficient.
attach(manhattan)
# plot a histogram of sale prices
hist(sale.price.n) 
# plot a histogram of sale prices where sale prices>0
hist(sale.price.n[sale.price.n>0])
# plot a histogram of gross square feet where sale price=0
hist(gross.sqft[sale.price.n==0])
detach(manhattan)

## keep only the actual sales, where sale price is not equal to 0
## keep only the gross sqft, where gross sqft is not equal 0
manhattan.sale <- manhattan[manhattan$sale.price.n!=0,]
manhattan.sale <- manhattan.sale[manhattan.sale$gross.sqft!=0,]

## plot the values and note the values before and after the
#logrithmic transform.  Since the mean is resistent to outliers,
# the first graph is heavily scewing the data.  After the logrithmic transform, the data
# is much closer together and amount of variance between the data
# points decreases.  We are now comparing the median sales prices
# as opposed to the mean sale prices.
plot(manhattan.sale$gross.sqft,manhattan.sale$sale.price.n)
plot(log10(manhattan.sale$gross.sqft),log10(manhattan.sale$sale.price.n))

## for now, let's look at 1-, 2-, and 3-family homes
manhattan.homes <- manhattan.sale[which(grepl("FAMILY",manhattan.sale$building.class.category)),]
#get the dimensions for manhattan.homes
dim(manhattan.homes)
plot(log10(manhattan.homes$gross.sqft),log10(manhattan.homes$sale.price.n))
#get the 5 point summary for the dataset variables where sale price is less than 100000
summary(manhattan.homes[which(manhattan.homes$sale.price.n<100000),])

## remove outliers that seem like they weren't actual sales
manhattan.homes$outliers <- (log10(manhattan.homes$sale.price.n) <=5) + 0
manhattan.homes <- manhattan.homes[which(manhattan.homes$outliers==0),]
plot(log10(manhattan.homes$gross.sqft),log10(manhattan.homes$sale.price.n))

# output the clean dataset to output file for analysis
write.csv(manhattan.homes,file=".\\2011_manhattan_tidy.csv")


