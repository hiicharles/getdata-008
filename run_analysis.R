## Getting and Cleaning Data Course Project 
## Course ID: getdata-008
## Submission login (email): hiicharles@gmail.com
## Date: 2014-10-26i

## Instructions
## You should create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Load library dplyr and tidyr
library(dplyr)
library(tidyr)

## Create directory "~/data" if does not exist
workdir <- "~/data"
if (!file.exists(workdir)) {
  dir.create(workdir)
}

## Change working directory to "~/data"
setwd(workdir)

## Download file "getdata-projectfiles-UCI HAR Dataset.zip" if does not exist
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filePath <- paste(workdir,"getdata-projectfiles-UCI HAR Dataset.zip",sep="/")
if (!file.exists(filePath)) {
  download.file(fileUrl, destfile = filePath, method = "wget")  
}

## Unzip file getdata-projectfiles-UCI HAR Dataset.zip if "~/data/UCI HAR Dataset" or required files does not exist
extPath = paste(workdir, "UCI HAR Dataset", sep="/")

## Filepath
activity_filepath <- paste(extPath,"activity_labels.txt",sep="/")
features_filepath <- paste(extPath, "features.txt", sep="/")
x_test_filepath <- paste(extPath,"test/X_test.txt",sep="/")
y_test_filepath <- paste(extPath,"test/y_test.txt",sep="/")
subject_test_filepath <- paste(extPath,"test/subject_test.txt",sep="/")
x_train_filepath <- paste(extPath,"train/X_train.txt",sep="/")
y_train_filepath <- paste(extPath,"train/y_train.txt",sep="/")
subject_train_filepath <- paste(extPath,"train/subject_train.txt",sep="/")

if (!file.exists(extPath) ||
    !file.exists(activity_filepath) ||
    !file.exists(features_filepath) ||
    !file.exists(x_test_filepath) || 
    !file.exists(y_test_filepath) ||
    !file.exists(subject_test_filepath) ||
    !file.exists(x_train_filepath) ||
    !file.exists(y_train_filepath) ||
    !file.exists(subject_train_filepath)) {
  # Unzip
  unzip(zipfile = filePath, unzip = "internal", overwrite = TRUE)
}

## Class  : tbl_df
## Table  : tbl_activity
## Column : id and description
tbl_activity <- read.table(file=activity_filepath, header=FALSE, sep="", col.names = c("id", "description")) %>% tbl_df()

## Class  : tbl_df
## Table  : tbl_features
## Column : id, description, description2
## description2 is better descriptive name
tbl_features <- read.table(file=features_filepath, header=FALSE, sep="", col.names = c("id", "description")) %>% tbl_df()
tbl_features <- tbl_features %>%
                mutate(description2 = gsub("-", ".", description)) %>%
                mutate(description2 = gsub("\\(", "", description2)) %>%
                mutate(description2 = gsub("\\)", "", description2)) %>%
                mutate(description2 = gsub(",", ".", description2))

## Replace ()- to .
## Replace - to .
## Replace 

## Class  : tbl_df
## Table  : x_test
## Column : 564 columns (features)
x_test <- read.table(file=x_test_filepath, header=FALSE, sep = "", col.names = as.character(tbl_features$description2)) %>% tbl_df() 

## Class  : tbl_df
## Table  : y_test
## Column : activity
y_test <- read.table(file=y_test_filepath, header=FALSE, sep = "", col.names = c("activity"), colClasses = "character") %>% tbl_df()

## Class  : tbl_df
## Table  : subject_test
## Column : subject
subject_test <- read.table(file=subject_test_filepath, header=FALSE, sep = "", col.names = c("subject")) %>% tbl_df()

## Class  : tbl_df
## Table  : x_train
## Column : 564 columns (features)
x_train <- read.table(file=x_train_filepath, header=FALSE, sep = "", col.names = as.character(tbl_features$description2)) %>% tbl_df()

## Class  : tbl_df
## Table  : y_train
## Column : activity
y_train <- read.table(file=y_train_filepath, header=FALSE, sep = "", col.names = c("activity"), colClasses = "character") %>% tbl_df()

## Class  : tbl_df
## Table  : subject_train
## Column : subject
subject_train <- read.table(file=subject_train_filepath, header=FALSE, sep = "", col.names = c("subject")) %>% tbl_df()

## 1. Merges the training and the test sets to create one data set.

## Class  : tbl_df
## Table  : tbl_test
## Column : activity, subject, category and 564 features
## Observations = 2947
tbl_test <- 
  cbind(y_test, subject_test, category = c("test")) %>%
  cbind(x_test) %>%
  tbl_df()

## Class  : tbl_df
## Table  : tbl_train
## Column : activity, subject, category and 564 features
## Observations = 7352
tbl_train <- 
  cbind(y_train, subject_train, category = c("train")) %>%
  cbind(x_train) %>% 
  tbl_df()

## Class  : tbl_df
## Table  : tbl_data
## Column : activity, subject, category and 564 features
## Observations = 10299
tbl_data_1 <- 
  rbind(tbl_test, tbl_train) %>%
  tbl_df()

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

## Class  : tbl_df
## Table  : tbl_data_2
## Column : activity, subject, category and 66 features that matched .std. or .mean.
## Note   : Refer to feature.txt - 33 features with -mean()- and 33 features with -std()-
##          Ignored MeanFreq, gravityMean, tBodyAccMean, tBodyAccJerkMean, tBodyGyroMean, tBodyGyroJerkMean
##          Because the variable names is  based on description2, which is treated, 
##          in between  .mean. and .std.
##          at the end  .mean and .std
tbl_data_2 <- select(tbl_data_1, activity, subject, category, matches("\\.mean\\.|\\.mean$|\\.std\\.|\\.std$"))


## 3. Uses descriptive activity names to name the activities in the data set

## Class  : tbl_df
## Table  : tbl_data_3
## Column : activity, subject, category and 66 features that matched .std. or .mean.
tbl_data_3 <- 
  merge(tbl_data_2, tbl_activity, by.x = "activity", by.y = "id") %>%
  tbl_df() %>%
  mutate(activity = description)

## Removed column 70 (description)
tbl_data_3 <- tbl_data_3[, 1:69]  


## 4. Appropriately labels the data set with descriptive variable names. 
## Already being assigned with proper descriptive variables during read.table.

## 5. From the data set in step 4, creates a second, independent tidy tbl_data set with 
## the average of each variable for each activity and each subject.

## Class  : tbl_df
## Table  : tbl_data_4
## Column : activity, subject and 66 features that matched .std. or .mean.
tbl_data_4 <- aggregate(tbl_data_3[,4:69], 
                        by = list(activity=tbl_data_3$activity, subject=tbl_data_3$subject),
                        FUN=mean) %>% 
              tbl_df()

## Write the final tidy data to file "~/data/output.txt"
write.table(tbl_data_4, file = paste(workdir, "output.txt", sep = "/"), row.names = FALSE)
