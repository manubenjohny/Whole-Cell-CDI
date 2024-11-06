function WriteDataold()
% retrieve the repository "S" from the UserData of HFmain
HFmain = getappdata(0, 'HFmain');
FInfo = get(HFmain,'UserData');
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
swpNum = S.swpNum;
runstr = strcat('Run', num2str(runNum, '%.4d')); 
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));

% snapshot leakfit info
[leakfitParams, ~] = getParams();
HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');

% update "S" and then store in the UserData of HFmain
S.(runstr).(swpstr).pAleakfit = FInfo2.leakfitData.pAleakfit;
S.(runstr).(swpstr).leakfitParams = leakfitParams;
try
    S.(runstr).(swpstr).curMasks = FInfo2.leakfitData.curMasks;
catch
    S.(runstr).(swpstr).curMasks = [];
end
S.analyzedflag = 1;

set(FInfo.Hlines(2),'UserData',S);
set(HFmain,'UserData', FInfo);

% write to the mat file
writeS2mat()

% close current figure and replot on HFmain
figHandles = get(0,'Children');
for i = length(figHandles):-1:1
    if figHandles(i) ~= HFmain
        close(figHandles(i))
    end
end
% set(gcf, HFmain)
infoUpdate = 1;
plotswp(S, runNum, swpNum, infoUpdate)



