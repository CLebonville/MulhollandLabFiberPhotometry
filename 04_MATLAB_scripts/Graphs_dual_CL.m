function [Fig1,Fig2,Fig3,Fig4,Fig5,Fig6] = Graphs_dual_CL(yA,yB,Time,APeakData,ANvalues,peakValuesA,peakLocationsA,BNvalues,BPeakData,peakValuesB,peakLocationsB,dF_FA,dF_FB,dF_FAsmooth2,dF_FBsmooth2)
%GRAPHS_DUAL_CL Takes the figures that were originally generated in each
%individual function and makes them all in one place. 
%This allows for custom saving and naming of each of the graphs without
%having to do each manually. Especially with the loop function, this
%process becomes tedious. 

%%This makes the "Overall" figures with calcium signal and overlaid TTL markers for entire
%%session (moved from Doric_mean_normalization_dual). 
%%
%%CL's Experimentation with detrending:
%%Before trying out detrending the data using a polynomial function
%%subtraction,see what the polynomial function looks like. 
%%FA2=polyfit(Time,dF_FA,2);
%%df_FA2=polyval(FA2,Time);
%%FB2=polyfit(Time,dF_FB,2);
%%df_FB2=polyval(FB2,Time);

%%To try out detrending the lines with a polynomial before graphing to get rid of
%%"rainbows". Does not change analysis, only graph to see if analysis
%%should be done with detrended data instead. Use with above function to 
%%both plot the polynomial function AND detrend.
%%dF_FA3=detrend(dF_FA,2);
%%df_FB3=detrend(dF_FB,2);

%%
%Channel A
Fig1=figure;
plot(Time, yA,'Color','r');
hold on;
plot(Time, dF_FA, 'Color', [0 0.6 0.2]);
hold on;

% % %To put the Reference and Calcium signal on same plot
% % Fig3=figure;
% % plot(Time, Chris_RefA,'Color','black');
% % hold on;
% % plot(Time, dF_FA, 'Color', [0 0.6 0.2]);
% % hold on;
% % plot(Time, df_FA2, 'Color', [1,0,1]);
% % hold on;
% % plot(Time, dF_FA3, 'Color', [0 1 1]);
% % hold on;
ylabel('\bf\Delta\itF/F (%)', 'FontSize',14);
xlabel('\bfTime (seconds) ', 'FontSize',14);
title('Channel A');
set(Fig1,'visible','off');

%Channel B
Fig2=figure;
plot(Time, yB,'Color','r');
hold on;
plot(Time,dF_FB, 'Color',[0 0.6 0.2]);
hold on;
%%plot(Time,df_FB2,'Color',[1 0 1]);
%%hold on;
%%plot(Time, df_FB3, 'Color', [0 1 1]);
%%hold on;
ylabel('\bf\Delta\itF/F (%)', 'FontSize',14);
xlabel('\bfTime (seconds) ', 'FontSize',14); 
title('Channel B');
set(Fig2,'visible','off');

%% Plot figures for detected peaks and average peak waveforms (moved from FindPeaksPJM for saving in
%% the loop).

%frequency of our FP data collection
Frequency = 1017.25262451172;

%Channel A Peaks
TimeA=linspace(1/Frequency, length(dF_FAsmooth2)/Frequency, length(dF_FAsmooth2));
Fig3=figure;
plot(TimeA,dF_FAsmooth2, 'Color', [0 0.6 0.2]);
hold on; 
plot(peakLocationsA,peakValuesA, '^', 'LineWidth', 0.5, 'MarkerEdgeColor', [0 0 1], 'MarkerFaceColor', [0.6 0.6 0.6], 'MarkerSize', 4);
xlabel('{\bfTime} (seconds)', 'FontSize', 16);
ylabel('{\bf\Delta{\itF/F}} (%)', 'FontSize', 16);
title('Channel A');
set(gcf, 'Position', [100 600 1500 400]);
set(Fig3,'visible','off');

% Channel A Plot averaged events from Peak
MeanAPeakData = mean(APeakData);
StdAPeakData = std(APeakData);
ASEMPeakData = StdAPeakData/sqrt(ANvalues);
TimeA2=linspace(1/Frequency, length(APeakData)/Frequency, length(APeakData));
Fig4=figure;
%plot vertical line at time 1501:
% v=1.49;y=4.5;plot([v v], [0 y], 'Color', [.7 .7 .7],'LineWidth', 2);
%hold on;
plot(TimeA2, MeanAPeakData, 'Color', [0 0.6 0.2], 'LineWidth', 1.5);
xlabel('{\bfTime} (seconds)', 'FontSize', 16);
xticklabels({'-8', '-6', '-4', '-2', '0', '2', '4', '6', '8'}) % must adjust to match time before and after peak
ylabel('{\bf\Delta{\itF/F}} (%)', 'FontSize', 16);
title('Channel A');
% axis([0 16 0 8]);
set(gcf, 'Position', [1500 600 200 400]);
set(Fig4,'visible','off');

% ADD SEM to plot
hold on
plot(TimeA2, [MeanAPeakData - ASEMPeakData;MeanAPeakData + ASEMPeakData], 'LineStyle','none');
fill( [TimeA2, fliplr(TimeA2)], [MeanAPeakData + ASEMPeakData fliplr(MeanAPeakData - ASEMPeakData)], [0 0.6 0.2], 'EdgeColor','none');
alpha(.3);

%Channel B Peaks
Fig5=figure;
TimeB = linspace(1/Frequency, length(dF_FBsmooth2)/Frequency, length(dF_FBsmooth2));
plot(TimeB,dF_FBsmooth2, 'Color', [0 0.6 0.2]);
hold on; 
plot(peakLocationsB,peakValuesB, '^', 'LineWidth', 0.5, 'MarkerEdgeColor', [0 0 1], 'MarkerFaceColor', [0.6 0.6 0.6], 'MarkerSize', 4);
xlabel('{\bfTime} (seconds)', 'FontSize', 16);
ylabel('{\bf\Delta{\itF/F}} (%)', 'FontSize', 16);
title('Channel B');
set(gcf, 'Position', [100 100 1500 400]);
set(Fig5,'visible','off');

% Channel B Plot averaged events from Peak
MeanBPeakData = mean(BPeakData);
StdBPeakData = std(BPeakData);
BSEMPeak = StdBPeakData/sqrt(BNvalues);
TimeB2 = linspace(1/Frequency, length(BPeakData)/Frequency, length(BPeakData));
Fig6=figure;
plot(TimeB2, MeanBPeakData, 'Color', [0 0.6 0.2], 'LineWidth', 1.5);
xlabel('{\bfTime} (seconds)', 'FontSize', 16);
xticklabels({'-8', '-6', '-4', '-2', '0', '2', '4', '6', '8'})
ylabel('{\bf\Delta{\itF/F}} (%)', 'FontSize', 16);
title('Channel B');
% axis([0 16 0 8]);
set(gcf, 'Position', [1500 100 200 400]);
set(Fig6,'visible','off');

% ADD SEM to plot
hold on
plot(TimeB2, [MeanBPeakData - BSEMPeak;MeanBPeakData + BSEMPeak], 'LineStyle','none');
fill( [TimeB2, fliplr(TimeB2)], [MeanBPeakData + BSEMPeak fliplr(MeanBPeakData - BSEMPeak)], [0 0.6 0.2], 'EdgeColor','none');
alpha(.3);


clear yA yB Time ANvalues peakValuesA peakLocationsA BNvalues peakValuesB peakLocationsB dF_FA dF_FB dF_FAsmooth2 dF_FBsmooth2

end

