# CleaningAndGettingProject
## Load Packages
```r
library(tidyverse)
library(data.table)
library(magrittr)
```
## Reading Data Sets
```r
FeatureNames<-read.table("features.txt")
ActivityLabels<-read.table("activity_labels.txt",header = F)
#Train sets
ActivityTrain<-read.table("train/y_train.txt",header = F)
SubjectTrain<-read.table("train/subject_train.txt",header = F)
FeatureTrain<-read.table("train/X_train.txt",header = F)
#Test sets
subjectTest<-read.table("test/subject_test.txt",header = F)
activityTest<-read.table("test/y_test.txt",header = F)
FeatureTest<-read.table("test/X_test.txt",header = F)
```

## Part1:  Merges the training and the test sets to create one data set.
```r
Activity<-rbind(ActivityTrain,activityTest)
Subject<-rbind(SubjectTrain,subjectTest)
Features<-rbind(FeatureTrain,FeatureTest)
#naming the columns
colnames(Features)<-t(FeatureNames[2])
colnames(Activity) <- "Activity"
colnames(Subject) <- "Subject"
FullData <- cbind(Features,Activity,Subject)
```
## Part2 : Extracts only the measurements on the mean and standard deviation for each measurement.

```r
mean_STD_selected<-grep(".*Mean.*|.*Std.*", names(FullData), ignore.case=TRUE)

#add activity and subject columns to new data with mean , STD 

measures_required <- c(mean_STD_selected, 562,563)

DataExtracted <- FullData[,measures_required]
#show the dim of data
dim(DataExtracted)
```
## Part3: Uses descriptive activity names to name the activities in the data set.
#convert Activity into Character datatype to naming obs with names of ActivityLables dataset
```r
DataExtracted$Activity <- as.character(DataExtracted$Activity)
for (i in 1:6){
  DataExtracted$Activity[DataExtracted$Activity == i] <- as.character(ActivityLabels[i,2])
}
#make Activity as factor for lables
DataExtracted$Activity <- as.factor(DataExtracted$Activity)
```

## Part4: Appropriately labels the data set with descriptive variable names.
#use gsub() function to replace all Characters we wanted
```r
names(DataExtracted)<-gsub("Acc", "Accelerometer", names(DataExtracted))
names(DataExtracted)<-gsub("Gyro", "Gyroscope", names(DataExtracted))
names(DataExtracted)<-gsub("BodyBody", "Body", names(DataExtracted))
names(DataExtracted)<-gsub("Mag", "Magnitude", names(DataExtracted))
names(DataExtracted)<-gsub("^t", "Time", names(DataExtracted))
names(DataExtracted)<-gsub("^f", "Frequency", names(DataExtracted))
names(DataExtracted)<-gsub("tBody", "TimeBody", names(DataExtracted))
names(DataExtracted)<-gsub("-mean()", "Mean", names(DataExtracted), ignore.case = TRUE)
names(DataExtracted)<-gsub("-std()", "STD", names(DataExtracted), ignore.case = TRUE)
names(DataExtracted)<-gsub("-freq()", "Frequency", names(DataExtracted), ignore.case = TRUE)
names(DataExtracted)<-gsub("angle", "Angle", names(DataExtracted))
names(DataExtracted)<-gsub("gravity", "Gravity", names(DataExtracted))
```
## Part5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#final we want to make a tidy data with Avg of each Activity and each Subject
```r
DataExtracted <- data.table(DataExtracted)
tidyData <- aggregate(. ~Subject + Activity, DataExtracted, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
#this is the final DataSet
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
```

