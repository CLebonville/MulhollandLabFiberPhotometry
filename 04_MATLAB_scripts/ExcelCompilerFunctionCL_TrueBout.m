% Use this code to compile the EXCEL files from the loop function that
% have been processed by DeepEthogram Model TrueBout into a
% single Excel document. The new Excel document will have data on one sheet. 

%%THIS SCRIPT REQUIRES YOU TO HAVE THE FUNCTION "GetCurrentISODateTime" in
%%your MATLAB path.

%%% STEP ONE ---->>> With all data EXCEL files in a single folder,
%%% specify the path of this folder on LINE 18 for directory. Make sure
%%% that it ends with a \. 

%%% STEP TWO ---->>> Click "Run"

datestr = GetCurrentISODateTime([],'ymdHMS');

directory = 'Z:\Christina Lebonville\2020.06.16 (CL8 or DRK-MK) CeA Dyn Fiber Recording in DID\Fiber Photometry Data\DeepEthogram_TrueBout_Analysis_FinalData\CL8 TrueBout DEG Updated Workbooks\'
DATALOCATION= [directory];
OUTPUTLOCATION = [directory, datestr,'_CompiledData.xls'];

filePattern = fullfile(DATALOCATION,'*.xlsx');

matFiles = dir(filePattern);

cn={'SigMean','SigMedian','SigMAD','SigStdev','BoutStarts','BoutDuration','LicksPerBout','LickFrequency','MinBefore', 'MeanBefore', 'PeakBefore', 'Onset', 'End', 'MinDuring', 'MeanDuring','PeakDuring', 'MinAfter', 'MeanAfter', 'PeakAfter', 'SlopePolyfit', 'SlopeTwoPoint','RAMP60to50sec', 'RAMP50to40sec', 'RAMP40to30sec', 'RAMP30to20sec', 'RAMP20to10sec', 'RAMP10to0sec', 'AUC15Before',	'AUC15After','TIMEDIFFBefore', 'TIMEDIFFAfter','x_OfC'};

SHEETONE=[];

for k = 1:length(matFiles)
    baseFileName = matFiles(k).name;
    fullFileName = fullfile(DATALOCATION, baseFileName);
    
    if endsWith(baseFileName, 'A.xlsx')
        ABoutData=readtable(fullFileName,'Sheet',1);
        if any(cellfun(@isnumeric,table2cell(ABoutData(:,'x_OfC')))==0)
        ABoutData.x_OfC=str2double(ABoutData.x_OfC);
        end
    end
    if endsWith(baseFileName, 'B.xlsx')
        BBoutData=readtable(fullFileName,'Sheet',1);
        if any(cellfun(@isnumeric,table2cell(BBoutData(:,'x_OfC')))==0)
        BBoutData.x_OfC=str2double(BBoutData.x_OfC);
        end
    end
    

    if exist('ABoutData')==1
    FileName = erase(baseFileName,'resultsA.xlsx');
    ChannelA=table({FileName}, {'A'}, 'VariableNames', {'FileName' 'Channel'});
    
    [nbout m]=size(ABoutData);
        if m > 1
            ABoutData.Properties.VariableNames = cn;
            Mouse=cell2table(cell(nbout,1), 'VariableNames', {'Mouse'});
            Bout=table((1:nbout)', 'VariableNames', {'Bout'});
            sheet1=[repelem(ChannelA,[nbout],[1]), Mouse, Bout, ABoutData];
            SHEETONE=[SHEETONE; sheet1];  
        end
    %clear ChannelA MeanSlopeTableA ChannelAMeanPeakData AEventAverages sheet1
    clear nbout m ABoutData sheet1 MouseA BoutA
    end
    
    if exist('BBoutData')==1
    FileName = erase(baseFileName,'resultsB.xlsx');
    ChannelB=table({FileName}, {'B'}, 'VariableNames', {'FileName' 'Channel'});
    
    
    [nbout m]=size(BBoutData);
        if m > 1
            BBoutData.Properties.VariableNames = cn;
            Mouse=cell2table(cell(nbout,1), 'VariableNames', {'Mouse'});
            Bout=table((1:nbout)', 'VariableNames', {'Bout'});
            sheet1=[repelem(ChannelB,[nbout],[1]), Mouse, Bout, BBoutData];
            SHEETONE=[SHEETONE; sheet1];  
        end

    %clear ChannelB MeanSlopeTableB ChannelBMeanPeakData BEventAverages sheet1
    clear nbout m BBoutData sheet1 Mouse Bout
    end
        
end

writetable(SHEETONE, OUTPUTLOCATION, 'Sheet', 1)
