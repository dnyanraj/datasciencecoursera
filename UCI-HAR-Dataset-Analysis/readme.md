##About
This repo contains [<code>run_analysis.R</code>](https://github.com/dnyanraj/datasciencecoursera/blob/master/UCI-HAR-Dataset-Analysis/run_analysis.R) script which can be used to create a tidy dataset from Human Activity Recognition raw dataset. Details of source data, data transformation steps and structure of the final output are specified in [<code>Codebook.md</code>](https://github.com/dnyanraj/datasciencecoursera/blob/master/UCI-HAR-Dataset-Analysis/Codebook.md)

##How to Run Code
- Sync the repo
- Download the Human Activity Recognition dataset into R Working Directory and unzip it
- Source and run <code>run_analysis.R</code>
- <code>rtidy.txt</code> will be generated in R Working Directory

##File Structure
- UCI HAR Dataset folder should contain <code>test</code> and <code>train</code> folders
- Activity Ids are in <code>y_*.txt</code>
- Measurements are in <code>x_*.txt</code>
- Subject Ids are in <code>subject_*.txt</code>
- Activity Id to Activity Label mapping is available in <code>activity_lables.txt</code>
- Measurement Variable are defined in <code>activity_lables.txt</code>
- Feature names containing mean and std values have <code>mean</code> and <code>std</code> in the feature label. These are identified by <code>grep</code>ing for these two patterns.

