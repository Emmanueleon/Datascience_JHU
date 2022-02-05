# Getting and celaning data project 

The purpose of this project is to demonstrate our ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

## Requirements: 
1. A tidy data set.
2. A link to a Github repository with your script for performing the analysis. 
3. A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called **CodeBook.md**. 

## About the project
The data collected from the accelerometers from the Samsung Galaxy S smartphone.The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 

Each person performed six activities wearing a smartphone (Samsung Galaxy S II) on the waist:

1. Walking
2. Walking upstairs
3. Walking downstairs
4. Sitting
5. Standing
6. Laying

Using its embedded accelerometer and gyroscope, they  captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 

## Proyect objetives
We should create one R script called run_analysis.R that does the following: 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## About script
The ´run_analysis.R´ script its divided in 6 steps. 

1. Enviroment preparation.
  * Clean history.
  * Load libraries.
  * Create working directory.
2. Download data.
  * Download from internet zip file. 
  * Unzip the downloaded file. 
3. Read and reshape the downloaded data.
  * Load activities data. 
  * Load and reshape features data. 
  * Load test data and join with activities data. 
  * Load training data and hoin with activities data. 
4. Merge test and train tables.
  * Bind rows of both tables to create just one final table. 
5. Mean summary.
  * Pivot to longer format the final table. 
  * Group the data by "subject id", "activity" and "variables"
  * Pivot to wider the average of each variable for each activity and each subject.
6. Export .csv and .txt file with the results. 

The final `merged_tbl` is a tidy data with the results from the variables measured in the study for each subject, this tidy data could be used to obtain more specific inforation like we do with the mean of each variable for each activity and each subject. 


