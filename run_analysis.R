# Getting raw data into data frame
test_triaxial_data <- read.table("UCI HAR Dataset/test/X_test.txt", sep = "" , header = F, na.strings ="", stringsAsFactors= F)
train_triaxial_data <- read.table("UCI HAR Dataset/train/X_train.txt", sep = "" , header = F, na.strings ="", stringsAsFactors= F)
test_subject_data <- read.table("UCI HAR Dataset/test/subject_test.txt", sep = "" , header = F, na.strings ="", stringsAsFactors= F)
train_subject_data <- read.table("UCI HAR Dataset/train/subject_train.txt", sep = "" , header = F, na.strings ="", stringsAsFactors= F)
test_activity_data <- read.table("UCI HAR Dataset/test/y_test.txt", sep = "" , header = F, na.strings ="", stringsAsFactors= F)
train_activity_data <- read.table("UCI HAR Dataset/train/y_train.txt", sep = "" , header = F, na.strings ="", stringsAsFactors= F)
test_triaxial_df <- data.frame(test_triaxial_data)
train_triaxial_df <- data.frame(train_triaxial_data)
test_subject_df <- data.frame(test_subject_data)
train_subject_df <- data.frame(train_subject_data)
test_activity_df <- data.frame(test_activity_data)
train_activity_df <- data.frame(train_activity_data)

# Get features/variables list
# Create names() vector 
# Assign new names to test triaxial and train triaxial data frames
features_raw_data <- read.table("UCI HAR Dataset/features.txt", sep = "" , header = F, na.strings ="", stringsAsFactors= F)
features_df <- data.frame(features_raw_data)
features_names <- features_df$V2
names(test_triaxial_df) <- as.vector(features_names)
names(train_triaxial_df) <- as.vector(features_names)

# Column and row bind subject and activity data frames
subject_df <- rbind(test_subject_df,train_subject_df)
activity_df <- rbind(test_activity_df,train_activity_df)
sub_act_df <- cbind(subject_df,activity_df)
names(sub_act_df) <- c("subject","activity_code") # Rename sub_act_df variables

# Create activity_name variable
log_1 <- (sub_act_df$activity_code == 1)
log_2 <- (sub_act_df$activity_code == 2)
log_3 <- (sub_act_df$activity_code == 3)
log_4 <- (sub_act_df$activity_code == 4)
log_5 <- (sub_act_df$activity_code == 5)
log_6 <- (sub_act_df$activity_code == 6)
sub_act_df$activity_name <- ifelse(test = TRUE, yes = "NA", no = "NA") # Creating blanc variable
sub_act_df$activity_name[log_1] <- "walking"
sub_act_df$activity_name[log_2] <- "walking_upstairs"
sub_act_df$activity_name[log_3] <- "walking_downstairs"
sub_act_df$activity_name[log_4] <- "sitting"
sub_act_df$activity_name[log_5] <- "standing"
sub_act_df$activity_name[log_6] <- "laying"

# Row bind train triaxial and test triaxial data frames
df <- rbind(test_triaxial_df,train_triaxial_df)

# Subset data frame with only mean and std variables
subset_vector <- as.vector(which(grepl("mean",features_df$V2) | grepl("std",features_df$V2)))
df <- df[subset_vector]

# Column bind triaxial subsetted data frames with subject+activity data frames
final_df <- cbind(df,sub_act_df)

# Create new data frame that presents the average of each variable for each activity for each subject
new_df <- aggregate(x = final_df, by = list(final_df$activity_code, final_df$activity_name, final_df$subject), FUN = mean)
new_df <- new_df[1:82] # Getting rid of duplicate/unused vectors
names(new_df)[1:3] <- c("activity_code","activity_name","subject")
new_df <- new_df[order(new_df$subject, new_df$activity_code),] # Sorting the new clean data set
row.names(new_df) <- seq(nrow(new_df)) # Cleaning row.names vector
new_df[,1:3] <- new_df[,3:1] # Swapping columns
names(new_df)[1:3] <- names(new_df)[3:1] # Swap columns changed names correction

# Write both data sets to .txt files
write.table(x = final_df,file = "main_data.txt",sep = " ",row.names = FALSE)
write.table(x = new_df,file = "summarized_data.txt",sep = " ",row.names = FALSE)