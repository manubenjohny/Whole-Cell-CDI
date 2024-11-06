function pAleakfit = ApplyMask(pAleakfitNoMask)
HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');
HGUI2 = FInfo2.HGUI2;


pAleak = FInfo2.leakfitData.pAleak;
time = FInfo2.leakfitData.time;

myMasks = get(HGUI2.Mask,'string');
if ~isempty(myMasks)
    for i =1:length(myMasks)
        TempMask = str2num(myMasks{i});
        Ta = (time-TempMask(1)).^2;
        Tb = (time-TempMask(2)).^2;
        TempTindex = [find(Ta==min(Ta)) find(Tb==min(Tb))];
        pAleakfitNoMask(TempTindex(1):TempTindex(2)) = pAleak(TempTindex(1):TempTindex(2));
    end
    pAleakfit = pAleakfitNoMask;
    return;
else
    pAleakfit = pAleakfitNoMask;
    return;
end
    