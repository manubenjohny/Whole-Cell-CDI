function jetPlotRun()
HFmain = getappdata(0, 'HFmain');
FInfo = get(HFmain,'UserData');
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum; 
runstr = strcat('Run', num2str(runNum, '%.4d'));
dataStruct = S.(runstr);

swplist = fields(dataStruct);
for i = length(swplist):-1:1
    if ~strcmp(swplist{i}(1:3), 'Swp')
        swplist(i) =[];
    end
end


hjetplot = figure('Name', 'jetPlotRun', ...
            'NumberTitle', 'off', ...
            'Units', 'normal',...
            'Position', [.2 .2 .6 .6],...
            'keypressfcn',@keystroke_plot);
        
HGUI3.hswplist = uicontrol('Style','listbox', ...
            'Units','normalized',...
            'Position',[.05 .05 .15 .8],...
            'min',1, 'max',length(swplist),...
            'String',swplist,...
            'Value',[1:length(swplist)],...
            'Callback','jetplotSel',...
            'HorizontalAlignment','center');

HGUI3.haxis = axes('Box','on','Position', [.25 .05 .7 .8]);

title([strrep(S.rawfile.name,'_','\_'), ', ', runstr])      
set(hjetplot, 'UserData',HGUI3);

jetplotSel()


            
