library(dplyr)

#
#STEP 1 - Download the data set
#
# download zip file containing data if it hasn't already been downloaded
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"

if (!file.exists(zipFile)) {
  download.file(zipUrl, zipFile, mode = "wb")
}

# unzip zip file containing data if data directory doesn't already exist
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
  unzip(zipFile)
}

#
#STEP 2 - Load the data set 
#
#load data 
srcfile_x_train <- "X_train.txt"
srcfile_x_test <- "X_test.txt"
srcfile_y_train <- "y_train.txt"
srcfile_y_test <- "y_test.txt"
subject_train <- "subject_train.txt"
subject_test <- "subject_test.txt"
srcfile_features <- "features.txt"
srcfile_activity_labels <- "activity_labels.txt"


data_x_train <- read.table(srcfile_x_train)
data_x_test <- read.table(srcfile_x_test)
data_y_train <- read.table(srcfile_y_train)
data_y_test <- read.table(srcfile_y_test)
data_subject_train <- read.table(subject_train)
data_subject_test <- read.table(subject_test)
##merge x_Traing and x_test
x_dataset <- rbind(data_x_train,data_x_test)
y_dataset <- rbind(data_y_train,data_y_test)
subject_dataset <- rbind(data_subject_train,data_subject_test)

View(x_dataset)
dim(x_dataset)
dim(y_dataset)
dim(subject_dataset)

#
#STEP 3 - Get the Mean and standard deviation
#
#get the measure on the mean and standard deviation
x_dataset_mean_std <- x_dataset[, grep("-(mean|std)\\(\\)", read.table(srcfile_features)[, 2])]
names(x_dataset_mean_std) <- read.table(srcfile_features)[grep("-(mean|std)\\(\\)", read.table(srcfile_features)[, 2]), 2] 
View(x_dataset_mean_std)
dim(x_dataset_mean_std)

#
#STEP 4 - Use descriptive name for the data set
#
#use descriptive name
y_dataset[, 1] <- read.table(srcfile_activity_labels)[y_dataset[, 1],2]
names(y_dataset) <- "Activity"
View(y_dataset)

names(subject_dataset) <- "Subject"
summary(subject_dataset)

#
#STEP 5 - Create a independent Tidy Data set
#
#combine x,y & subject data set
complete_dataset <- cbind(subject_dataset,x_dataset_mean_std,y_dataset)
#head(complete_dataset)

aggregated_dataset1 <- aggregate(. ~Subject + Activity, complete_dataset, mean)
aggregated_dataset2 <- aggregated_dataset1[order(aggregated_dataset1$Subject,aggregated_dataset1$Activity),] 
write.table(aggregated_dataset2, file = "tidy_data.txt",row.name=FALSE)