function [Fig1,Fig2,Fig3,Fig4,Fig5,Fig6,Fig7,Fig8,MeanSlopeTableA, ChannelAMeanPeakData, ChannelARawPeakData, ABoutData, AEventRawDATA, AEventAverages, MeanSlopeTableB, ChannelBMeanPeakData, ChannelBRawPeakData, BBoutData, BEventRawDATA, BEventAverages, AGraphBoutBefore, AGraphBoutAfter, BGraphBoutBefore, BGraphBoutAfter] = FullAnalysis_dualCL_v2(data,DATAPATH)
disp('Starting Normalization...')
[yA,yB,Time,dF_FA,dF_FB, TimeFromStart, TimeFromEnd, MeanSlopeTableA, MeanSlopeTableB] = Joint_normalization_dualCL(data);
disp('Normalization Complete! Starting FindPeaks...')
[ANvalues,APeakData,peakValuesA,peakLocationsA,BNvalues,BPeakData,peakValuesB,peakLocationsB,dF_FAsmooth2,dF_FBsmooth2,ChannelAMeanPeakData, ChannelBMeanPeakData, ChannelARawPeakData, ChannelBRawPeakData] = FindPeaksPJMCL(dF_FA, dF_FB);
disp('FindPeaks Complete! Starting Bout Analysis...')
[ABoutData, BBoutData, ABoutStart, ABoutDuration, BBoutStart, BBoutDuration, AGraphBoutBefore, AGraphBoutAfter, BGraphBoutBefore, BGraphBoutAfter] = bout_analysis_dual_PJMCL_v3(data,dF_FA,dF_FB,TimeFromStart,TimeFromEnd);
disp('Bout Analysis Complete! Starting Event Detection...')
[AEventRawDATA, AEventAverages, BEventRawDATA, BEventAverages] = event_detection_dual_PJM(dF_FA, dF_FB, ABoutStart, ABoutDuration, BBoutStart, BBoutDuration);
disp('Event Detection Complete! Starting Lick Analysis...')
[Fig7,Fig8] = CumulativeLicksPlotCL(data);
disp('Lick Analysis Complete! Starting Graph Generator...')
[Fig1,Fig2,Fig3,Fig4,Fig5,Fig6] = Graphs_dual_CL(yA,yB,Time,APeakData,ANvalues,peakValuesA,peakLocationsA,BNvalues,BPeakData,peakValuesB,peakLocationsB,dF_FA,dF_FB,dF_FAsmooth2,dF_FBsmooth2);
disp('File Complete! Exporting results.')

end