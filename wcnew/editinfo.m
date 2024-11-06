function editinfo()
HFmain = getappdata(0, 'HFmain');
FInfo = get(HFmain,'UserData');
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum; 
runstr = strcat('Run', num2str(runNum, '%.4d'));
% StimParams = S.(runstr).StimParams;
DBParams = S.(runstr).DBParams;

DBfields = {'CellNum','Protocol',...
            'Rs', 'Cm', 'Comp', 'Leak', ...
            'IntSoln','ExtSoln',...
            'XFect','Notes'};
HGUI4.DBfields = DBfields;        
        
HGUI4.heditinfo = figure('Name', 'Edit Info', ...
            'NumberTitle', 'off', ...
            'Units', 'normal',...
            'Color',[0.8 0.9 0.8],...
            'Position', [.2 .2 .4 .6]);      
        
 %% display info
 HGUI4 = maketext(HGUI4, 'textCurrValue',[0.2, 0.9, 0.4, 0.05], 'Current Value', 'k');
 HGUI4 = maketext(HGUI4, 'textoriValue', [0.6, 0.9, 0.4, 0.05], 'Original Value', 'k');
for i = 1:length(DBfields)
    
    if i < length(DBfields) - 1
        textpos = [0,  0.9 - 0.052*i, 0.2, 0.052];
        editpos = [0.2,  0.9 - 0.05*i, 0.4, 0.05]; 
        textoripos = [0.6,  0.9 - 0.052*i, 0.4, 0.05];
    elseif i == length(DBfields) - 1
        textpos = [0,  0.9 - 0.052*(i+2), 0.2, 0.052*3];
        editpos = [0.2,  0.9 - 0.05*(i+2), 0.4, 0.05*3]; 
        textoripos = [0.6,  0.9 - 0.052*(i+2), 0.4, 0.052*3];
    else
        textpos = [0,  0.9 - 0.052*(i+5), 0.2, 0.052*4];
        editpos = [0.2,  0.9 - 0.05*(i+5), 0.4, 0.05*4]; 
        textoripos = [0.6,  0.9 - 0.052*(i+5), 0.4, 0.052*4];
    end
    HGUI4 = maketext(HGUI4, ['text',DBfields{i}],textpos, DBfields{i},'k');
    HGUI4 = makeedit(HGUI4, ['edit',DBfields{i}],editpos, DBParams.(DBfields{i}));

    try 
        oriValue = DBParams.(['ori',DBfields{i}]);
        color = 'r';
    catch
        oriValue = DBParams.(DBfields{i});
        color = 'k';
    end
    HGUI4 = maketext(HGUI4, ['textori',DBfields{i}],textoripos, oriValue, color); 


end

%% edit info
pos = [0, 0.9 - 0.052*(length(DBfields)+6), 0.2, 0.052];
HGUI4 = maketext(HGUI4,'textlastEdit', pos, 'Last Edit Date','k');
pos = [0.2, 0.9 - 0.052*(length(DBfields)+6), 0.2, 0.052];
try
    lastEditDate = DBParams.lastEditDate;
    color = 'r';
catch
    lastEditDate = 'Not Edit Before';
    color = 'k';
end
HGUI4 = maketext(HGUI4,'textlastEditDate', pos, lastEditDate, color );

pos = [0.4, 0.9 - 0.052*(length(DBfields)+6), 0.2, 0.06];
HGUI4.HBsave = uicontrol('Style','pushbutton',...
            'Units','normalized',...
            'Position',pos,...
            'String','Save Info',...
            'Callback','saveeditinfo',...
            'FontSize',10,...
            'HorizontalAlignment','center'); 
set(gcf,'UserData',HGUI4)


function HGUI4 = maketext(HGUI4 ,hname, pos, string,color)
HGUI4.(hname) = uicontrol('Style','text',...
            'Units','normalized',...
            'Position',pos,...
            'String',string,...
            'BackgroundColor',[0.8 0.9 0.8],...
            'ForegroundColor',color,...
            'FontSize',10,...
            'HorizontalAlignment','center'); 

function HGUI4 = makeedit(HGUI4,hname,pos,string)
HGUI4.(hname) = uicontrol('Style','edit',...
            'Units','normalized',...
            'Position',pos,...
            'String',string,...
            'Callback','',...
            'FontSize',10,...
            'HorizontalAlignment','center',...
             'Max', 2); 
        
 
