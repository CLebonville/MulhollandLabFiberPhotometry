% To run the loop, you need to create FOUR folders named "Analyze", "Results", "Figures", and "Lick Analysis". 
% Put all of the files for analysis into the "Analyze" folder. Then, paste the path to this folder
% on LINE 13. Within the "Figures" and "Lick Analysis" folders, you also want to create a subfolder called "MATLAB Figures" 
% to separate the MATLAB figures from the JPGs for easy browsing.
% 
% Unlike our other functions, you don't run the loop function by entering commands into the 
% command window. Rather, make sure the Loop function is in the forefront of the Editor and 
% click the big green "Run" arrow in the Editor tab near the top middle of the screen. The loop
% will save Excel files to the Results folder and figures to the Figures folder for each channel 
% in the dual channel recordings.

%Where the data files are located:
%directory = 'H:\Desktop\2022.10.10 (CL20) CeA Dyn FP in Drinking Hedonics (CL20)\Drinking\Analyze\';
%directory = 'Z:\Christina Lebonville\2020.06.16 (CL8 or DRK-MK) CeA Dyn Fiber Recording in DID\Fiber Photometry Data\Cohort1_Recordings\';
directory = 'Z:\Christina Lebonville\2020.06.16 (CL8 or DRK-MK) CeA Dyn Fiber Recording in DID\Fiber Photometry Data\Cohort2_Recordings\';
Results = [directory,'..','\Results\'];
Figures = [directory,'..','\Figures\'];
Licks = [directory,'..','\Lick Analysis\'];

%directory = 'H:\CL8_PJM\Recordings';
% Results = [directory,'..','\Results\'];
% Figures = [directory,'..','\Figures\'];
% Licks = [directory, '..','\Lick Analysis\'];


FiguresMat = [Figures, '\MATLAB Figures\'];
LicksMat = [Licks, '\MATLAB Figures\'];
files = dir(directory);

dirFlags = [files.isdir] & ~strcmp({files.name},'.') & ~strcmp({files.name},'..');
Folders = files(dirFlags);
clear files dirFlags

nFiles=length(Folders);

for i=30 % To restart from a particular file or run custom file range
% for i=1:nFiles % All files
	fprintf('<strong>Processing: %s %d/%d</strong>\nData ',Folders(i).name,i,nFiles)
    %Where the data files are located:
    FN1=[directory, Folders(i).name];
    
    %Where you want the result excel files to go
    FN3=[Results, Folders(i).name, 'resultsA.xlsx'];
    FN4=[Results, Folders(i).name, 'resultsB.xlsx'];

    data=TDTbin2mat(FN1);
    DATAPATH=FN1; %This is for the CumulativeLicksPlot function
    [Fig1,Fig2,Fig3,Fig4,Fig5,Fig6,Fig7,Fig8,MeanSlopeTableA, ChannelAMeanPeakData, ChannelARawPeakData, ABoutData, AEventRawDATA, AEventAverages, MeanSlopeTableB, ChannelBMeanPeakData, ChannelBRawPeakData, BBoutData, BEventRawDATA, BEventAverages, AGraphBoutBefore, AGraphBoutAfter, BGraphBoutBefore, BGraphBoutAfter] = FullAnalysis_dualCL_v2(data,DATAPATH);
    writetable(MeanSlopeTableA, FN3, 'Sheet', 1)
    writetable(ChannelAMeanPeakData, FN3, 'Sheet', 2)
    writetable(ChannelARawPeakData, FN3, 'Sheet', 3)
    writetable(ABoutData, FN3, 'Sheet', 4)
    writetable(AEventRawDATA, FN3, 'Sheet', 5)
    writetable(AEventAverages, FN3, 'Sheet', 6)
    writetable(AGraphBoutBefore, FN3, 'Sheet', 7)
    writetable(AGraphBoutAfter, FN3, 'Sheet', 8)
    
    save([Results, Folders(i).name, 'ChannelAdata.mat'], 'MeanSlopeTableA', 'ChannelAMeanPeakData', 'ABoutData', 'AEventAverages')
    clear MeanSlopeTableA ChannelAMeanPeakData  ABoutData  AEventAverages;
    
    % CL added code to save each output figure as both a JPEG and MatLab figure then close
    saveas(Fig1,[FiguresMat, Folders(i).name, 'GraphOverallA.fig']);
    saveas(Fig1,[Figures, Folders(i).name, 'GraphOverallA.jpg']);
    close(Fig1);
    saveas(Fig2,[FiguresMat, Folders(i).name, 'GraphOverallB.fig']);
    saveas(Fig2,[Figures, Folders(i).name, 'GraphOverallB.jpg']);
    close(Fig2);
    saveas(Fig3,[FiguresMat, Folders(i).name, 'GraphPeaksA.fig']);
    saveas(Fig3,[Figures, Folders(i).name, 'GraphPeaksA.jpg']);
    close(Fig3);
    saveas(Fig4,[FiguresMat, Folders(i).name, 'GraphPeaksAvgA.fig']);
    saveas(Fig4,[Figures, Folders(i).name, 'GraphPeaksAvgA.jpg']);
    close(Fig4);
    saveas(Fig5,[FiguresMat, Folders(i).name, 'GraphPeaksB.fig']);
    saveas(Fig5,[Figures, Folders(i).name, 'GraphPeaksB.jpg']);
    close(Fig5);
    saveas(Fig6,[FiguresMat, Folders(i).name, 'GraphPeaksAvgB.fig']);
    saveas(Fig6,[Figures, Folders(i).name, 'GraphPeaksAvgB.jpg']);
    close(Fig6);
    saveas(Fig7,[LicksMat, Folders(i).name, 'ALicksCumulative.fig']);
    saveas(Fig7,[Licks, Folders(i).name, 'ALicksCumulative.jpg']);
    close(Fig7);
    saveas(Fig8,[LicksMat, Folders(i).name, 'BLicksCumulative.fig']);
    saveas(Fig8,[Licks, Folders(i).name, 'BLicksCumulative.jpg']);
    close(Fig8);
    clear Fig1 Fig2 Fig3 Fig4 Fig5 Fig6 Fig7 Fig8;
    
    GraphBefore=AGraphBoutBefore;
    GraphAfter=AGraphBoutAfter;
    save([Results, Folders(i).name, 'graphdataA.mat'], 'GraphBefore', 'GraphAfter')
    clear GraphBefore GraphAfter;
    
    writetable(MeanSlopeTableB, FN4, 'Sheet', 1)
    writetable(ChannelBMeanPeakData, FN4, 'Sheet', 2)
    writetable(ChannelBRawPeakData, FN4, 'Sheet', 3)
    writetable(BBoutData, FN4, 'Sheet', 4)
    writetable(BEventRawDATA, FN4, 'Sheet', 5)
    writetable(BEventAverages, FN4, 'Sheet', 6)
    writetable(BGraphBoutBefore, FN4, 'Sheet', 7)
    writetable(BGraphBoutAfter, FN4, 'Sheet', 8)
    
    save([Results, Folders(i).name, 'ChannelBdata.mat'], 'MeanSlopeTableB', 'ChannelBMeanPeakData', 'BBoutData', 'BEventAverages')
    clear MeanSlopeTableB ChannelBMeanPeakData  BBoutData  BEventAverages;
    
    GraphBefore=BGraphBoutBefore;
    GraphAfter=BGraphBoutAfter;
    save([Results, Folders(i).name, 'graphdataB.mat'], 'GraphBefore', 'GraphAfter')
    clear GraphBefore GraphAfter;
      
    %If you want to save anything as a matlab file use this and list all
    %the output in the workspace that you want to save in one file
    %FN2=['W:\Lebonville\2019.10.31 CeA-BNST CIE Fiber Recording (CL4 or DRK-LZ)\Fiber photometry recordings\Results\', Folders(i).name, 'results.mat'];
    %save(FN2);
    
    %Alternative save for individual channels:
%     FN2A=['E:\JR25\Results\', Folders(i).name, 'resultsA.mat'];
%     save(FN2A, 'MeanSlopeTableA','ABoutData');
%     FN2B=['E:\JR25\Results\', Folders(i).name, 'resultsB.mat'];
%     save(FN2B, 'MeanSlopeTableB', 'BBoutData');
    
   end

beep 
