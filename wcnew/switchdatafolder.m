function switchdatafolder()

FInfo = get(gcf,'UserData'); 
HGUI = FInfo.HGUI;
Hopendir = HGUI.Hopendir ;

if FInfo.matDataFolderSel ~= 1
    FInfo.matDataFolderSel = 1;
    set(Hopendir, 'String', 'Switch to Edata');
else
    FInfo.matDataFolderSel = 2;
    set(Hopendir, 'String', 'Switch to Zdata');

end

set(gcf, 'UserData', FInfo)
getdatafolder()     
try
    NEWFILE_LBox
catch
    disp('uhoh')
end



% if ~isempty(strfind(matDataFolder,'zdata'))
%     wcljsedata % switch from zdata to edata
% elseif ~isempty(strfind(matDataFolder,'edata')) 
%     wcljszdata % switch from edata to zdata
% else
%     error('Failed to swith')
% end
