function PlotAllFIles_IV()
CurFold = uigetdir;
if ~strcmp(CurFold(end),'\')
    CurFold = [CurFold '\'];
end
figure;
files = dir([CurFold,'*.xls']);
maxrow = str2double(inputdlg('Maximum Number of Rows'));
S = 0.75; H=2; W = H*1.618;

for ijk = 1:length(files)
    row = mod(ijk,maxrow)-1;
    if row<0
        row = maxrow-1;
    end
    col = floor((ijk-1)/maxrow);
    ax(ijk) = axes('units','centimeters','position',[S+(col)*(W+S) S+(row)*(H+S) W H]);
    plotNormIV(ax(ijk),[CurFold files(ijk).name],0);
    text(-40, -0.8, files(ijk).name,'parent', ax(ijk),'interpreter','none');
    fprintf('done with file %d of %d\n', [ijk length(files)])
end

