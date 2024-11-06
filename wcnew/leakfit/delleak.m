function  delleak()


resp = questdlg('Are you sure to delete leak fitting for this sweep?');
if strcmp(resp,'Yes') 
    suredelleak()
end
end

function suredelleak()
HFmain = getappdata(0, 'HFmain');
FInfo = get(HFmain,'UserData');
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
swpNum = S.swpNum;
dataStruct = S.(['Run' num2str(runNum, '%.4d')]); 
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));

try
    dataStruct.(swpstr) = rmfield(dataStruct.(swpstr),'pAleakfit');
    dataStruct.(swpstr) = rmfield(dataStruct.(swpstr),'leakfitParams');
    dataStruct.(swpstr) = rmfield(dataStruct.(swpstr),'curMasks');
end
% update S as Userdata in GUI 
S.(['Run' num2str(runNum, '%.4d')]) = dataStruct; 
set(FInfo.Hlines(2),'UserData',S);
set(HFmain,'UserData', FInfo);

% write updated S to the mat file
writeS2mat()

% replot in GUI
infoUpdate = 1;
plotswp(S, S.runNum, S.swpNum, infoUpdate)

end