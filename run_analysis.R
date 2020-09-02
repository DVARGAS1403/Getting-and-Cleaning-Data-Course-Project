# Load libraries

library(data.table)
library(dplyr)

data_dir <- "~/R/UCI HAR Dataset"

# Load train data
train_x <- read.table(paste(sep = "", data_dir, "/train/X_train.txt"), header=FALSE)
train_y <- read.table(paste(sep = "", data_dir, "/train/Y_train.txt"), header=FALSE)
train_sub <- read.table(paste(sep = "", data_dir, "/train/subject_train.txt"), header=FALSE)


# Load testest data
test_x <- read.table(paste(sep = "", data_dir, "/test/X_test.txt"), header=FALSE)
test_y <- read.table(paste(sep = "", data_dir, "/test/Y_test.txt"), header=FALSE)
test_sub <- read.table(paste(sep = "", data_dir, "/test/subject_test.txt"), header=FALSE)

# Merge train/test data
x_data <- rbind(train_x, test_x)
y_data <- rbind(train_y, test_y)
data_sub <- rbind(train_sub, test_sub)

# Load activity labels + features
act_labels <- read.table(paste(sep = "", data_dir, "/activity_labels.txt"), header = FALSE)
act_labels[,2] <- as.character(act_labels[,2])
features <- read.table(paste(sep = "", data_dir, "/features.txt"),header = FALSE)
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
sel_feat <- grep(".*mean.*|.*std.*", features[,2])
sel_feat_names <- features[sel_feat,2]
sel_feat_names = gsub('-mean', 'Mean', sel_feat_names)
sel_feat_names = gsub('-std', 'Std', sel_feat_names)
sel_feat_names <- gsub('[-()]', '', sel_feat_names)

# Extract data by cols & using descriptive name
x_data <- x_data[sel_feat]
full_data <- cbind(data_sub, y_data, x_data)
colnames(full_data) <- c("Subject", "Activity", sel_feat_names)


tidy_set <- aggregate(. ~Subject + Activity, full_data, mean)
tidy_set <- tidy_set[order(tidy_set$Subject, tidy_set$Activity), ]

# 5.2 Writing second tidy data set into a txt file
write.table(tidy_set, file = paste(sep = "", data_dir, "tidyset.txt"), row.names = FALSE)
