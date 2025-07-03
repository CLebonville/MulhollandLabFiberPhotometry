function  [n beforeMEAN beforeSE afterMEAN afterSE] = Plot30secBoutsCL(); 
%Creates a graph of the data ~30 sec before and ~30 after each drinking bout from
% all MATLAB files in the selected folders. If you want to plot two or more
% data sets on the same graph, data must be saved in different folders.

% To create a graph:

% STEP 1 ---> Comment out any plots you don't want! 

% STEP 2 ---> Edit the legend at the end of the code to match.
% 
% STEP 3 ---> Change each colorcode variable in each section to be the
% color that you want for that line. 
% 
% colorcode = [1,0,0];
% for red, or

% colorcode = [0.83,0.07,0.35] <-CL uses for EtOH
% for vibrant pink, or

% colorcode = [0,0,0];
% for black/gray, or

% colorcode = [0,.2, 1];
% for basic blue.

% colorcode = [0.10,0.52,1.00]; <- CL uses for Water
% for lighter dark blue.

% colorcode = [0.6,0, 1];
% for light purple.

% colorcode = [0.32,0.15,0.63]; <-CL uses for Sucrose
% for dark purple.

% colorcode = [0,0.5,0.5];
% for forest green

% colorcode = [0.875,1,0];
% for yellow/chartreuse

% color codes: https://www.cimat.mx/~max/InformaticaAplicadaII_2018/bibliografia/MATLAB_reference.html

% STEP 4 ---> Run code! When prompted, select the corresponding folders containing the graph MATLAB files in THE ORDER PROMPTED: 
% Ex: 1. Ethanol, 2. Water, 3. Sucrose. 
% Enjoy. Marvel.

%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% for %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% ETHANOL %%%%%%%%%%%%%%%%%%%%%%%%%%

colorcode = [0.83,0.07,0.35];
"Select Folder for: Ethanol"
folder = uigetdir()
MATList = dir(fullfile(folder, '*.mat'));

%Create the matrices to store the results
BEFOREDATA=[];
AFTERDATA=[];

for i=1:length(MATList)
    load([MATList(i).folder '/' MATList(i).name])
    GraphBefore=table2array(GraphBefore);
    GraphAfter=table2array(GraphAfter);
    BEFOREDATA=[BEFOREDATA GraphBefore];
    AFTERDATA=[AFTERDATA GraphAfter];
end

[m,n]=size(BEFOREDATA);
[mB,nB]=size(BEFOREDATA);
nB=nB-sum(isnan(BEFOREDATA'));
beforeMEAN=nanmean(BEFOREDATA');
beforeSD=nanstd(BEFOREDATA');
beforeSE=beforeSD./sqrt(nB);

[mA,nA]=size(AFTERDATA);
nA=nA-sum(isnan(AFTERDATA'));
afterMEAN=nanmean(AFTERDATA');
afterSD=nanstd(AFTERDATA');
afterSE=afterSD./sqrt(nA);

Time1 = linspace(1/1017.253, mB/1017.252625, mB);
figure;
% Use this to plot a solid line for the mean:
plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5);

% Use this instead for a dotted line for the mean:
%plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5, 'LineStyle', ':');

ylabel('\bf\Delta\itF/F (%)', 'FontSize',14);
xlabel('\bfTime(seconds) ', 'FontSize',14);
hold on
plot(Time1,[beforeMEAN - beforeSE; beforeMEAN + beforeSE], 'LineStyle', 'none');
fill( [Time1 fliplr(Time1)],  [beforeMEAN + beforeSE fliplr(beforeMEAN - beforeSE)], colorcode, 'EdgeColor', 'none');
alpha(.25);
hold on

%Adds space between the before & after data
%tt indicates where on the x axis the after data will start
%tt=max(Time)+10;
tt=35;

Time2 = linspace(1/1017.253, mA/1017.253, mA)+tt;

% Use this to plot a solid line for the mean:
ethanol=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5,'DisplayName','Ethanol');


% Use this instead for a dotted line for the mean:
%plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5, 'LineStyle', ':');

ylabel('\bf\Delta\itF/F (%)', 'FontSize',14);
xlabel('\bfTime(seconds) ', 'FontSize',14);
hold on
% plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], '-', 'Color', colorcode);
plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], 'LineStyle','none');
fill( [Time2 fliplr(Time2)],  [afterMEAN + afterSE fliplr(afterMEAN - afterSE)], colorcode, 'EdgeColor','none');
alpha(.25);

xlim([min(Time1) max(Time2)])
hold on 

%Change the labels of the x axis
names = {'-30'; '-20'; '-10'; '0'; '0'; '10'; '20'; '30'};
set(gca,'xtick',[max(Time1)-32.4 max(Time1)-22.4 max(Time1)-12.4 max(Time1)-2.4 min(Time2)+2.4 min(Time2)+12.4 min(Time2)+22.4 min(Time2)+32.4],'xticklabel',names)
title('Average \bf\Delta\itF/F(%) Before & After Bouts');

% %%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%% for %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%% QUININE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% hold on
% 
% colorcode = [0,0,0];
% "Select Folder for: Quinine High"
% folder = uigetdir()
% MATList = dir(fullfile(folder, '*.mat'));
% 
% %Create the matrices to store the results
% BEFOREDATA=[];
% AFTERDATA=[];
% 
% for i=1:length(MATList)
%     load([MATList(i).folder '/' MATList(i).name])
%     GraphBefore=table2array(GraphBefore);
%     GraphAfter=table2array(GraphAfter);
%     BEFOREDATA=[BEFOREDATA GraphBefore];
%     AFTERDATA=[AFTERDATA GraphAfter];
% end
% 
% [m,n]=size(BEFOREDATA);
% [mB,nB]=size(BEFOREDATA);
% nB=nB-sum(isnan(BEFOREDATA'));
% beforeMEAN=nanmean(BEFOREDATA');
% beforeSD=nanstd(BEFOREDATA');
% beforeSE=beforeSD./sqrt(nB);
% 
% [mA,nA]=size(AFTERDATA);
% nA=nA-sum(isnan(AFTERDATA'));
% afterMEAN=nanmean(AFTERDATA');
% afterSD=nanstd(AFTERDATA');
% afterSE=afterSD./sqrt(nA);
% 
% Time1 = linspace(1/1017.253, mB/1017.252625, mB);
% 
% 
% %% Use this to plot a solid line for the mean:
% plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5);
% 
% % %%Use this instead for a dotted line for the mean:
% % plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5, 'LineStyle', ':');
% 
% ylabel('\bf\Delta\itF/F (%)', 'FontSize',14);
% xlabel('\bfTime(seconds) ', 'FontSize',14);
% hold on
% plot(Time1,[beforeMEAN - beforeSE; beforeMEAN + beforeSE], 'LineStyle', 'none');
% fill( [Time1 fliplr(Time1)],  [beforeMEAN + beforeSE fliplr(beforeMEAN - beforeSE)], colorcode, 'EdgeColor', 'none');
% alpha(.25);
% hold on
% 
% %Adds space between the before & after data
% %tt indicates where on the x axis the after data will start
% %tt=max(Time)+10;
% tt=35;
% 
% Time2 = linspace(1/1017.253, mA/1017.253, mA)+tt;
% 
% % Use this to plot a solid line for the mean:
% quinine1=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5,'DisplayName','Quinine 0.125 uM');
% 
% 
% % % Use this instead for a dotted line for the mean:
% % quinine1=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5, 'LineStyle', ':','DisplayName','Quinine 0.125 uM');
% 
% ylabel('\bf\Delta\itF/F (%)', 'FontSize',14);
% xlabel('\bfTime(seconds) ', 'FontSize',14);
% hold on
% % plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], '-', 'Color', colorcode);
% plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], 'LineStyle','none');
% fill( [Time2 fliplr(Time2)],  [afterMEAN + afterSE fliplr(afterMEAN - afterSE)], colorcode, 'EdgeColor','none');
% alpha(.25);
% 
% xlim([min(Time1) max(Time2)])
% 
% % %Change the labels of the x axis
% % names = {'-30'; '-20'; '-10'; '0'; '0'; '10'; '20'; '30'};
% % set(gca,'xtick',[max(Time1)-32.4 max(Time1)-22.4 max(Time1)-12.4 max(Time1)-2.4 min(Time2)+2.4 min(Time2)+12.4 min(Time2)+22.4 min(Time2)+32.4],'xticklabel',names)
% % title('Average \bf\Delta\itF/F(%) Before & After Bouts');
%  
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%% for %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%% QUININE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% hold on
% 
% colorcode = [0,0,0];
% "Select Folder for: Quinine Low"
% folder = uigetdir()
% MATList = dir(fullfile(folder, '*.mat'));
% 
% %Create the matrices to store the results
% BEFOREDATA=[];
% AFTERDATA=[];
% 
% for i=1:length(MATList)
%     load([MATList(i).folder '/' MATList(i).name])
%     GraphBefore=table2array(GraphBefore);
%     GraphAfter=table2array(GraphAfter);
%     BEFOREDATA=[BEFOREDATA GraphBefore];
%     AFTERDATA=[AFTERDATA GraphAfter];
% end
% 
% [m,n]=size(BEFOREDATA);
% [mB,nB]=size(BEFOREDATA);
% nB=nB-sum(isnan(BEFOREDATA'));
% beforeMEAN=nanmean(BEFOREDATA');
% beforeSD=nanstd(BEFOREDATA');
% beforeSE=beforeSD./sqrt(nB);
% 
% [mA,nA]=size(AFTERDATA);
% nA=nA-sum(isnan(AFTERDATA'));
% afterMEAN=nanmean(AFTERDATA');
% afterSD=nanstd(AFTERDATA');
% afterSE=afterSD./sqrt(nA);
% 
% Time1 = linspace(1/1017.253, mB/1017.252625, mB);
% 
% 
% % %% Use this to plot a solid line for the mean:
% % plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5);
% 
% %%Use this instead for a dotted line for the mean:
% plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5, 'LineStyle', ':');
% 
% ylabel('\bf\Delta\itF/F (%)', 'FontSize',14);
% xlabel('\bfTime(seconds) ', 'FontSize',14);
% hold on
% plot(Time1,[beforeMEAN - beforeSE; beforeMEAN + beforeSE], 'LineStyle', 'none');
% fill( [Time1 fliplr(Time1)],  [beforeMEAN + beforeSE fliplr(beforeMEAN - beforeSE)], colorcode, 'EdgeColor', 'none');
% alpha(.25);
% hold on
% 
% %Adds space between the before & after data
% %tt indicates where on the x axis the after data will start
% %tt=max(Time)+10;
% tt=35;
% 
% Time2 = linspace(1/1017.253, mA/1017.253, mA)+tt;
% 
% % % Use this to plot a solid line for the mean:
% % quinine2=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5,'DisplayName','Quinine 0.09 uM');
% 
% 
% % Use this instead for a dotted line for the mean:
% quinine2=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5, 'LineStyle', ':','DisplayName','Quinine 0.09 uM');
% 
% ylabel('\bf\Delta\itF/F (%)', 'FontSize',14);
% xlabel('\bfTime(seconds) ', 'FontSize',14);
% hold on
% % plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], '-', 'Color', colorcode);
% plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], 'LineStyle','none');
% fill( [Time2 fliplr(Time2)],  [afterMEAN + afterSE fliplr(afterMEAN - afterSE)], colorcode, 'EdgeColor','none');
% alpha(.25);
% 
% xlim([min(Time1) max(Time2)])
% 
% % %Change the labels of the x axis
% % names = {'-30'; '-20'; '-10'; '0'; '0'; '10'; '20'; '30'};
% % set(gca,'xtick',[max(Time1)-32.4 max(Time1)-22.4 max(Time1)-12.4 max(Time1)-2.4 min(Time2)+2.4 min(Time2)+12.4 min(Time2)+22.4 min(Time2)+32.4],'xticklabel',names)
% % title('Average \bf\Delta\itF/F(%) Before & After Bouts');
%  

%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% for %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% WATER %%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on

colorcode = [0.10,0.52,1.00];
"Select Folder for: Water"
folder = uigetdir()
MATList = dir(fullfile(folder, '*.mat'));

%Create the matrices to store the results
BEFOREDATA=[];
AFTERDATA=[];

for i=1:length(MATList)
    load([MATList(i).folder '/' MATList(i).name])
    GraphBefore=table2array(GraphBefore);
    GraphAfter=table2array(GraphAfter);
    BEFOREDATA=[BEFOREDATA GraphBefore];
    AFTERDATA=[AFTERDATA GraphAfter];
end

[m,n]=size(BEFOREDATA);
[mB,nB]=size(BEFOREDATA);
nB=nB-sum(isnan(BEFOREDATA'));
beforeMEAN=nanmean(BEFOREDATA');
beforeSD=nanstd(BEFOREDATA');
beforeSE=beforeSD./sqrt(nB);

[mA,nA]=size(AFTERDATA);
nA=nA-sum(isnan(AFTERDATA'));
afterMEAN=nanmean(AFTERDATA');
afterSD=nanstd(AFTERDATA');
afterSE=afterSD./sqrt(nA);

Time1 = linspace(1/1017.253, mB/1017.252625, mB);
% Use this to plot a solid line for the mean:
plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5);

%% Use this in replace of line 60-61 for a dotted line for the mean:
%plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5, 'LineStyle', ':');

hold on
plot(Time1,[beforeMEAN - beforeSE; beforeMEAN + beforeSE], 'LineStyle', 'none');
fill( [Time1 fliplr(Time1)],  [beforeMEAN + beforeSE fliplr(beforeMEAN - beforeSE)], colorcode, 'EdgeColor', 'none');
alpha(.25);
hold on

%Adds space between the before & after data
%tt indicates where on the x axis the after data will start
%tt=max(Time)+10;
tt=35;

Time2 = linspace(1/1017.253, mA/1017.253, mA)+tt;

% Use this to plot a solid line for the mean:
water=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5, 'DisplayName','Water');

% Use this instead for a dotted line for the mean:
%plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5, 'LineStyle', ':', 'DisplayName','Water');

hold on
% plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], '-', 'Color', colorcode);
plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], 'LineStyle','none');
fill( [Time2 fliplr(Time2)],  [afterMEAN + afterSE fliplr(afterMEAN - afterSE)], colorcode, 'EdgeColor','none');
alpha(.25);

xlim([min(Time1) max(Time2)])

% %%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%% for %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% WATER + DEPRIVATION %%%%%%%%%%%%%%%%%%%%
% hold on
% 
% colorcode = [0,.2,1];
% "Select Folder for: Water Dep"
% folder = uigetdir()
% MATList = dir(fullfile(folder, '*.mat'));
% 
% %Create the matrices to store the results
% BEFOREDATA=[];
% AFTERDATA=[];
% 
% for i=1:length(MATList)
%     load([MATList(i).folder '/' MATList(i).name])
%     GraphBefore=table2array(GraphBefore);
%     GraphAfter=table2array(GraphAfter);
%     BEFOREDATA=[BEFOREDATA GraphBefore];
%     AFTERDATA=[AFTERDATA GraphAfter];
% end
% 
% [m,n]=size(BEFOREDATA);
% [mB,nB]=size(BEFOREDATA);
% nB=nB-sum(isnan(BEFOREDATA'));
% beforeMEAN=nanmean(BEFOREDATA');
% beforeSD=nanstd(BEFOREDATA');
% beforeSE=beforeSD./sqrt(nB);
% 
% [mA,nA]=size(AFTERDATA);
% nA=nA-sum(isnan(AFTERDATA'));
% afterMEAN=nanmean(AFTERDATA');
% afterSD=nanstd(AFTERDATA');
% afterSE=afterSD./sqrt(nA);
% 
% Time1 = linspace(1/1017.253, mB/1017.252625, mB);
% 
% % % Use this to plot a solid line for the mean:
% %plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5);
% 
% %Use this instead for a dotted line for the mean:
% plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5, 'LineStyle', ':');
% 
% ylabel('\bf\Delta\itF/F (%)', 'FontSize',14);
% xlabel('\bfTime(seconds) ', 'FontSize',14);
% hold on
% plot(Time1,[beforeMEAN - beforeSE; beforeMEAN + beforeSE], 'LineStyle', 'none');
% fill( [Time1 fliplr(Time1)],  [beforeMEAN + beforeSE fliplr(beforeMEAN - beforeSE)], colorcode, 'EdgeColor', 'none');
% alpha(.25);
% hold on
% 
% %Adds space between the before & after data
% %tt indicates where on the x axis the after data will start
% %tt=max(Time)+10;
% tt=35;
% 
% Time2 = linspace(1/1017.253, mA/1017.253, mA)+tt;
% 
% % Use this to plot a solid line for the mean:
% %water.dep=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5,'DisplayName','Water + Deprivation');
% 
% % Use this instead for a dotted line for the mean:
% water_dep=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5, 'LineStyle', ':','DisplayName','Water + Deprivation');
% 
% ylabel('\bf\Delta\itF/F (%)', 'FontSize',14);
% xlabel('\bfTime(seconds) ', 'FontSize',14);
% hold on
% % plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], '-', 'Color', colorcode);
% plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], 'LineStyle','none');
% fill( [Time2 fliplr(Time2)],  [afterMEAN + afterSE fliplr(afterMEAN - afterSE)], colorcode, 'EdgeColor','none');
% alpha(.25);
% 
% xlim([min(Time1) max(Time2)])



%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% for %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% SUCROSE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on

colorcode = [0.32,0.15,0.63];
"Select Folder for: Sucrose"
folder = uigetdir()
MATList = dir(fullfile(folder, '*.mat'));

%Create the matrices to store the results
BEFOREDATA=[];
AFTERDATA=[];

for i=1:length(MATList)
    load([MATList(i).folder '/' MATList(i).name])
    GraphBefore=table2array(GraphBefore);
    GraphAfter=table2array(GraphAfter);
    BEFOREDATA=[BEFOREDATA GraphBefore];
    AFTERDATA=[AFTERDATA GraphAfter];
end

[m,n]=size(BEFOREDATA);
[mB,nB]=size(BEFOREDATA);
nB=nB-sum(isnan(BEFOREDATA'));
beforeMEAN=nanmean(BEFOREDATA');
beforeSD=nanstd(BEFOREDATA');
beforeSE=beforeSD./sqrt(nB);

[mA,nA]=size(AFTERDATA);
nA=nA-sum(isnan(AFTERDATA'));
afterMEAN=nanmean(AFTERDATA');
afterSD=nanstd(AFTERDATA');
afterSE=afterSD./sqrt(nA);

Time1 = linspace(1/1017.253, mB/1017.252625, mB);
% Use this to plot a solid line for the mean:
plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5);

% Use this instead for a dotted line for the mean:
%plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5, 'LineStyle', ':');

hold on
plot(Time1,[beforeMEAN - beforeSE; beforeMEAN + beforeSE], 'LineStyle', 'none');
fill( [Time1 fliplr(Time1)],  [beforeMEAN + beforeSE fliplr(beforeMEAN - beforeSE)], colorcode, 'EdgeColor', 'none');
alpha(.25);
hold on

%Adds space between the before & after data
%tt indicates where on the x axis the after data will start
%tt=max(Time)+10;
tt=35;

Time2 = linspace(1/1017.253, mA/1017.253, mA)+tt;

% Use this to plot a solid line for the mean:
sucrose1=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5,'DisplayName','Sucrose');

% Use this instead for a dotted line for the mean:
%sucrose1=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5, 'LineStyle', ':','DisplayName','Sucrose');

hold on
% plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], '-', 'Color', colorcode);
plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], 'LineStyle','none');
fill( [Time2 fliplr(Time2)],  [afterMEAN + afterSE fliplr(afterMEAN - afterSE)], colorcode, 'EdgeColor','none');
alpha(.25);

xlim([min(Time1) max(Time2)])

%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% for %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% SUCROSE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hold on
% 
% colorcode = [0.6,0, 1];
% "Select Folder for: Sucrose + Low Quinine"
% folder = uigetdir()
% MATList = dir(fullfile(folder, '*.mat'));
% 
% %Create the matrices to store the results
% BEFOREDATA=[];
% AFTERDATA=[];
% 
% for i=1:length(MATList)
%     load([MATList(i).folder '/' MATList(i).name])
%     GraphBefore=table2array(GraphBefore);
%     GraphAfter=table2array(GraphAfter);
%     BEFOREDATA=[BEFOREDATA GraphBefore];
%     AFTERDATA=[AFTERDATA GraphAfter];
% end
% 
% [m,n]=size(BEFOREDATA);
% [mB,nB]=size(BEFOREDATA);
% nB=nB-sum(isnan(BEFOREDATA'));
% beforeMEAN=nanmean(BEFOREDATA');
% beforeSD=nanstd(BEFOREDATA');
% beforeSE=beforeSD./sqrt(nB);
% 
% [mA,nA]=size(AFTERDATA);
% nA=nA-sum(isnan(AFTERDATA'));
% afterMEAN=nanmean(AFTERDATA');
% afterSD=nanstd(AFTERDATA');
% afterSE=afterSD./sqrt(nA);
% 
% Time1 = linspace(1/1017.253, mB/1017.252625, mB);
% % % Use this to plot a solid line for the mean:
% % plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5);
% 
% %Use this instead for a dotted line for the mean:
% plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5, 'LineStyle', ':');
% 
% hold on
% plot(Time1,[beforeMEAN - beforeSE; beforeMEAN + beforeSE], 'LineStyle', 'none');
% fill( [Time1 fliplr(Time1)],  [beforeMEAN + beforeSE fliplr(beforeMEAN - beforeSE)], colorcode, 'EdgeColor', 'none');
% alpha(.25);
% hold on
% 
% %Adds space between the before & after data
% %tt indicates where on the x axis the after data will start
% %tt=max(Time)+10;
% tt=35;
% 
% Time2 = linspace(1/1017.253, mA/1017.253, mA)+tt;
% 
% % % Use this to plot a solid line for the mean:
% % sucrose2=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5,'DisplayName','Sucrose + 0.09 uM QHCl');
% 
% %Use this instead for a dotted line for the mean:
% sucrose2=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5, 'LineStyle', ':','DisplayName','Sucrose + 0.09 uM QHCl');
% 
% hold on
% % plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], '-', 'Color', colorcode);
% plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], 'LineStyle','none');
% fill( [Time2 fliplr(Time2)],  [afterMEAN + afterSE fliplr(afterMEAN - afterSE)], colorcode, 'EdgeColor','none');
% alpha(.25);
% 
% xlim([min(Time1) max(Time2)])
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%% for %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%% Saccharin %%%%%%%%%%%%%%%%%%%%%%%%
% hold on
% 
% colorcode = [0,0.5, 0.5];
% "Select Folder for: Saccharin"
% folder = uigetdir()
% MATList = dir(fullfile(folder, '*.mat'));
% 
% %Create the matrices to store the results
% BEFOREDATA=[];
% AFTERDATA=[];
% 
% for i=1:length(MATList)
%     load([MATList(i).folder '/' MATList(i).name])
%     GraphBefore=table2array(GraphBefore);
%     GraphAfter=table2array(GraphAfter);
%     BEFOREDATA=[BEFOREDATA GraphBefore];
%     AFTERDATA=[AFTERDATA GraphAfter];
% end
% 
% [m,n]=size(BEFOREDATA);
% [mB,nB]=size(BEFOREDATA);
% nB=nB-sum(isnan(BEFOREDATA'));
% beforeMEAN=nanmean(BEFOREDATA');
% beforeSD=nanstd(BEFOREDATA');
% beforeSE=beforeSD./sqrt(nB);
% 
% [mA,nA]=size(AFTERDATA);
% nA=nA-sum(isnan(AFTERDATA'));
% afterMEAN=nanmean(AFTERDATA');
% afterSD=nanstd(AFTERDATA');
% afterSE=afterSD./sqrt(nA);
% 
% Time1 = linspace(1/1017.253, mB/1017.252625, mB);
% % Use this to plot a solid line for the mean:
% plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5);
% 
% %% Use this in replace of line 60-61 for a dotted line for the mean:
% %plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5, 'LineStyle', ':');
% 
% hold on
% plot(Time1,[beforeMEAN - beforeSE; beforeMEAN + beforeSE], 'LineStyle', 'none');
% fill( [Time1 fliplr(Time1)],  [beforeMEAN + beforeSE fliplr(beforeMEAN - beforeSE)], colorcode, 'EdgeColor', 'none');
% alpha(.25);
% hold on
% 
% %Adds space between the before & after data
% %tt indicates where on the x axis the after data will start
% %tt=max(Time)+10;
% tt=35;
% 
% Time2 = linspace(1/1017.253, mA/1017.253, mA)+tt;
% 
% % Use this to plot a solid line for the mean:
% sacc=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5, 'DisplayName','Saccharin');
% 
% % Use this instead for a dotted line for the mean:
% %sacc=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5, 'LineStyle', ':', 'DisplayName','Sacc');
% 
% hold on
% % plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], '-', 'Color', colorcode);
% plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], 'LineStyle','none');
% fill( [Time2 fliplr(Time2)],  [afterMEAN + afterSE fliplr(afterMEAN - afterSE)], colorcode, 'EdgeColor','none');
% alpha(.25);
% 
% xlim([min(Time1) max(Time2)])
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%% for %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%% Citric Acid %%%%%%%%%%%%%%%%%%%%%%%%
% hold on
% 
% colorcode = [1.0,1.0, 0];
% "Select Folder for: Citric Acid"
% folder = uigetdir()
% MATList = dir(fullfile(folder, '*.mat'));
% 
% %Create the matrices to store the results
% BEFOREDATA=[];
% AFTERDATA=[];
% 
% for i=1:length(MATList)
%     load([MATList(i).folder '/' MATList(i).name])
%     GraphBefore=table2array(GraphBefore);
%     GraphAfter=table2array(GraphAfter);
%     BEFOREDATA=[BEFOREDATA GraphBefore];
%     AFTERDATA=[AFTERDATA GraphAfter];
% end
% 
% [m,n]=size(BEFOREDATA);
% [mB,nB]=size(BEFOREDATA);
% nB=nB-sum(isnan(BEFOREDATA'));
% beforeMEAN=nanmean(BEFOREDATA');
% beforeSD=nanstd(BEFOREDATA');
% beforeSE=beforeSD./sqrt(nB);
% 
% [mA,nA]=size(AFTERDATA);
% nA=nA-sum(isnan(AFTERDATA'));
% afterMEAN=nanmean(AFTERDATA');
% afterSD=nanstd(AFTERDATA');
% afterSE=afterSD./sqrt(nA);
% 
% Time1 = linspace(1/1017.253, mB/1017.252625, mB);
% % Use this to plot a solid line for the mean:
% plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5);
% 
% %% Use this in replace of line 60-61 for a dotted line for the mean:
% %plot(Time1, beforeMEAN, '-', 'Color', colorcode, 'LineWidth', 2.5, 'LineStyle', ':');
% 
% hold on
% plot(Time1,[beforeMEAN - beforeSE; beforeMEAN + beforeSE], 'LineStyle', 'none');
% fill( [Time1 fliplr(Time1)],  [beforeMEAN + beforeSE fliplr(beforeMEAN - beforeSE)], colorcode, 'EdgeColor', 'none');
% alpha(.25);
% hold on
% 
% %Adds space between the before & after data
% %tt indicates where on the x axis the after data will start
% %tt=max(Time)+10;
% tt=35;
% 
% Time2 = linspace(1/1017.253, mA/1017.253, mA)+tt;
% 
% % Use this to plot a solid line for the mean:
% citric=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5, 'DisplayName','Citric Acid');
% 
% % Use this instead for a dotted line for the mean:
% %citric=plot(Time2, afterMEAN, '-', 'Color',colorcode, 'LineWidth', 2.5, 'LineStyle', ':', 'DisplayName','Sacc');
% 
% hold on
% % plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], '-', 'Color', colorcode);
% plot(Time2,[afterMEAN - afterSE; afterMEAN + afterSE], 'LineStyle','none');
% fill( [Time2 fliplr(Time2)],  [afterMEAN + afterSE fliplr(afterMEAN - afterSE)], colorcode, 'EdgeColor','none');
% alpha(.25);
% 
% xlim([min(Time1) max(Time2)])

%%%% LEGEND %%%% 
%%Take out any that you aren't plotting
%% All Options: ethanol,water, water.dep, sucrose1, sucrose2, quinine1, quinine2, sacc, citric
legend([ethanol,water,sucrose1]);

beep