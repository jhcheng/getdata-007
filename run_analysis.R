library("reshape2")

# read feature information and activity labels
features <- read.csv("./UCI HAR Dataset/features.txt", sep="", header=F, strip.white=T, stringsAsFactors=F)
activity_labels <- read.csv("./UCI HAR Dataset/activity_labels.txt", sep="", header=F, strip.white=T, stringsAsFactors=F)

# read data
x_test <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep="", header=F, strip.white=T)
y_test <- read.csv("./UCI HAR Dataset/test/Y_test.txt", sep="", header=F, strip.white=T)
subject_test <- read.csv("./UCI HAR Dataset/test/subject_test.txt", sep="", header=F, strip.white=T)
x_train <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep="", header=F, strip.white=T)
y_train <- read.csv("./UCI HAR Dataset/train/Y_train.txt", sep="", header=F, strip.white=T)
subject_train <- read.csv("./UCI HAR Dataset/train/subject_train.txt", sep="", header=F, strip.white=T)

# 1.Merges the training and the test sets to create one data set
data <- rbind(cbind(y_test, subject_test, x_test), cbind(y_train, subject_train, x_train))
names(data) <- c("activity", "subject", features[,2])

# 2.Extracts only the measurements on the mean and standard deviation for each measurement
data <- data[,c(1, 2, grep("mean\\(\\)|std\\(\\)", names(data)))]

# 3.Uses descriptive activity names to name the activities in the data set
data$activity <- factor(data$activity, levels = activity_labels[,1], labels=activity_labels[,2])

# 4.Appropriately labels the data set with descriptive variable names
#   already done in step 1

# 5.From the data set in step 4, 
#   creates a second, independent tidy data set with the average of each variable for each activity and each subject
dt <- melt(data, id=c("activity", "subject"))
tidy_data <- dcast(dt, activity + subject ~ variable, mean)
write.table(tidy_data, "tidy_data.txt", row.names = F)
