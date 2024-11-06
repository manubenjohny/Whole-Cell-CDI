function delCDI()
resp = questdlg('Are you sure to delete manual picked CDI for this sweep?');
if strcmp(resp,'Yes') 
    suredelCDI()
end
end

function suredelCDI()
HFmain = getappdata(0, 'HFmain');
FInfo = get(HFmain,'UserData');
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
swpNum = S.swpNum;
dataStruct = S.(['Run' num2str(runNum, '%.4d')]); 
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));

if isfield(dataStruct.(swpstr),'Qtail')
    dataStruct.(swpstr) = rmfield(dataStruct.(swpstr),'Qtail');

    % update S as Userdata in GUI 
    S.(['Run' num2str(runNum, '%.4d')]) = dataStruct; 
    set(FInfo.Hlines(2),'UserData',S);
    set(HFmain,'UserData', FInfo);

    % write updated S to the mat file
    writeS2mat()

    % update GUI
    FInfo = get(gcf,'UserData');
    HGUI = FInfo.HGUI;
    set(HGUI.textQTail,'String','no Qtail picked',...
    'ForeGroundColor',[1 0 0])
    set(gcf,'UserData', FInfo)
end
end