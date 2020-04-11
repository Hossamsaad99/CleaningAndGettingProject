#load package for this project
library(tidyverse)
library(data.table)
library(magrittr)
#read datasets
#Metadata
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
#Merge Train and Test datasets
Activity<-rbind(ActivityTrain,activityTest)
Subject<-rbind(SubjectTrain,subjectTest)
Features<-rbind(FeatureTrain,FeatureTest)
#naming the columns
colnames(Features)<-t(FeatureNames[2])
colnames(Activity) <- "Activity"
colnames(Subject) <- "Subject"
FullData <- cbind(Features,Activity,Subject)
#Extract mean , StD from each measurments
mean_STD_selected<-grep(".*Mean.*|.*Std.*", names(FullData), ignore.case=TRUE)
#add activity and subject columns to new data with mean , STD 
measures_required <- c(mean_STD_selected, 562,563)

DataExtracted <- FullData[,measures_required]
dim(DataExtracted)
#descriptive activity names
DataExtracted$Activity <- as.character(DataExtracted$Activity)
for (i in 1:6){
  DataExtracted$Activity[DataExtracted$Activity == i] <- as.character(ActivityLabels[i,2])
}
DataExtracted$Activity <- as.factor(DataExtracted$Activity)
#now we will use gsub() to replace descriptive variable names.
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
#now we can see the descriptive variable names
names(DataExtracted)
#create tidy data with avg of each Activity and each Subject
DataExtracted <- data.table(DataExtracted)
tidyData <- aggregate(. ~Subject + Activity, DataExtracted, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
#this is the final DataSet
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
