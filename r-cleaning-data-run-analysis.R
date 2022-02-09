---
  title: 'Getting and Cleaning Data: Course Project'
author: "Juan Neculm??n"
date: "08-02-2022"
output: html_document
---
  
  ###Preparing the doc
  
  ```{r}
library(data.table)
library(dplyr)
library(tidyverse)
```



#1) Merges the training and the test sets to create one data set.

##Read activity and fatures
```{r}
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt") #it's contains the labels
features <- read.table("./UCI HAR Dataset/features.txt")               #V2 contains the feature labels
```

##To read Test Data 
```{r}

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") #subjects
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt") #x 
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt") #y 

```

## To read Train Data 
```{r}

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") #subjects too
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt") #more x
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt") # and more y

```

## Put the names
```{r}
#we do the names with all datas
colnames(x_train) <- features[,2] 
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"
colnames(activity_labels) <- c("activityID", "activityType")

```

## To merging

```{r}
#finally, we put all together, with her names correctly
train <- cbind(y_train, subject_train, x_train)
test <- cbind(y_test, subject_test, x_test)
data <- rbind(train, test)
```


#2) Extracts only the measurements on the mean and standard deviation for each measurement. 

## to create reading column names
```{r}
colNames <- colnames(data)
```


```{r}
meanstd <- (grepl("activityID", colNames) |
              grepl("subjectID", colNames) |
              # THIS WAS COPIED FROM https://github.com/wdluft/getting-and-cleaning-data-week-4-project
              # SHOULD NOT BE ACCEPTED AS A NEW SUBMISSION
              grepl("mean..", colNames) |
              grepl("std...", colNames)
)
```


```{r}
setmeanstd <- data[ , meanstd == TRUE]

print(setmeanstd)
```

```

#3) Uses descriptive activity names to name the activities in the data set

```{r}
ActivityNames <- merge(setmeanstd, activity_labels,
                       by = "activityID",
                       all.x = TRUE)
```

#4) Appropriately labels the data set with descriptive variable names. 
```{r}
names(data)[2] = "activity"
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("^t", "Time", names(data))
names(data)<-gsub("^f", "Frequency", names(data))
names(data)<-gsub("tBody", "TimeBody", names(data))
names(data)<-gsub("-mean()", "Mean", names(data), ignore.case = TRUE)
names(data)<-gsub("-std()", "STD", names(data), ignore.case = TRUE)
names(data)<-gsub("-freq()", "Frequency", names(data), ignore.case = TRUE)
names(data)<-gsub("angle", "Angle", names(data))
names(data)<-gsub("gravity", "Gravity", names(data))
```


#5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## making second tidy data set
```{r}

tidySet <- aggregate(. ~subjectID + activityID, ActivityNames, mean)
tidySet <- tidySet[order(tidySet$subjectID, tidySet$activityID), ]

```

## Second tidy on the table
```{r}
write.table(tidySet, "tidySet.txt", row.names = FALSE)

```

