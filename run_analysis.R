library(data.table)
setwd("C:/Users/Harry Ahn/Documents/Duke/Coursera/Coursera3/UCI HAR Dataset")

# Reading data
features <- read.csv('features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])

train_x <- read.table('./train/X_train.txt')
train_activity <- read.csv('./train/y_train.txt', header = FALSE, sep = ' ')
train_subject <- read.csv('./train/subject_train.txt',header = FALSE, sep = ' ')
train <-  data.frame(train_subject, train_activity, train_x)
names(train) <- c(c('subject', 'activity'), features)

test_x <- read.table('./test/X_test.txt')
test_activity <- read.csv('./test/y_test.txt', header = FALSE, sep = ' ')
test_subject <- read.csv('./test/subject_test.txt',header = FALSE, sep = ' ')
test <-  data.frame(test_subject, test_activity, test_x)
names(test) <- c(c('subject', 'activity'), features)

# Merge data
Total <- rbind(train, test)

index <- grep('mean|std', features)
Part <- Total[,c(1,2,index + 2)]

# Label with activity
activity.labels <- read.table('activity_labels.txt', header = FALSE)
activity.labels <- as.character(activity.labels[,2])
Part$activity <- activity.labels[Part$activity]

# Name the variables
Nnames <- names(Part)
Nnames <- gsub("[(][)]", "", Nnames)
Nnames <- gsub("^t", "TimeDomain_", Nnames)
Nnames <- gsub("^f", "FrequencyDomain_", Nnames)
Nnames <- gsub("Acc", "Accelerometer", Nnames)
Nnames <- gsub("Gyro", "Gyroscope", Nnames)
Nnames <- gsub("Mag", "Magnitude", Nnames)
Nnames <- gsub("-mean-", "_Mean_", Nnames)
Nnames <- gsub("-std-", "_StandardDeviation_", Nnames)
Nnames <- gsub("-", "_", Nnames)
names(Part) <- Nnames

# independent tidy data set
average <- aggregate(x=Part[,-c(1,2)], by=list(activities=Part$activity, subj=Part$subject), FUN=mean)
write.table(x = data.tidy, file = "data_tidy.txt", row.names = FALSE)
