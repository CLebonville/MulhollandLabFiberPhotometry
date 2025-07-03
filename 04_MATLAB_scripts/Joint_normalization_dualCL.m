function [yA,yB,Time,dF_FA,dF_FB, TimeFromStart, TimeFromEnd, MeanSlopeTableA, MeanSlopeTableB] = Joint_normalization_dualCL(data);

% MATLAB functions vs R functions: http://mathesaurus.sourceforge.net/octave-r.html
% PREREQUISITES: Need MATLAB function "RunRcode.m" (from https://www.mathworks.com/matlabcentral/fileexchange/50071-runrcode-rscriptfilename-rpath) and
% "Joint.R" R-file in working directory
%-----------------------------------COMMON VARIABLES--------------------------------------------------
%-----------------------------------------------------------------------------------------------------
data.streams.TTLA.data=data.streams.TTLa.data; %%Comment in and out as needed for different stream labels on blue/black rigs.
data.streams.TTLB.data=data.streams.TTLb.data; %%Comment in and out as needed for different stream labels on blue/black rigs.
warning('off','all'); 
Frequency = 1017.25262451172;
TimeFromStart = 15.0;% if you need to cut off any time (in seconds) from the beginning, change it here. Default is 15 sec.
TimeFromEnd = 15.0;%if you need to cut off any time from the end, change it here. Default is 15 sec.
Stop = length(data.streams.a05A.data)-TimeFromEnd*Frequency; 
Start = TimeFromStart*Frequency; 
yA = double(data.streams.TTLA.data(round(Start):round(Stop)));
yB = double(data.streams.TTLB.data(round(Start):round(Stop)));
Time = linspace(1/Frequency, length(yB)/Frequency, length(yB)); %Takes the trimmed data and makes a timeline to match beginning at 1 sec to the end length of the trimmed data in 1 sec/freq units (so NOT time of video or session but time within the trimmed data!!) 

%-----------------------------------CHANNEL A---------------------------------------------------------
%-----------------------------------------------------------------------------------------------------
% REMOVE SLOPE USING POLYFIT

calciumA = data.streams.a70A.data(round(Start):round(Stop));
noiseA = data.streams.a05A.data(round(Start):round(Stop));
CaPolyA = polyfit(Time, calciumA, 1);
f0A = CaPolyA(1)*Time + CaPolyA(2);
CaA_df_f0 = (calciumA - f0A)./f0A * 100;
RefPolyA = polyfit(Time, noiseA, 1);
f01A = RefPolyA(1)*Time + RefPolyA(2);
RefA_df_f0 = (noiseA - f01A)./f01A * 100;

yA=yA-mode(yA); %shifts TTLs to a '0' for baseline
yA=(abs(yA))*8; %makes the TTLs always in the positive direction

% CHRIS JOINT
% save('to_rA','noiseA','calciumA')
% RunRcode('H:/CL8_PJM/CL8_Joint_PJM/Joint.R');
% load('JOINT_A.mat')
% 
% Chris_RefA = (noiseA - JointOut')./JointOut' * 100;
% dF_FA = CaA_df_f0 - Chris_RefA;


%-----------------------------------CHANNEL B---------------------------------------------------------
%-----------------------------------------------------------------------------------------------------
%For %deltaF/F: normalize the signal and plot 
warning('off','all');  
calciumB = data.streams.b70B.data(round(Start):round(Stop));
noiseB = data.streams.b05B.data(round(Start):round(Stop));
CaPolyB = polyfit(Time, calciumB, 1);
f0B = CaPolyB(1)*Time + CaPolyB(2);
CaB_df_f0 = (calciumB - f0B)./f0B * 100;
RefPolyB = polyfit(Time, noiseB, 1);
f01B = RefPolyB(1)*Time + RefPolyB(2);
RefB_df_f0 = (noiseB - f01B)./f01B * 100;

yB=yB-mode(yB); %shifts TTLs to a '0' baseline
yB=(abs(yB))*8;

%------------------------------------ CHRIS JOINT ------------------------------------

save('to_rA','noiseA','calciumA')
save('to_rB','noiseB','calciumB')

%Enter path to the R script "Joint.R"
rscript='Z:\Christina Lebonville\2020.06.16 (CL8 or DRK-MK) CeA Dyn Fiber Recording in DID\Scripts and Functions Used R MATLAB PYTHON\Joint.R';
%rscript = 'H:\CL8_PJM\Joint.R'
%Enter the path to your R.exe (just the path, not the filename)
%Rpath='C:\R\R-4.3.1\bin'; %CL Dell Laptop
Rpath='C:\R\R-4.2.3\bin'; %Golgi
%NOTE: In the R script "Joint.R" you also need to edit the working
%directory to be the path above minus the R script filename (but note R uses forward slashes "/" in
%paths).
RunRcode(rscript,Rpath);


load('JOINT_A.mat')

Chris_RefA = (noiseA - JointOut')./JointOut' * 100;
dF_FA = CaA_df_f0 - Chris_RefA;

load('JOINT_B.mat')
Chris_RefB = (noiseB - JointOutB')./JointOutB' * 100;
dF_FB = CaB_df_f0 - Chris_RefB;


delete 'JOINT_A.mat' 'to_rA.mat' 'JOINT_B.mat' 'to_rB.mat'


clear Chris_RefA Chris_RefB

%---------------------------------MEAN AND SLOPE OF 405 AND 470--------------------------------------
%---------------------------------OUTPUT TO EXCEL----------------------------------------------------
Mean405A = mean(noiseA);
Mean470A = mean(calciumA);
Mean405B = mean(noiseB);
Mean470B = mean(calciumB);

MeanSlopeTableA = [Mean405A, Mean470A, CaPolyA, RefPolyA];
MeanSlopeTableA = array2table(MeanSlopeTableA);
MeanSlopeTableA.Properties.VariableNames = {'ChannelAMean405' 'ChannelAMean470' 'ChannelASlope470' 'Start470' 'ChannelASlope405' 'Start405'};

MeanSlopeTableB = [Mean405B, Mean470B, CaPolyB, RefPolyB];
MeanSlopeTableB = array2table(MeanSlopeTableB);
MeanSlopeTableB.Properties.VariableNames = {'ChannelBMean405' 'ChannelBMean470' 'ChannelBSlope470' 'Start470' 'ChannelBSlope405' 'Start405'};

% writetable([MeanSlopeTableA MeanSlopeTableB],'E:\JR25\PreCIE Results\m4 wk2\ChannelsA_B_Slope_405_470_Table.xlsx');
% end
