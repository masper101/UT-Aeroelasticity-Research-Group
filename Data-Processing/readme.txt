Files that can be used to process data 

plot_mic_cal_data.m : Reads (calibration) audio files and plots the magnitude of the highest peak in the Fourier Transform

ffind_dft.m         : Function to calculate DFT, called by plot_mic_cal_data.m 

fcleanup.m          : Function to filter/ cleanup a time vector. Can use either of 
                      (a) smoothdata 
                      (b) moving average
                      (c) lowpass + bandstop (harmonics of 1/rev)

fmycorr.m           : Function to calculate cross-correlation between two time vectors and find the time shift that maximizes the               
                      cross-correlation
                      
pitchangle_collect_0.m  : Reads streaming data files and collects pitch angle data. Stores it to a data file.

pitchangle_process_1.m  : Reads the data file created by pitchangle_collect_0.m and processes it to find time shifts, average and 
                          standard deviation
                          
StepProcess : This function is used to process loads data with step input 

fprocStep: Function is used to determine when the step input occurs
