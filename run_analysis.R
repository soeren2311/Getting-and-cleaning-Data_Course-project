## If first created one R script called run_analysis.R

#delete all objects in working memory 
rm(list=ls()) 

## load the dplyr-package
library(dplyr)
library(data.table)


### messages
# This installation of data.table has not detected OpenMP support. 
# It should still work but in single-threaded mode.

# Attache Paket: ‘data.table’
# Die folgenden Objekte sind maskiert von ‘package:dplyr’:
# between, first, last



########################
##### Get the data #####
########################

# I first download the the dataset I will wirk with
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "/Users/sorennonnengart/Coursera/Data_science/Datensätze/c3_week4/df_1.zip"

## I first create a path to the folder where my data is located
path <- "/Users/sorennonnengart/Coursera/Data_science/Datensätze/c3_week4/"
## I then set the path to it
setwd(path)
getwd()              
  
                          
### 1. Merge the training and test datasets

## First get the train datasets
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)

## Get the test datasets
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)

# Get the features data
features_names <- read.table("./UCI HAR Dataset/features.txt")
# Get the activity data
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)


# Assigning variable names
# 1. Merges the training and the test sets to create one data set.
sub <- rbind(subject_train, subject_test)
act <- rbind(y_train, y_test)
feat <- rbind(x_train, x_test)

### Name the columns with the help of the features_names metadataset
colnames(feat) <- t(features_names[2])

# Merging the train and test data 
colnames(act) <- "Activity"
colnames(sub) <- "Subject"
complete_data <- cbind(feat,act,sub)


########################################
##### Mean and standard deviation ######
########################################

# 2. Extracting only the measurements on the mean and sd for each measurement
meanstdv <- grep(".*Mean.*|.*Std.*", names(complete_data), ignore.case=TRUE)

# required_columns 562 = Activity and 563 = Subject (Last two columns of the complete_data)
required_columns <- c(meanstdv, 562, 563)
## extraced data
extr_data <- complete_data[,required_columns]


################################################################################
## Uses descriptive activity names to name the activities in the data set #####
################################################################################

extr_data$Activity <- as.character(extr_data$Activity)
for (i in 1:6){
  extr_data$Activity[extr_data$Activity == i] <- as.character(activity_labels[i,2])
}

extr_data$Activity <- as.factor(extr_data$Activity)


################################################################################
##### Appropriately labels the data set with descriptive variable names. #######
################################################################################


# use descriptive activity names to name the activities in the data set
colnames(extr_data) <- gsub("Acc", "accelerometer", colnames(extr_data))
colnames(extr_data) <- gsub("BodyBody", "body", colnames(extr_data))
colnames(extr_data) <- gsub("gravity", "gravity", colnames(extr_data))
colnames(extr_data) <- gsub("Gyro", "gyroscope", colnames(extr_data))
colnames(extr_data) <- gsub("Mag", "magnitude", colnames(extr_data))
colnames(extr_data) <- gsub("^t", "time", colnames(extr_data))
colnames(extr_data) <- gsub("^f", "frequency", colnames(extr_data))
colnames(extr_data) <- gsub("-mean()", "mean", colnames(extr_data), ignore.case = TRUE)
colnames(extr_data) <- gsub("-std()", "stdv", colnames(extr_data), ignore.case = TRUE)

names(extr_data)

# creates a second data set with the average of each variable for activity and subject.

extr_data$Subject <- as.factor(extr_data$Subject)
extr_data <- data.table(extr_data)

## creating tidy data as a data set with average for each activity and subject
tdata <- aggregate(. ~Subject + Activity, extr_data, mean)
tdata <- tdata[order(tdata$Subject,tdata$Activity),]
write.table(tdata, file = "Tidy.txt", row.names = FALSE)


## save dataset tdata
getwd()
save(tdata,file="tiny_data.Rda")
