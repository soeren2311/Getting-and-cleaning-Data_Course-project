# Getting-and-cleaning-Data_Course-project
This is the exercise of the course "getting and cleaning data"-course3_week4



Merges the training and the test sets to create one data set.

Extracts only the measurements on the mean and standard deviation for each measurement. 

Uses descriptive activity names to name the activities in the data set

Appropriately labels the data set with descriptive variable names. 

From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

1)
I should create one R script called run_analysis.R that does the following. 
## I first created one R script called run_analysis.R and loaded the dplyr-package

I then downloaded the the dataset I will work with and created a path to the folder where my data is located
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "/Users/..../df_1.zip"
path <- "/Users/.../c3_week4/"
                          
### 1. Now I Merged the training and test datasets but first get the train datasets
x_train
y_train 
subject_train 
x_test 
y_test 
subject_test 
features_names
activity_labels 


# It's now important to assign variable names
## 1. Merges the training and the test sets to create one data set.
sub <- rbind(subject_train, subject_test)
act <- rbind(y_train, y_test)
feat <- rbind(x_train, x_test)

### I then named the columns with the help of the features_names metadataset and merged the train and test data 
complete_data <- cbind(feat,act,sub)


########################################
##### Mean and standard deviation ######
########################################

# 2. I then extracted only the measurements on the mean and sd for each measurement
meanstdv <- grep(".*Mean.*|.*Std.*", names(complete_data), ignore.case=TRUE)

# required_columns 562 = Activity and 563 = Subject (Last two columns of the complete_data)
required_columns <- c(meanstdv, 562, 563)
## extraced data
extr_data <- complete_data[,required_columns]


################################################################################
## Uses descriptive activity names to name the activities in the data set #####
################################################################################

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
