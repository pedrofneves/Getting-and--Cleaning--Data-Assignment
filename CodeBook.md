#Code Book

##Introduction

This document describes the code implemented as required in the assignment of the course.

You can find the code in "run_analysis.R" file.

##Steps

The first step required is read the feature files for test and train:

```
testData <- read.table(file.path(workDirectory,"./test/X_test.txt"),header=FALSE)
trainData <- read.table(file.path(workDirectory,"./train/X_train.txt"),header=FALSE)
```

PS: you have to define the "workDirectory" variable.

Then we need to merge the two data frames:

```
mergedData <- rbind(testData,trainData)
```