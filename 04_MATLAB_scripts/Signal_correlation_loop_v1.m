% Written by C. Lebonville
% Last update 6.23.2025
%
% PURPOSE: To read in a folder of fiber photometry data, run all the
% normalization methods tested in the CL8/CL20 manuscript (CeA Dyn Fiber in
% Drinking) and generate correlation matrices and plots for each, then average for a
% single experiment-wide correlation matrix and plot.
%
% To run the loop, you need to create TWO folders named "Correlation_Results" and "Correlation_Figures". 
% Put all of the files for analysis into a single folder. Then, paste the path to this folder
% on LINE 20. 
% 
% Unlike our other functions, you don't run the loop function by entering commands into the 
% command window. Rather, make sure the Loop function is in the forefront of the Editor and 
% click the big green "Run" arrow in the Editor tab near the top middle of the screen. The loop
% will save Excel files to the Results folder and figures to the Figures folder for each channel 
% in the dual channel recordings.

%Where the data files are located:
%directory = 'Z:\Christina Lebonville\2020.06.16 (CL8 or DRK-MK) CeA Dyn Fiber Recording in DID\Fiber Photometry Data\Cohort1_Recordings\';
directory = 'Z:\Christina Lebonville\2020.06.16 (CL8 or DRK-MK) CeA Dyn Fiber Recording in DID\Fiber Photometry Data\Cohort2_Recordings\';
Results = [directory,'..','\Correlation_Results\'];
Figures = [directory,'..','\Correlation_Figures\'];

% Results = [directory,'\Results\'];
% Figures = [directory,'\Figures\'];
% Licks = [directory,'\Lick Analysis\'];

files = dir(directory);

dirFlags = [files.isdir] & ~strcmp({files.name},'.') & ~strcmp({files.name},'..');
Folders = files(dirFlags);
clear files dirFlags

nFiles=length(Folders);

% Rolling index for sheet building
d=1;

% Initialize variables for storing results
CompiledCorrelations = table();

for i=1:nFiles
    Folders(i).name
    
    %Where the data files are located:
    FN1=[directory, Folders(i).name];
    
   	fprintf('<strong>Processing: %s %d/%d</strong>\nData ',Folders(i).name,i,nFiles)

    data=TDTbin2mat(FN1);
    
for c= ['A' 'B'] 
	fprintf('<strong>Channel: %s </strong>\n',c)

stream05 = strcat(lower(c),'05',c);
stream70 = strcat(lower(c),'70',c);
streamTTL = strcat('TTL',lower(c));
xls_name = strcat('results',c,'.xlsx');
fig_name = strcat('corrplot',c,'.jpg');


%Where you want the result excel files to go
FN2=[Results, Folders(i).name, xls_name];
FN3=[Results, 'Compiled_Correlations.xlsx'];
FN4=[Results, 'Mean_Correlations.xlsx'];

%Where you want the result figure files to go  
FN5=[Figures, Folders(i).name, fig_name];
FN6=[Figures, 'Mean_Correlation_Plot.jpg'];

[raw_405, raw_470, f0, f01, dt_470, dt_405, dF_F_405, Chris_Ref_J, JointOut, ...
        Fit_Ref_NNLS, dF_F_470, dF_F_DORIC, dF_F_NNLS, dF_F_JOINT, TimeFromStart,...
        TimeFromEnd, Time, TTL] = df_f_compare_motion(data, stream05, stream70, streamTTL);

%% Correlation matrix between different forms of each signal

signals = [raw_405; dt_405; dF_F_405; Fit_Ref_NNLS; Chris_Ref_J; raw_470; dt_470; ...
        dF_F_470; dF_F_DORIC; dF_F_NNLS; dF_F_JOINT];
var_names=["Filtered 405" "Detrended 405" "Self-norm 405" "Robust 405" "JCBM 405" "Filtered 470"...
        "Detrended 470" "Self-norm 470" "Standard 470" "Robust 470" "JCBM 470"];
        
clear raw_470 raw_405 dF_F_405 Fit_Ref_NNLS Chris_Ref_J dt_470 dt_405 dF_F_470 dF_F_JOINT dF_F_DORIC dF_F_NNLS
    %% Correlation table 
    [coeff, pval] = corrcoef(signals');
    writematrix(coeff, FN2,Sheet=1);
    writematrix(pval, FN2,Sheet=2);
    datout = reshape(coeff,1,[]);
    dattabout = array2table(datout);
    datcell = [{strcat(Folders(i).name,c)}, dattabout];
    CompiledCorrelations(d,:) =  datcell;
    d = d+1;
%% Correlation matrix plot (Option 1) - Great but takes up too much memory to be practical
   % [coeff, pval,h] = corrplot(signals',"Type","Pearson","TestR","on");
   
%% % % Correlation matrix plot (Option 2) - Not very customizable and takes a ton of memory too
    % % [S,AX,BigAx,H,HAx] = plotmatrix(signals',"-.k");
    % % title(BigAx,'Correlation Matrix of Signals')

    %% Correlation matrix plot (Option 3) - BEST! Low memory and looks good
    % labels
labels = var_names;
% scatter plot
n = size(coeff, 1);
y = triu(repmat(n+1, n, n) - (1:n)') + 0.5;
x = triu(repmat(1:n, n, 1)) + 0.5;
x(x == 0.5) = NaN;
scatter(x(:), y(:), 350.*abs(coeff(:)), coeff(:), 'filled')
% enclose markers in a grid
xl = [1:n+1;repmat(n+1, 1, n+1)];
xl = [xl(:, 1), xl(:, 1:end-1)];
yl = repmat(n+1:-1:1, 2, 1);
line(xl, yl, 'color', 'k') % horizontal lines
line(yl, xl, 'color', 'k') % vertical lines
% show labels
text((1:n)-0.5, (n:-1:1) + 0.5, labels, 'HorizontalAlignment', 'right','FontName',...
    'Arial','Color','k','FontWeight','bold',"FontSize",10)
pause(3);
text((1:n) + 0.5, repmat(n + 1, n, 1)+0.25, labels, ...
    'HorizontalAlignment', 'right', 'Rotation', 270, 'FontName','Arial','Color','k',"FontWeight","bold",...
    "FontSize",10)
h = gca;
h.Visible = 'off';
h.Position(4) = h.Position(4)*0.95;
axis(h, 'equal')
%% For Golgi or other older MATLAB versions
nebula = load("Nebula_Colormap.mat");
colormap(h,nebula.NebulaColormap)
%% For MATLAB 2025 onward
%colormap('nebula');

bar=colorbar(h,'Ticks',[-0.5,-0.25,0,0.25,0.5,0.75,1],'TickLabels',{-0.5,-0.25,0,0.25,0.5,0.75,1},'Location','east','AxisLocation','out');
%set(gcf, "Theme", "light");
bar.FontName = "Arial";
bar.FontSize = 10;
bar.Label.String = 'Pearson Correlation Coefficient';
bar.Label.Rotation = 270;
bar.Label.FontName = "Arial";
bar.Label.FontSize = 12;
bar.Label.FontWeight = "bold";
saveas(gca,FN5);
close(gcf);

%% If need to replot for any reason from handles...
% Number of signals (variables)
% n = size(signals, 1);

% % Create a new figure and layout
% figure;
% tiledlayout(n, n, 'Padding', 'compact', 'TileSpacing', 'compact');
% 
% % Loop over the subplot grid
% for row = 1:n
%     for col = 1:n
%         nexttile;  % Create the next subplot in the layout
% 
%         if row == col
%             % Diagonal: histogram
%             if isgraphics(H(col), 'line')
%                 xhist = get(H(col), 'XData');
%                 yhist = get(H(col), 'YData');
%                 plot(xhist, yhist, 'k');  % Use same line style
%                 title(['Hist of Var ', num2str(col)]);
%             end
%         else
%             % Off-diagonal: scatter plot
%             lineObj = S(row, col);
%             if isgraphics(lineObj, 'line')
%                 xdata = get(lineObj, 'XData');
%                 ydata = get(lineObj, 'YData');
%                 plot(xdata, ydata, 'o');
%                 xlabel(['Var ', num2str(col)]);
%                 ylabel(['Var ', num2str(row)]);
%             end
%         end
%     end
% end
% 
% % Optional: overall title
% sgtitle('Recreated plotmatrix');
   
 end
end
 
t = width(CompiledCorrelations);
g = height(CompiledCorrelations);
CompiledCorrelations_Means =  mean(CompiledCorrelations{:,(2:t)},[1]);
means = array2table(CompiledCorrelations_Means);
means = addvars(means,{'Mean'},'Before',1);
means.Properties.VariableNames = CompiledCorrelations.Properties.VariableNames;
CompiledCorrelations = [CompiledCorrelations;means];
writetable(CompiledCorrelations,FN3); 
   corrmeanout = reshape(CompiledCorrelations_Means,[],11);
writematrix(corrmeanout, FN4);


labels = var_names;
% scatter plot
n = size(corrmeanout, 1);
y = triu(repmat(n+1, n, n) - (1:n)') + 0.5;
x = triu(repmat(1:n, n, 1)) + 0.5;
x(x == 0.5) = NaN;
scatter(x(:), y(:), 350.*abs(corrmeanout(:)), corrmeanout(:), 'filled')
% enclose markers in a grid
xl = [1:n+1;repmat(n+1, 1, n+1)];
xl = [xl(:, 1), xl(:, 1:end-1)];
yl = repmat(n+1:-1:1, 2, 1);
line(xl, yl, 'color', 'k') % horizontal lines
line(yl, xl, 'color', 'k') % vertical lines
% show labels
text((1:n)-0.5, (n:-1:1) + 0.5, labels, 'HorizontalAlignment', 'right','FontName',...
    'Arial','Color','k','FontWeight','bold',"FontSize",10)
pause(3);
text((1:n) + 0.5, repmat(n + 1, n, 1)+0.25, labels, ...
    'HorizontalAlignment', 'right', 'Rotation', 270, 'FontName','Arial','Color','k',"FontWeight","bold",...
    "FontSize",10)
h = gca;
h.Visible = 'off';
h.Position(4) = h.Position(4)*0.95;
axis(h, 'equal')

%% For Golgi or other older MATLAB versions
nebula = load("Nebula_Colormap.mat");
colormap(h,nebula.NebulaColormap)
%% For MATLAB 2025 onward
%colormap('nebula');

bar=colorbar(h,'Ticks',[-0.5,-0.25,0,0.25,0.5,0.75,1],'TickLabels',{-0.5,-0.25,0,0.25,0.5,0.75,1},'Location','east','AxisLocation','out');
set(gcf, "Theme", "light");
bar.FontName = "Arial";
bar.FontSize = 10;
bar.Label.String = 'Pearson Correlation Coefficient';
bar.Label.Rotation = 270;
bar.Label.FontName = "Arial";
bar.Label.FontSize = 12;
bar.Label.FontWeight = "bold";
 saveas(gca,FN6);
    close(gcf);