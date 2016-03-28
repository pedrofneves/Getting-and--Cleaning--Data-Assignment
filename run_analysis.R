
#Work directory - you need to specify accoding to your local machine/environment
workDirectory <- "G:\\Cursos\\Coursera - Data Science\\Cleaning Data - Week 4\\assignment\\UCI HAR Dataset"

#1. Merges the training and the test sets to create one data set.
testData <- read.table(file.path(workDirectory,"./test/X_test.txt"),header=FALSE)
trainData <- read.table(file.path(workDirectory,"./train/X_train.txt"),header=FALSE)
mergedData <- rbind(testData,trainData)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table(file.path(workDirectory,"./features.txt"))
colnames(mergedData) <- features$V2
selectedDataNames <- features[grepl("-(mean|std)\\(\\)",features$V2),]$V2
selectedData <- mergedData[as.character(selectedDataNames)]


#3. Uses descriptive activity names to name the activities in the data set
testActivity <- read.table(file.path(workDirectory,"./test/y_test.txt"))
trainActivity <- read.table(file.path(workDirectory,"./train/y_train.txt"))
mergedActivity <- rbind(testActivity,trainActivity)
selectedData[,"activity"] <- mergedActivity
activityLabels <- read.table(file.path(workDirectory,"./activity_labels.txt"),header=FALSE,colClasses="character")
selectedData$activity <- factor(selectedData$activity, levels = activityLabels$V1, labels = activityLabels$V2)

testSubjects <- read.table(file.path(workDirectory,"./test/subject_test.txt"),header=FALSE)
trainSubjects<- read.table(file.path(workDirectory,"./train/subject_train.txt"),header=FALSE)
mergedSubjects <- rbind(testSubjects,trainSubjects)
selectedData[,"subject"] <- mergedSubjects


#4. Appropriately labels the data set with descriptive variable names.
selectedDataNames <- as.character(selectedDataNames)
selectedDataNames<-gsub("Acc", "accelerometer", selectedDataNames)
selectedDataNames<-gsub("Gyro", "Gyroscope", selectedDataNames)
selectedDataNames<-gsub("BodyBody", "Body", selectedDataNames)
selectedDataNames<-gsub("Mag", "Magnitude", selectedDataNames)
selectedDataNames<-gsub("^t", "Time", selectedDataNames)
selectedDataNames<-gsub("^f", "Frequency", selectedDataNames)
selectedDataNames<-gsub("tBody", "TimeBody", selectedDataNames)
selectedDataNames<-gsub("-mean\\(\\)", "Mean", selectedDataNames, ignore.case = TRUE)
selectedDataNames<-gsub("-std\\(\\)", "Std", selectedDataNames, ignore.case = TRUE)
selectedDataNames<-gsub("-freq\\(\\)", "Frequency", selectedDataNames, ignore.case = TRUE)
selectedDataNames<-gsub("angle", "Angle", selectedDataNames)
selectedDataNames<-gsub("gravity", "Gravity", selectedDataNames)
selectedDataNames<-c(selectedDataNames, "activity", "subject")
names(selectedData) <- selectedDataNames


#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(data.table)
DT <- data.table(selectedData)
resultData <- DT[,lapply(.SD,mean), by="activity,subject"]
write.table(resultData,file="resultData.csv",sep=",",row.names = FALSE)