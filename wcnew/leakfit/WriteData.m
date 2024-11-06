function WriteData()


% snapshot leakfit info
[leakfitParams, ~] = getParams();
HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');

% update S stored as UserData in GUI
updateSrunswp('pAleakfit',FInfo2.leakfitData.pAleakfit);
updateSrunswp('leakfitParams',leakfitParams);
try
    updateSrunswp('curMasks',FInfo2.leakfitData.curMasks);
catch
    updateSrunswp('curMasks',[]);

end

% write updated S to the mat file
writeS2mat()

% close current figure 
HFmain = getappdata(0, 'HFmain');
figHandles = get(0,'Children');
for i = length(figHandles):-1:1
    if figHandles(i) ~= HFmain
        close(figHandles(i))
    end
end

HFmain = getappdata(0, 'HFmain');
FInfo = get(HFmain,'UserData');
S = get(FInfo.Hlines(2),'UserData');
infoUpdate = 1;
plotswp(S, S.runNum, S.swpNum, infoUpdate)



