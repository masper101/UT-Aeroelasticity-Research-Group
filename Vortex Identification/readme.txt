Algorithms needed to analyze tip vortices in PIV data.

fLoading_data.m                   : Loads all PIV data
fPhase_Align.m                    : Phase-aligns all time-resolved data
fPhase_Align_misaligned_timing.m  : Used to phase_align time-resolved data if a inconsistent timing signal was used during testing
fAlign_blade_passage.m            : Used to determine when blade through meausurement plane. Needed for fPhase_Align_misaligned_timing.m 
fvortexID_settings.m              : Used to set important threshold parameters in fVortexLocation and fVortexSize
fanalyze_vortex.m                 : Calculates average and standard deviation with 95% confidence of all vortex data
ferror_ellipse.m                  : Calculates the uncertainty ellipse with 95% confidence around all instantaneous vortex positions
foutlierdetection.m               : Eliminates erroneous data points
fVortexID.m                       : Runs fVortexLocation and fVortexSize and matches data calculated in each
fVortexLocation_Gamma1.m          : Finds the location of vortex cores in a flowfield
fVortexSize_Gamma2.m              : Calculates the size of vortex core and circulation within the core