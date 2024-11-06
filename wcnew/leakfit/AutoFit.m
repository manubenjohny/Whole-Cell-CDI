function AutoFit()
% try to show cursor as watch to indicate matlab is busy during fitting,
% need to turn off zoom first. Works in step-by-step debug mode, but not
% when running
zoom off 
set(gcf, 'pointer', 'watch')


HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');
HGUI2 = FInfo2.HGUI2;

time = FInfo2.leakfitData.time;
pAleak = FInfo2.leakfitData.pAleak;

leakfitParams0 = getParams();
lkftParamsMx0 = ParamsStruct2Mx (leakfitParams0);
% autoleakfit = FITLeakMx(lkftParamsMx0, time);

% lkftParamsMx = nlinfit(time',pAleak',@FITLeakMx,lkftParamsMx0);
lb = [-1000,...
    -1000, -1e4, 0.01, -100, 0.01,...
    -1000, -1e4, 0.01, -100, 0.01,...
    -1000, -1e4, 0.01, -100, 0.01,...
    0.1]';
ub = [1000, ...
    1000, 1e4, 100, 100, 100,...
    1000, 1e4, 100, 100, 100,...
    1000, 1e4, 100, 100, 100,...
    0.9]';


lkftParamsMx = lsqcurvefit(@FITLeakMx,lkftParamsMx0,time',pAleak',lb,ub);

Times = FInfo2.leakfitData.Times;
leakfitParams = ParamsMx2Struct(lkftParamsMx);

try
%     autoleakfit = FITLeak(beta, time);
    autoleakfit = FITLeak(leakfitParams, time);
catch
    disp('Error: NO AutoFIT Possible with Current Guess')   
    return;
end

axes(HGUI2.AxLkfit)
if isfield(HGUI2,'lkfit')    
    delete(HGUI2.lkfit);
    HGUI2 = rmfield(HGUI2,'lkfit');    
end
HGUI2.lkfit = line(time, autoleakfit, 'color', 'k');

axes(HGUI2.AxLkFitSub)
if isfield(HGUI2,'lkfitSub')    
    delete(HGUI2.lkfitSub);
    HGUI2 = rmfield(HGUI2,'lkfitSub');    
end
pALkFitSub =FInfo2.leakfitData.pAtrace - FInfo2.leakfitData.pAleakfit;
HGUI2.lkfitSub = line(time, pALkFitSub);
xlim([time(1), sum(Times)])

%
FInfo2.HGUI2 = HGUI2;
set(HFleakfit, 'UserData', FInfo2);




resp = questdlg('Keep AutoFit?');
if ~(strcmp(resp(1),'N')) || (strcmp(resp(1),'C'))
    setParams(leakfitParams, Times)
end
set(gcf, 'pointer', 'arrow')
zoom xon