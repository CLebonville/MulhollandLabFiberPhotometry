function [ANvalues,APeakData,peakValuesA,peakLocationsA,BNvalues,BPeakData,peakValuesB,peakLocationsB,dF_FAsmooth2,dF_FBsmooth2,ChannelAMeanPeakData, ChannelBMeanPeakData, ChannelARawPeakData, ChannelBRawPeakData] = FindPeaksPJMCL(dF_FA, dF_FB);

% Reference for use of 'findpeaks' function: Steinmetz et al., 2017, eNeuro,
% 4(5), e0207-e17,2017, 1-15

%frequency of our FP data collection
Frequency = 1017.25262451172;

%Smooth the data to help identify peaks
dF_FAsmooth = smoothdata(dF_FA,'SmoothingFactor',0.02);
dF_FBsmooth = smoothdata(dF_FB,'SmoothingFactor',0.02);

%Do not identify peaks in the first or last X seconds to avoid problems
%generating the averaged graphs
TimeFromStart = 8.1;% if you need to cut off any time (in seconds) from the beginning, change it here.
TimeFromEnd = 8.1; %if you need to cut off any time from the end, change it here.
Start = TimeFromStart*Frequency;
Stop = length(dF_FAsmooth)-TimeFromEnd*Frequency; 
dF_FAsmooth2 = dF_FAsmooth(Start:Stop);
dF_FBsmooth2 = dF_FBsmooth(Start:Stop);

%seconds before and after each peak to generate graph of averaged data
SecBeforeAfter = 8;
TimePrePostPeak = SecBeforeAfter*Frequency;

%You can set values (in seconds) for 'MinPeakProminence',
%'MinPeakDistance', and 'MaxPeakWidth' to settings of your choice. There
%are other variables that you can use to define the peaks - they are shown
%at the end of this script and found within the findpeaks.m MATLAB
%function. For example, set maximum peak width for channels A and B by adding
%'maxPeakWidth', MaxPEAKwidth to the findpeaks function, then define MaxPEAKwidth = 20;

% Calculate median absolute deviation (a 'robust' measure of the variability
% of a univariate sample of quantitative data) for channels A and B,
% multiple it by 2, and use this for MinPeakProminence - based on studies
% by Calipari et al., 2016 and Gunaydin et al., 2014 - they used 2.91 * MAD,
% but this threshold misses too many events in our data.

MADA = (mad(dF_FAsmooth, 1)*1);
MADB = (mad(dF_FBsmooth, 1)*1);

%---------------------------------Channel A-------------------------------------------------------------------
%-------------------------------------------------------------------------------------------------------------
[peakValues, peakLocations, widths, prominences] = findpeaks(dF_FAsmooth2, Frequency, 'MinPeakProminence', MADA);
ANvalues = numel(peakLocations);
AIPI = (diff(peakLocations));
AMeanIPI = mean(AIPI);
AStdMeanIPI = std(AIPI);
ASEMMeanIPI = AStdMeanIPI/sqrt(ANvalues);
AMeanPeak = mean(prominences);
AStdMeanPeak = std(prominences);
ASEMMeanPeak = AStdMeanPeak/sqrt(ANvalues);
AMeanWidths = mean(widths);
AStdMeanWidths = std(widths);
ASEMMeanWidths = AStdMeanPeak/sqrt(ANvalues);
ARecordingDuration = length(dF_FAsmooth2)/Frequency;
APeakFrequency = ANvalues/ARecordingDuration;
AAllMeanPeakData = [AMeanIPI, AStdMeanIPI, ASEMMeanIPI, AMeanPeak, AStdMeanPeak, ASEMMeanPeak, AMeanWidths, AStdMeanWidths, ASEMMeanWidths, ANvalues, ARecordingDuration, MADA];
peakValuesA = transpose(peakValues);
peakLocationsA = transpose(peakLocations);
widthsA = transpose(widths);
prominencesA = transpose(prominences);
AAllRawPeakData = [peakValuesA,peakLocationsA,widthsA,prominencesA];


% Extract data surround peaks
APeakData=[];
peakLocationsTime = peakLocationsA*Frequency + TimeFromStart*Frequency;
for i = 1:(length(peakLocationsA))
    APeakData(:,i) = dF_FAsmooth(peakLocationsTime(i)-TimePrePostPeak:peakLocationsTime(i)+TimePrePostPeak);
end
APeakData = transpose(APeakData);


%---------------------------------CHANNEL A TABLES------------------------------------------------------------
%-------------------------------------------------------------------------------------------------------------
ChannelAOutput=[AMeanIPI, AStdMeanIPI, ASEMMeanIPI, AMeanPeak, AStdMeanPeak, ASEMMeanPeak, AMeanWidths, AStdMeanWidths, ASEMMeanWidths, ANvalues, ARecordingDuration, APeakFrequency, MADA];
ChannelAMeanPeakData=array2table(ChannelAOutput);
ChannelAMeanPeakData.Properties.VariableNames = {'AMeanIPI', 'AStdMeanIPI', 'ASEMMeanIPI', 'AMeanPeak', 'AStdMeanPeak', 'ASEMMeanPeak', 'AMeanWidths', 'AStdMeanWidths', 'ASEMMeanWidths', 'ANvalues', 'ARecordingDuration', 'APeakFrequency', 'MADA'};
% writetable(ChannelAMeanPeakData,'E:\JR25\PreCIE Results\m4 wk2\ChannelAMeanPeakData.xlsx');

% peakValues=transpose(peakValues);
% peakLocations=transpose(peakLocations);
% widths=transpose(widths);
% prominences=transpose(prominences);
ChannelARawPeakData=[peakValuesA, peakLocationsA, widthsA, prominencesA];
ChannelARawPeakData=array2table(ChannelARawPeakData);
ChannelARawPeakData.Properties.VariableNames = {'PeakRawValuesA', 'PeakLocationsA', 'PeakWidthsA', 'PeakAProminences'};
% writetable(ChannelARawPeakData, 'E:\JR25\PreCIE Results\m4 wk2\ChannelARawPeakData.xlsx');


%---------------------------------Channel B-------------------------------------------------------------------
%-------------------------------------------------------------------------------------------------------------
[peakValues,peakLocations,widths,prominences] = findpeaks(dF_FBsmooth2, Frequency, 'MinPeakProminence', MADB);
BNvalues = numel(peakLocations);
BIPI = (diff(peakLocations));
BMeanIPI = mean(BIPI);
BStdMeanIPI = std(BIPI);
BSEMMeanIPI = BStdMeanIPI/sqrt(BNvalues);
BMeanPeak = mean(prominences);
BStdMeanPeak = std(prominences);
BSEMMeanPeak = BStdMeanPeak/sqrt(BNvalues);
BMeanWidths = mean(widths);
BStdMeanWidths = std(widths);
BSEMMeanWidths = BStdMeanPeak/sqrt(BNvalues);
BRecordingDuration = length(dF_FBsmooth2)/Frequency;
BPeakFrequency = BNvalues/BRecordingDuration;
BAllMeanPeakData = [BMeanIPI, BStdMeanIPI, BSEMMeanIPI, BMeanPeak, BStdMeanPeak, BSEMMeanPeak, BMeanWidths, BStdMeanWidths, BSEMMeanWidths, BNvalues, BRecordingDuration, MADB];
peakValuesB = transpose(peakValues);
peakLocationsB = transpose(peakLocations);
widthsB = transpose(widths);
prominencesB = transpose(prominences);
BAllRawPeakData = [peakValuesB,peakLocationsB,widthsB,prominencesB];

% Extract data surround peaks
BPeakData=[];
peakLocationsTimeB = peakLocationsB*Frequency + TimeFromStart*Frequency;
for i = 1:(length(peakLocationsB));
    BPeakData(:,i) = dF_FBsmooth(peakLocationsTimeB(i)-TimePrePostPeak:peakLocationsTimeB(i)+TimePrePostPeak);
end
BPeakData = transpose(BPeakData);

%---------------------------------CHANNEL B TABLES------------------------------------------------------------
%-------------------------------------------------------------------------------------------------------------
ChannelBOutput=[BMeanIPI, BStdMeanIPI, BSEMMeanIPI, BMeanPeak, BStdMeanPeak, BSEMMeanPeak, BMeanWidths, BStdMeanWidths, BSEMMeanWidths, BNvalues, BRecordingDuration, BPeakFrequency, MADB];
ChannelBMeanPeakData=array2table(ChannelBOutput);
ChannelBMeanPeakData.Properties.VariableNames = {'BMeanIPI', 'BStdMeanIPI', 'BSEMMeanIPI', 'BMeanPeak', 'BStdMeanPeak', 'BSEMMeanPeak', 'BMeanWidths', 'BStdMeanWidths', 'BSEMMeanWidths', 'BNvalues', 'BRecordingDuration', 'BPeakFrequency', 'MADB'};
% writetable(ChannelBMeanPeakData,'E:\JR25\PreCIE Results\m4 wk2\ChannelBMeanPeakData.xlsx');

ChannelBRawPeakData=[peakValuesB,peakLocationsB,widthsB,prominencesB];
ChannelBRawPeakData=array2table(ChannelBRawPeakData);
ChannelBRawPeakData.Properties.VariableNames = {'PeakRawValuesB', 'PeakLocationsB', 'PeakWidthsB', 'PeakAProminencesB'};
% writetable(ChannelBRawPeakData, 'E:\JR25\PreCIE Results\m4 wk2\ChannelBRawPeakData.xlsx');

%%%%%%%%%%% Plot averaged events from Start of averaged data - use this to start the averaged data from zero %%%%%%%%%%%%%%
% BaselineA = mean(APeakData(1:i)); % mean of the first data point in the extracted data set
% ANormalizeBaselineData = APeakData- BaselineA; % average based on the baseline
% MeanABaselineData = mean(ANormalizeBaselineData);
% StdABaselineData = std(ANormalizeBaselineData);
% ASEMBaselineData = StdABaselineData/sqrt(ANvalues);
% TimeA = linspace(1/1017.252625, length(APeakData)/1017.252625, length(APeakData));
% figure
% hold on;
% plot(TimeA, MeanABaselineData, 'Color', [0 0.6 0.2], 'LineWidth', 1.5);
% xlabel('{\bfTime} (seconds)', 'FontSize', 16);
% xticklabels({'-3','-2','-1','0','1','2','3'})
% ylabel('{\bf\Delta{\itF/F}} (%)', 'FontSize', 16);
% title('Channel A');

% ADD SEM to plot
% hold on
% plot(TimeA, [MeanABaselineData - ASEMBaselineData;MeanABaselineData + ASEMBaselineData], 'LineStyle','none');
% fill( [TimeA, fliplr(TimeA)], [MeanABaselineData + ASEMBaselineData fliplr(MeanABaselineData - ASEMBaselineData)], [0 0.6 0.2], 'EdgeColor','none');
% alpha(.2);

%-----------------------------------------------------------------------------------------------------------------------------------------------------

%function [Ypk,Xpk,Wpk,Ppk] = findpeaks(Yin,varargin)
%FINDPEAKS Find local peaks in data
%   PKS = FINDPEAKS(Y) finds local peaks in the data vector Y. A local peak
%   is defined as a data sample which is either larger than the two
%   neighboring samples or is equal to Inf.
%
%   [PKS,LOCS]= FINDPEAKS(Y) also returns the indices LOCS at which the
%   peaks occur.
%
%   [PKS,LOCS] = FINDPEAKS(Y,X) specifies X as the location vector of data
%   vector Y. X must be a strictly increasing vector of the same length as
%   Y. LOCS returns the corresponding value of X for each peak detected.
%   If X is omitted, then X will correspond to the indices of Y.
%
%   [PKS,LOCS] = FINDPEAKS(Y,Fs) specifies the sample rate, Fs, as a
%   positive scalar, where the first sample instant of Y corresponds to a
%   time of zero.
%
%   [...] = FINDPEAKS(...,'MinPeakHeight',MPH) finds only those peaks that
%   are greater than the minimum peak height, MPH. MPH is a real-valued
%   scalar. The default value of MPH is -Inf.
%
%   [...] = FINDPEAKS(...,'MinPeakProminence',MPP) finds peaks guaranteed
%   to have a vertical drop of more than MPP from the peak on both sides
%   without encountering either the end of the signal or a larger
%   intervening peak. The default value of MPP is zero.
%
%   [...] = FINDPEAKS(...,'Threshold',TH) finds peaks that are at least
%   greater than both adjacent samples by the threshold, TH. TH is a
%   real-valued scalar greater than or equal to zero. The default value of
%   TH is zero.
%
%   FINDPEAKS(...,'WidthReference',WR) estimates the width of the peak as
%   the distance between the points where the signal intercepts a
%   horizontal reference line. The points are found by linear
%   interpolation. The height of the line is selected using the criterion
%   specified in WR:
% 
%    'halfprom' - the reference line is positioned beneath the peak at a
%       vertical distance equal to half the peak prominence.
% 
%    'halfheight' - the reference line is positioned at one-half the peak 
%       height. The line is truncated if any of its intercept points lie
%       beyond the borders of the peaks selected by the 'MinPeakHeight',
%       'MinPeakProminence' and 'Threshold' parameters. The border between
%       peaks is defined by the horizontal position of the lowest valley
%       between them. Peaks with heights less than zero are discarded.
% 
%    The default value of WR is 'halfprom'.
%
%   [...] = FINDPEAKS(...,'MinPeakWidth',MINW) finds peaks whose width is
%   at least MINW. The default value of MINW is zero.
%
%   [...] = FINDPEAKS(...,'MaxPeakWidth',MAXW) finds peaks whose width is
%   at most MAXW. The default value of MAXW is Inf.
%
%   [...] = FINDPEAKS(...,'MinPeakDistance',MPD) finds peaks separated by
%   more than the minimum peak distance, MPD. This parameter may be
%   specified to ignore smaller peaks that may occur in close proximity to
%   a large local peak. For example, if a large local peak occurs at LOC,
%   then all smaller peaks in the range [N-MPD, N+MPD] are ignored. If not
%   specified, MPD is assigned a value of zero.  
%
%   [...] = FINDPEAKS(...,'SortStr',DIR) specifies the direction of sorting
%   of peaks. DIR can take values of 'ascend', 'descend' or 'none'. If not
%   specified, DIR takes the value of 'none' and the peaks are returned in
%   the order of their occurrence.
%
%   [...] = FINDPEAKS(...,'NPeaks',NP) specifies the maximum number of peaks
%   to be found. NP is an integer greater than zero. If not specified, all
%   peaks are returned. Use this parameter in conjunction with setting the
%   sort direction to 'descend' to return the NP largest peaks. (see
%   'SortStr')
%
%   [PKS,LOCS,W] = FINDPEAKS(...) returns the width, W, of each peak by
%   linear interpolation of the left- and right- intercept points to the
%   reference defined by 'WidthReference'.
%
%   [PKS,LOCS,W,P] = FINDPEAKS(...) returns the prominence, P, of each
%   peak.
%
%   FINDPEAKS(...) without output arguments plots the signal and the peak
%   values it finds
%
%   FINDPEAKS(...,'Annotate',PLOTSTYLE) will annotate a plot of the
%   signal with PLOTSTYLE. If PLOTSTYLE is 'peaks' the peaks will be
%   plotted. If PLOTSTYLE is 'extents' the signal, peak values, widths,
%   prominences of each peak will be annotated. 'Annotate' will be ignored
%   if called with output arguments. The default value of PLOTSTYLE is
%   'peaks'.
%
%   % Example 1:
%   %   Plot the Zurich numbers of sunspot activity from years 1700-1987
%   %   and identify all local maxima at least six years apart
%   load sunspot.dat
%   findpeaks(sunspot(:,2),sunspot(:,1),'MinPeakDistance',6)
%   xlabel('Year');
%   ylabel('Zurich number');
%
%   % Example 2: 
%   %   Plot peak values of an audio signal that drop at least 1V on either
%   %   side without encountering values larger than the peak.
%   load mtlb
%   findpeaks(mtlb,Fs,'MinPeakProminence',1)
%
%   % Example 3:
%   %   Plot all peaks of a chirp signal whose widths are between .5 and 1 
%   %   milliseconds.
%   Fs = 44.1e3; N = 1000;
%   x = sin(2*pi*(1:N)/N + (10*(1:N)/N).^2);
%   findpeaks(x,Fs,'MinPeakWidth',.5e-3,'MaxPeakWidth',1e-3, ...
%             'Annotate','extents')
%
%   See also MAX, FINDSIGNAL, FINDCHANGEPTS.

%   Copyright 2007-2016 The MathWorks, Inc.

%#ok<*EMCLS>
%#ok<*EMCA>
%#codegen
