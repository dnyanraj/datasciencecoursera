#Codebook For UCI HAR Dataset run_analysis.R

###Source Data
[Original Data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), 
[Full Description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

###Data Transformation Steps
- Read Activity Label, Mean/Std Columns and Set Data <code>x_*.txt</code> for Test Data Set.
- Append ActivityId <code>activity_ label.txt</code> and Subject Id <code>subject_test.txt</code>.
- Subset mean and std value columns.
- Read Activity Label, Mean/Std Columns and Set Data <code>x_*.txt</code> for Training Data Set.
- Append ActivityId <code>activity_ label.txt</code> and Subject Id <code>subject_train.txt</code>.
- Subset mean and std value columns.
- Merge Train and Test data sets.
- Add ActivityName column to merged data set.
- Melt merged datasets with id variables ActivityId, ActivityName, Subject ID and measure variable with mean and std values.
- DCast melted dataset with <code>mean</code> aggregation function over activity name and subject id for all variables
- Write output file <code>tidy.txt</code> in working directory

###Variable Descriptions
Detailed description in <code>featuresinfo.txt</code>, <code>README.txt</code> files.

###Output Data File Structure
<pre><code>
[1] "ActivityName"                "SubjectID"                   "tBodyAcc.mean...X"           "tBodyAcc.mean...Y"          
[5] "tBodyAcc.mean...Z"           "tBodyAcc.std...X"            "tBodyAcc.std...Y"            "tBodyAcc.std...Z"           
[9] "tGravityAcc.mean...X"        "tGravityAcc.mean...Y"        "tGravityAcc.mean...Z"        "tGravityAcc.std...X"        
[13] "tGravityAcc.std...Y"         "tGravityAcc.std...Z"         "tBodyAccJerk.mean...X"       "tBodyAccJerk.mean...Y"      
[17] "tBodyAccJerk.mean...Z"       "tBodyAccJerk.std...X"        "tBodyAccJerk.std...Y"        "tBodyAccJerk.std...Z"       
[21] "tBodyGyro.mean...X"          "tBodyGyro.mean...Y"          "tBodyGyro.mean...Z"          "tBodyGyro.std...X"          
[25] "tBodyGyro.std...Y"           "tBodyGyro.std...Z"           "tBodyGyroJerk.mean...X"      "tBodyGyroJerk.mean...Y"     
[29] "tBodyGyroJerk.mean...Z"      "tBodyGyroJerk.std...X"       "tBodyGyroJerk.std...Y"       "tBodyGyroJerk.std...Z"      
[33] "tBodyAccMag.mean.."          "tBodyAccMag.std.."           "tGravityAccMag.mean.."       "tGravityAccMag.std.."       
[37] "tBodyAccJerkMag.mean.."      "tBodyAccJerkMag.std.."       "tBodyGyroMag.mean.."         "tBodyGyroMag.std.."         
[41] "tBodyGyroJerkMag.mean.."     "tBodyGyroJerkMag.std.."      "fBodyAcc.mean...X"           "fBodyAcc.mean...Y"          
[45] "fBodyAcc.mean...Z"           "fBodyAcc.std...X"            "fBodyAcc.std...Y"            "fBodyAcc.std...Z"           
[49] "fBodyAccJerk.mean...X"       "fBodyAccJerk.mean...Y"       "fBodyAccJerk.mean...Z"       "fBodyAccJerk.std...X"       
[53] "fBodyAccJerk.std...Y"        "fBodyAccJerk.std...Z"        "fBodyGyro.mean...X"          "fBodyGyro.mean...Y"         
[57] "fBodyGyro.mean...Z"          "fBodyGyro.std...X"           "fBodyGyro.std...Y"           "fBodyGyro.std...Z"          
[61] "fBodyAccMag.mean.."          "fBodyAccMag.std.."           "fBodyBodyAccJerkMag.mean.."  "fBodyBodyAccJerkMag.std.."  
[65] "fBodyBodyGyroMag.mean.."     "fBodyBodyGyroMag.std.."      "fBodyBodyGyroJerkMag.mean.." "fBodyBodyGyroJerkMag.std.."
</code></pre>