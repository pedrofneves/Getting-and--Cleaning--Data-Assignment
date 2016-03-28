#Code Book

##Introduction

This document describes the code implemented as required in the assignment of the course.

You can find the code in "run_analysis.R" file.

This is a complement of the information contained in "features_info.txt" of the UCI zip.


##Steps

###1.
The first step required is load the feature files of test and train:

```
testData <- read.table(file.path(workDirectory,"./test/X_test.txt"),header=FALSE)
trainData <- read.table(file.path(workDirectory,"./train/X_train.txt"),header=FALSE)
```

These data has numeric value (measurements) normalized between [-1,1] for 261 types of measurements.
For more information about the measurement, see "README.txt" and "feature_info.txt" of the UCI zip.

PS: you have to define the "workDirectory" variable before.

Then we need to join the two data frames:

```
mergedData <- rbind(testData,trainData)
```

###2.
The second step required is extract only the data of mean and standard deviation measurements.

One way to do that is, first, load all the columns names:

```
features <- read.table(file.path(workDirectory,"./features.txt"))
colnames(mergedData) <- features$V2
```

Then we need to select only the variables (columns) that contains "mean()" or "std()" in the label name.

```
selectedDataNames <- features[grepl("-(mean|std)\\(\\)",features$V2),]$V2
selectedData <- mergedData[as.character(selectedDataNames)]
```

###3.
The third step is use the activities names in the data set.

So we need to load the activies codes of the test and train data and join them.

```
testActivity <- read.table(file.path(workDirectory,"./test/y_test.txt"))
trainActivity <- read.table(file.path(workDirectory,"./train/y_train.txt"))
mergedActivity <- rbind(testActivity,trainActivity)
```

Then we can add the activity information to the data set in a new column:
```
selectedData[,"activity"] <- mergedActivity
```

At last, we have to load the labels of each activity, with its corresponding code, and transform the code into label (factor) using factor method:

```
activityLabels <- read.table(file.path(workDirectory,"./activity_labels.txt"),header=FALSE,colClasses="character")
selectedData$activity <- factor(selectedData$activity, levels = activityLabels$V1, labels = activityLabels$V2)
```

We can do the same for the "subject" information (note that subject has no label, it's just a numeric group):

```
testSubjects <- read.table("./test/subject_test.txt",header=FALSE)
trainSubjects<- read.table("./train/subject_train.txt",header=FALSE)
mergedSubjects <- rbind(testSubjects,trainSubjects)
selectedData[,"subject"] <- mergedSubjects
```

###4.

The fourth step is to label the data set with appropriate names.

We have already loaded all labels in the "selectedDataNames" variable. We need to create a new list with these label adding the activity and subject label.

```
selectedDataNames <- c(as.character(selectedDataNames), "activity", "subject")
names(selectedData) <- selectedDataNames
```

We need to rename the abbreviation in the column names:
```
selectedDataNames<-gsub("Acc", "accelerometer", selectedDataNames)
selectedDataNames<-gsub("Gyro", "Gyroscope", selectedDataNames)
...
```

###5.

The fifth step required create a new data frame containing the average of each variable grouped by activity and subject.

To do that we need to load the library "data.table" that contains facilities to summarize information. 

```
library(data.table)
```

So we create a new variable "DT" that wraps the data frame information:
```
DT <- data.table(selectedData)
```

Using the data.table we can execute lapply function for each subset of the date frame. 
The data is divided in groups by activity, subject and column (variable).
The mean funcion is applied for each each group.
```
resultData <- DT[,lapply(.SD,mean), by="activity,subject"]
```

At last, we write the result data into a file:
```
write.table(resultData,file="resultData.csv",sep=",",row.names = FALSE)
```	



##Variables

The "workDirectory" is a variable that should be defined before running the script.

The "resultData" contains the average of each variable listed below grouped by "activity" and "subject".

The "activity" is a factor containing the values as defined in "activity_labels.txt" file.

The "subject" is a numeric integer representing the groups.

* tBodyAcc-mean()-X               
* tBodyAcc-std()-X           
* tGravityAcc-mean()-X       
* tGravityAcc-std()-X        
* tBodyAccJerk-mean()-X      
* tBodyAccJerk-std()-X       
* tBodyGyro-mean()-X         
* tBodyGyro-std()-X          
* tBodyGyroJerk-mean()-X     
* tBodyGyroJerk-std()-X      
* tBodyAccMag-mean()         
* tGravityAccMag-std()       
* tBodyGyroMag-mean()        
* tBodyGyroJerkMag-std()     
* fBodyAcc-mean()-Z          
* fBodyAcc-std()-Z           
* fBodyAccJerk-mean()-Z      
* fBodyAccJerk-std()-Z       
* fBodyGyro-mean()-Z         
* fBodyGyro-std()-Z          
* fBodyBodyAccJerkMag-mean() 
* fBodyBodyGyroMag-std()     
* tBodyAcc-mean()-Y                      
* tBodyAcc-std()-Y           
* tGravityAcc-mean()-Y       
* tGravityAcc-std()-Y        
* tBodyAccJerk-mean()-Y      
* tBodyAccJerk-std()-Y       
* tBodyGyro-mean()-Y         
* tBodyGyro-std()-Y          
* tBodyGyroJerk-mean()-Y     
* tBodyGyroJerk-std()-Y      
* tBodyAccMag-std()          
* tBodyAccJerkMag-mean()     
* tBodyGyroMag-std()         
* fBodyAcc-mean()-X          
* fBodyAcc-std()-X           
* fBodyAccJerk-mean()-X      
* fBodyAccJerk-std()-X       
* fBodyGyro-mean()-X         
* fBodyGyro-std()-X          
* fBodyAccMag-mean()         
* fBodyBodyAccJerkMag-std()  
* fBodyBodyGyroJerkMag-mean()
* tBodyAcc-mean()-Z              
* tBodyAcc-std()-Z           
* tGravityAcc-mean()-Z       
* tGravityAcc-std()-Z        
* tBodyAccJerk-mean()-Z      
* tBodyAccJerk-std()-Z       
* tBodyGyro-mean()-Z         
* tBodyGyro-std()-Z          
* tBodyGyroJerk-mean()-Z     
* tBodyGyroJerk-std()-Z      
* tGravityAccMag-mean()      
* tBodyAccJerkMag-std()      
* tBodyGyroJerkMag-mean()    
* fBodyAcc-mean()-Y          
* fBodyAcc-std()-Y           
* fBodyAccJerk-mean()-Y      
* fBodyAccJerk-std()-Y       
* fBodyGyro-mean()-Y         
* fBodyGyro-std()-Y          
* fBodyAccMag-std()          
* fBodyBodyGyroMag-mean()    
* fBodyBodyGyroJerkMag-std() 
* activity    
* subject
 
