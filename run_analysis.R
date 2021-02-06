# Coursera
# Course: Getting and Cleaning Data
# Author: Grigoriy Shmigol

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Load libraries 
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
library(data.table)


# set global variables 
# get a working directory
local_path <- getwd()
unziped_directory <- "/UCI HAR Dataset"
local_path_unziped <- file.path(local_path, unziped_directory)
# url to get data for the project
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# download the zip and rename file
download.file(data_url, file.path(local_path, "UCI_HAR_Dataset.zip"))

# extract the content
unzip(zipfile = "UCI_HAR_Dataset.zip")


# Load activity labels
activity_labels <- fread(file.path(local_path_unziped, "/activity_labels.txt")
                         , col.names = c("classLabels", "activityName"))

# Load features
features <- fread(file.path(local_path_unziped,"/features.txt")
                  , col.names = c("index", "featureNames"))

# Load wanted features
features_wanted <- grep("(mean|std)\\(\\)", features[, featureNames])

# Load measurements
measurements <- features[features_wanted, featureNames]
measurements <- gsub('[()]', '', measurements)

# Load train datasets
train <- fread(file.path(local_path_unziped, "/train/X_train.txt"))[, features_wanted, with = FALSE]

data.table::setnames(train, colnames(train), measurements)

train_activities <- fread(file.path(local_path_unziped, "/train/Y_train.txt"), col.names = c("Activity"))

train_subjects <- fread(file.path(local_path_unziped, "/train/subject_train.txt"), col.names = c("SubjectNum"))

train <- cbind(train_subjects, train_activities, train)

# Load test datasets
test <- fread(file.path(local_path_unziped, "/test/X_test.txt"))[, features_wanted, with = FALSE]
data.table::setnames(test, colnames(test), measurements)

test_activities <- fread(file.path(local_path_unziped, "/test/Y_test.txt"), col.names = c("Activity"))

test_subjects <- fread(file.path(local_path_unziped, "/test/subject_test.txt"), col.names = c("SubjectNum"))

test <- cbind(test_subjects, test_activities, test)

# merge train and test datasets
combined <- rbind(train, test)

# Convert classLabels to activityName
combined[["Activity"]] <- factor(combined[, Activity]
                                 , levels = activity_labels[["classLabels"]]
                                 , labels = activity_labels[["activityName"]])

combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])
combined <- reshape2::melt(data = combined, id = c("SubjectNum", "Activity"))
combined <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)

# Write file
data.table::fwrite(x = combined, file = "tidyData.txt", quote = FALSE)
