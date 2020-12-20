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


# set global variables 
# get a working directory
local_path <- getwd()
# url to get data for the project
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# download the zip and rename file
download.file(data_url, file.path(local_path, "UCI_HAR_Dataset.zip"))

# extract the content
unzip(zipfile = "UCI_HAR_Dataset.zip")
