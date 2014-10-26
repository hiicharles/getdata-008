CodeBook
========

This is the code book that will provide all the information about the course project.

***
## Data Source

The data for the project can be dowloaded at:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>


***
## Files

The downloaded zip file will contain many files but only following will be used.

        ./UCI HAR Dataset/activity_labels.txt
        ## The lookup table for activity.

        ./UCI HAR Dataset/features.txt
        ## The lookup table for features.

        ./UCI HAR Dataset/test/subject_test.txt
        ## Data represesnt subject for 2947 observations. 
        ## 1 column
        ## 2947 observations 

        ./UCI HAR Dataset/test/X_test.txt
        ## Data represesnt 564 feature measurements for 2947 observations.
        ## 564 columns
        ## 2947 observations 

        ./UCI HAR Dataset/test/y_test.txt
        ## Data represesnt activity for 2947 observations.
        ## 1 column
        ## 2947 observations 

        ./UCI HAR Dataset/train/subject_train.txt
        ## Data represesnt subject for 7352 observations. 
        ## 1 column
        ## 7352 observations         
        
        ./UCI HAR Dataset/train/X_train.txt
        ## Data represesnt 564 feature measurements for 7352 observations.
        ## 564 columns        
        ## 7352 observations  
        
        ./UCI HAR Dataset/train/y_train.txt
        ## Data represesnt activity for 7352  observations. 
        ## 1 column
        ## 7352 observations
        
        
Note:

You can assume that the complete observation for test are separated into 3 files and another 3 files are for train. This is considered a messy data.  Whether the observation is from test or from train is not important in this project.

***
## Tasks

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Note: 
    
- Required to create the tidy data set in a file using write.table() and row.name=FALSE


***
## run_analysis.R 

The script perform the following

        - create working directory
        - download the file into working directory
        - unzip the file
        - read 8 files
            - tbl_activity
            - tbl_features
            - x_test
            - y_test
            - subject_test
            - x_train
            - y_train
            - subject_train
        - the feature description was improved because header cannot have character such as -, ( and )
        - combine test data as single table known as tbl_test
        - combine train data as single table as tbl_train
        - combine test and train into single table as tbl_data_1
        - select only features that represent mean and std as tbl_data_2
        - replace activity id with activity description and stored as tbl_data_3
        - perform average group by activity and subject and stored as tbl_data_4
        - output the result as file
        

To run the script

        source(run_analysis.R) 

***
## Expectation

As stated in task section, this course project would like to calculate the average for each feature measurement grouped by activity and subject.

There are
    - 6 types of activity
    - 30 subjects / participants
    - 33 mean features
    - 33 standard deviation features

There must be 68 columns, 2 columns for activity and subject, 66 columns of average measurement for mean and standard deviation.
