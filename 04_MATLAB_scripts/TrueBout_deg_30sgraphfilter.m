% Use this code to alter the original graphdata.mat files based on updated
% EXCEL workbooks produced by the DeepEthogram TrueBout pipeline. 
% This script will read in each original graphdata.mat file in a folder,
% find the corresponding updated workbook, and filter the bouts based
% on a defined threshold of % consumatory.
% Written by Michaela Hoffman Aug 14th, 2023
% Updated by Christina Lebonville Aug 14th, 2023 to make it semi-dummy
% proof and to add specific functionality.

%%% STEP ONE ---->>>  To make referencing easier, put the common path
%%% between all of the folders for the variable "RootDir" on LINE 28.
%%% With all updated EXCEL files in a single folder,specify the path of 
%%% this folder on LINE 29 for directory. Make sure that it ends with a \.

%%% STEP TWO ---->>> With all updated MATLAB files in a single folder,
%%% specify the path of this folder on LINE 30 for directory. Make sure
%%% that it ends with a \. 

%%% STEP THREE ---->>> Enter path of folder where output should be created
%%% on LINE 31 for the variable "OutDir".

%%% STEP FOUR ---->>> Set the desired threshold on LINE 33 for the
%%% variable "thresh"

%%% STEP FIVE ---->>> Click "Run"

% Set directories for location of EXCEL and MATLAB files, respectively.
RootDir = "Z:\Christina Lebonville\2020.06.16 (CL8 or DRK-MK) CeA Dyn Fiber Recording in DID\Fiber Photometry Data\";
WkbkDir = "DeepEthogram_TrueBout_Analysis_FinalData\CL8 TrueBout DEG Updated Workbooks\";
GraphDir = "DeepEthogram_TrueBout_Analysis_FinalData\CL8 Unfiltered Graph Data\";
OutDir = "DeepEthogram_TrueBout_Analysis_FinalData\CL8 TrueBout DEG Updated graphdata\";

%Set threshold for what is considered a real bout.
thresh=0.5;

%One by one, read in one of the graphdata files in a folder.
MatFiles=dir(fullfile(RootDir,GraphDir,'*.mat')); 


for i=1:size(MatFiles,1)
    % Read in graphdata file
    load(fullfile(RootDir,GraphDir,MatFiles(i).name))
      
    % Define the matching Excel file based on the graphdata filename.
    xlfile = strrep(MatFiles(i).name,'graphdata','results');
    xlfile = strrep(xlfile,'.mat','.xlsx');
   
    % Check if the matching ExcelFile exists in the location specified
   if isfile(fullfile(RootDir,WkbkDir,xlfile))
        warning('off')   
    
    % Load corresponding Excel file 
    xl = readtable(fullfile(RootDir,WkbkDir,xlfile), "UseExcel", false);
     warning('on','all')
    
    % If x_OfC contains any errors due to bouts not having prediction data,
    % this will turn them into "NA" and retain real values with double
    % precision like a normal file.
     if any(cellfun(@isnumeric,table2cell(xl(:,'x_OfC')))==0)
        xl.x_OfC=str2double(xl.x_OfC);
     end
        if sum(isnan(xl.x_OfC))==0
            [m1, n1]=size(xl);
            [m2, n2]=size(GraphBefore);
            if m1==n2
              % Filter the graphdata based on the Excel data so that you have only
              % graphdata where the corresponding x_OfC is above threshold.
              CUT=xl.x_OfC<thresh;
              %xl(CUT,:) = []; %% Lets you check the filtered bouts 
              GraphBefore(:,CUT) = [];
              GraphAfter(:,CUT) = [];
              name=MatFiles(i).name;
              name = strrep(name,'.mat','_deg.mat');
              save(fullfile(RootDir,OutDir, name),'GraphBefore', 'GraphAfter')
              %save([RootDir,OutDir,xlfile],'xl') % Use if you want to also export the
              %filtered Excel file.
            else 
            
                sprintf('Warning: different bout numbers in .mat and .xlsx files. Skipping:\n%s', MatFiles(i).name)
            end
        else
            [m1, n1]=size(xl);
            [m2, n2]=size(GraphBefore);
                if m1==n2
                    % Since this is the option where there are errors in
                    % the x_OfC variable that have been computed into N/As,
                    % we need to set NAs to below threshold, or 0, so they
                    % are removed.
                    for k= 1:length(xl.x_OfC)
                        if isnan(xl.x_OfC(k))==1
                            xl.x_OfC(k)=0;
                        end
                    end
                    % Filter the graphdata based on the Excel data so that you have only
                    % graphdata where the corresponding x_OfC is above threshold.
                    CUT=xl.x_OfC<thresh;
                    %xl(CUT,:) = []; %% Lets you check the filtered bouts 
                    GraphBefore(:,CUT) = [];
                    GraphAfter(:,CUT) = [];
                    name=MatFiles(i).name;
                    name = strrep(name,'.mat','_deg.mat');
                    save(fullfile(RootDir,OutDir, name),'GraphBefore', 'GraphAfter')
                    %save([RootDir,OutDir,xlfile],'x1') % Use if you want to also export the
                    %filtered Excel file.
                    sprintf('Warning: Filtering variable contains errors:\n%s', MatFiles(i).name)
                else 
                    sprintf('Warning: different bout numbers in .mat and .xlsx files. Skipping:\n%s', MatFiles(i).name)
                end
        end
    else
        sprintf('Warning: Matching Excel file does not exist. Skipping:\n%s', MatFiles(i).name)
    end

end