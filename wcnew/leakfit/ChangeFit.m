function ChangeFit()

HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');
HGUI2 = FInfo2.HGUI2;


[leakfitParams, Times] = getParams(); 
% FInfo2.leakfitData.leakfitParams and FInfo2.leakfitData.Times is updated in getParams()

time = FInfo2.leakfitData.time;

FInfo2.leakfitData.pAleakfit = FITLeak(leakfitParams,time);


LSQERROR = sum((FInfo2.leakfitData.pAleak - FInfo2.leakfitData.pAleakfit).^2);
set(HGUI2.Error, 'String', num2str(LSQERROR))

axes(HGUI2.AxLkfit)
if isfield(HGUI2,'lkfit') && HGUI2.lkfit ~= 0 
    delete(HGUI2.lkfit);
    HGUI2 = rmfield(HGUI2,'lkfit');    
end
HGUI2.lkfit = line(time, FInfo2.leakfitData.pAleakfit);



axes(HGUI2.AxLkFitSub)
if isfield(HGUI2,'lkfitSub') &&  HGUI2.lkfitSub ~= 0
    delete(HGUI2.lkfitSub);
    HGUI2 = rmfield(HGUI2,'lkfitSub');    
end
pALkFitSub =FInfo2.leakfitData.pAtrace - FInfo2.leakfitData.pAleakfit;
HGUI2.lkfitSub = line(time, pALkFitSub);
xlim([time(1), sum(Times)])

%
FInfo2.HGUI2 = HGUI2;
set(HFleakfit, 'UserData', FInfo2);

