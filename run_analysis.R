# TODO: Add comment
# 
# Author: kbradbury
###############################################################################


FilePath <- "C:/Coursera/Getting and Cleaning Data/Course Assignment/UCI HAR Dataset"	
D.sep <- "/"
setwd(FilePath)

#read in data
activity_label <- read.table(paste(FilePath,D.sep,"activity_labels.txt",sep="")) #data file includes activity lables
colnames(activity_label) <- c("Label","Activity") #apply header names to make for easier reference
features <- read.table(paste(FilePath,D.sep,"features.txt",sep="")) #data file includes the different variables we will use later
features <- t(features) #transforms the variables into a single row.

#read in the train and test data set then merge together - Step 1
train_set <- read.table(paste(FilePath,D.sep,"train/X_train.txt",sep="")) #read in the training data set
train_labels <- read.table(paste(FilePath,D.sep,"train/y_train.txt",sep="")) #read in the training activity labels
subject_train <- read.table(paste(FilePath,D.sep,"train/subject_train.txt",sep="")) #read in the subject ids
total_train <- cbind(train_set,train_labels,subject_train) #combine to training set, labels, and subjects

test_set <- read.table(paste(FilePath,D.sep,"test/X_test.txt",sep="")) #read in the test set
test_labels <- read.table(paste(FilePath,D.sep,"test/y_test.txt",sep="")) #read in the test activity labels
subject_test <- read.table(paste(FilePath,D.sep,"test/subject_test.txt",sep="")) #read in the subject ids
total_test <- cbind(test_set,test_labels,subject_test) #combine the 3 data sets together

data_set <- rbind(total_train,total_test) #combinne the training and testing datasets

#Extract only the measurements on the mean and standard deviation for each measurement
colnames(data_set) <- c(features[2,],"Label","Subject")   #This is actually step 4 of the assignment. I chose do apply the variable labels here to utilize the grep function to strip out the mean and sttdev variables.
vars <- c(grep("mean()",features,value=T,fixed=T),grep("std()",features,value=T),"Label","Subject") #grep allows you to strip out the header names that satisties certain criteria. In this case I wanted strip out the variable names with mean() or std().
data_sub <- data_set[vars] #creates a subset using the variable names from the previous step.

#Uses descriptive activity names to name the activities in the data set
data_activity <- merge(data_sub,activity_label,by="Label")

#Appriopriately labels the data set with descriptive variable names
#I actually did this step earlier in the script so that I could use the grep function to extract my mean and standard deviation columns.

#Create a second, independent tidy data set with the average of each variable for each activity and each subject
data_mean <- aggregate(.~Subject+Activity,data=data_activity,mean)  #using the aggregate function we can calculate the mean for each of the variables by both Subject and Activity
write.table(data_mean,file="C:/Coursera/Getting and Cleaning Data/Course Assignment/data_mean.txt",row.name=FALSE)



