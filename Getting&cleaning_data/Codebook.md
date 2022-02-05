# Codebook

## Record provided:

1. Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
2. Triaxial Angular velocity from the gyroscope. 
3. A 561-feature vector with time and frequency domain variables. 
4. Its activity label. 
5. An identifier of the subject who carried out the experiment.

Using and embedded **accelerometer** and **gyroscope**, they captured 3-axial **linear acceleration** and 3-axial **angular velocity** at a constant rate of 50Hz. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal (tBodyAcc-XYZ and tGravityAcc-XYZ), which has **gravitational** and **body motion** components, was separated using a Butterworth low-pass filter into body **acceleration** and **gravity**.The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used.

Subsequently, the body linear acceleration and angular velocity were derived in **time** to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing **frequencies**:fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag.

