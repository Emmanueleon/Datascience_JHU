# Getting and celaning data project 

# 1. Enviroment preparation
############################################################################################################
rm(list=ls())
library(tidyverse)
library(reshape2)

## Create the directory 
if (!file.exists("proyect")){
          dir.create("proyect")
}


# 2. Download data (JUST ONCE)
############################################################################################################
## Download and unzip the data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "proyect/galaxydata.zim", method = "curl")
unzip("proyect/galaxydata.zim", exdir = "proyect/")


# 3. Read and reshape the downloaded data
############################################################################################################
## 3.1 Activities Table
activities <- read.csv("proyect/UCI HAR Dataset/activity_labels.txt",
                       header = FALSE, sep = "")
activities


## 3.2 Features Table
features <- read.csv("proyect/UCI HAR Dataset/features.txt", 
                     header = FALSE, sep="")

### Find the variables that we want and create a vector
features_grep <- grep(pattern = ".*mean.*|.*std.", x = features$V2)

### Reshape the names
interested_features <- features[features_grep, 2]%>%
          gsub(pattern = "^t", replacement = "Time_")%>%
          gsub(pattern = "^f", replacement = "Frecuency_")%>%
          gsub(pattern = "Acc", replacement = "Accelerometer")%>%
          gsub(pattern = "Gyro", replacement = "Gyroscope")%>%
          gsub(pattern = "Mag", replacement = "Magnitude")%>%
          gsub(pattern = "-mean", replacement = "Mean")%>%
          gsub(pattern = "-std", replacement = "SD")%>%
          gsub(pattern = "[()]", replacement = "")%>%
          print()

## 3.3 Test table 
subject_test <- read.csv("proyect/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
label_test <- read.csv("proyect/UCI HAR Dataset/test/y_test.txt", FALSE)
label_test <- label_test%>%
          full_join(.,activities, by="V1")%>%
          select(V2)
set_test <- read.table("proyect/UCI HAR Dataset/test/X_test.txt")[features_grep]
test_df <- bind_cols(subject_test, label_test,set_test)
names(test_df) <- c("subject_id","activity", interested_features)
test_df$group <- "test"

## 3.4 Training table
subject_train <- read.csv("proyect/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
label_train <- read.csv("proyect/UCI HAR Dataset/train/y_train.txt", header = FALSE)
label_train <- label_train%>%
          full_join(.,activities, by="V1")%>%
          select(V2)
set_train <- read.table("proyect/UCI HAR Dataset/train/X_train.txt")[features_grep]
train_df <- bind_cols(subject_train, label_train, set_train)
names(train_df) <- c("subject_id", "activity",interested_features)
train_df$group <-  "train"


# 4. Merge test and train tables.
############################################################################################################
## Bind both tables
merged_tbl <- bind_rows(test_df, train_df)%>%
          as_tibble()%>%
          mutate(subject_id=factor(subject_id), 
                 activity=factor(activity), 
                 group=factor(group))%>%
          select(subject_id, activity, group, everything())


# 5. Mean summary
############################################################################################################
## Change tibble to long format
activity_bysubject <- merged_tbl%>%
          pivot_longer(cols = -c("subject_id", "activity", "group"), 
                       names_to = "variable")%>%
          dplyr::group_by(subject_id, activity,variable)%>%
          summarise(mean=mean(value), .groups = "drop")%>%
          pivot_wider(names_from = variable, values_from = mean)%>%
          print()

# 5. Export
############################################################################################################
write_csv(activity_bysubject, "proyect/Mean_subject_activity.csv")
          
          
        





