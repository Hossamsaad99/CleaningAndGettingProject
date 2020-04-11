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

## Part1:  Merge Train and Test Sets together
```r
Activity<-rbind(ActivityTrain,activityTest)
Subject<-rbind(SubjectTrain,subjectTest)
Features<-rbind(FeatureTrain,FeatureTest)
```

