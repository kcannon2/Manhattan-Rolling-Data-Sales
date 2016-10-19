# Author: Abhishek Dharwadkar
# Date Created:  10/18/2016
# Description:  Analysis on the cleaned datafile for manhattan rolling sales data

# Load libraries gdata and plyr
# Please make sure these libraries are installed
library(gdata)
library(plyr)

# Read the cleaned comma delimited csv file whith header starting at row 1
manhattan <- read.csv("..\\RData\\2011_manhattan_tidy.csv",stringsAsFactors=FALSE,skip=4, header=TRUE)

