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

At last, we have to load the labels of each activity, with its corresponding code, and transform the code into label (character) using factor method:

```
activityLabels <- read.table(file.path(workDirectory,"./activity_labels.txt"),header=FALSE,colClasses="character")
selectedData$activity <- factor(selectedData$activity, levels = activityLabels$V1, labels = activityLabels$V2)
```

We can do the same for the "subject" information:

```
testSubjects <- read.table("./test/subject_test.txt",header=FALSE)
trainSubjects<- read.table("./train/subject_train.txt",header=FALSE)
mergedSubjects <- rbind(testSubjects,trainSubjects)
selectedData[,"subject"] <- mergedSubjects
```


 
 

