% Read in a matrix of correlations and plot publication ready plots.
directory = 'Z:\Christina Lebonville\2020.06.16 (CL8 or DRK-MK) CeA Dyn Fiber Recording in DID\Fiber Photometry Data\Cohort2_Recordings\';
Results = [directory,'..','\Correlation_Results\'];
Figures = [directory,'..','\Correlation_Figures\'];

FN4=[Results, 'MeanMatrix.xlsx'];
FN6=[Figures, 'ExptWideMetaRMatrix.jpeg'];

corrmeanout = readtable(FN4,Sheet=1);

corrmeanout = table2array(corrmeanout);
var_names=["Filtered 405" "Detrended 405" "Self-norm 405" "Robust 405" "JCBM 405" "Filtered 470"...
        "Detrended 470" "Self-norm 470" "Standard 470" "Robust 470" "JCBM 470"];
        

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
h.Position(4) = h.Position(4)*0.85;
axis(h, 'equal')

%% For Golgi or other older MATLAB versions
% nebula = load("Nebula_Colormap.mat");
% colormap(h,nebula.NebulaColormap)
%% For MATLAB 2025 onward
colormap('nebula');

bar=colorbar(h,'Position',[0.736699155843787 0.112185686653772 0.0258153959606364 0.692456479690522],...
    'Ticks',[-1,-0.75,-0.5,-0.25,0,0.25,0.5,0.75,1],'TickLabels',{-1,-0.75,-0.5,-0.25,0,0.25,0.5,0.75,1},'Location','east','AxisLocation','out');
set(gcf, "Theme", "light");
bar.FontName = "Arial";
bar.FontSize = 10;
bar.Label.String = 'Pearson Correlation Coefficient';
bar.Label.Rotation = 270;
bar.Label.FontName = "Arial";
bar.Label.FontSize = 12;
bar.Label.FontWeight = "bold";
bar.TickDirection = "out";

saveas(gca,FN6);