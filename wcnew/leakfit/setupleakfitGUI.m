function setupleakfitGUI()

HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');
HGUI2 = FInfo2.HGUI2;

%% grab trace data from UserData stored in HFmain 
HFmain = getappdata(0, 'HFmain');
FInfo = get(HFmain,'UserData');
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
swpNum = S.swpNum;
dataStruct = S.(['Run' num2str(runNum, '%.4d')]); 
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));
ST = dataStruct.StimParams.ST;
if ST == 1
%     xdata = dataStruct.(swpstr).voltage; 
    error('currently cannot fit ramp!')
else
    time = dataStruct.(swpstr).time;
end 
pAtrace = dataStruct.(swpstr).pAtrace;
pAleak = dataStruct.(swpstr).pAleak;
pAtraceleaksub = pAtrace - pAleak;

%% most useful data, stored in UserData of HFleakfit for fitting! 
leakfitData.time = time;
leakfitData.pAtrace = pAtrace;
leakfitData.pAleak = pAleak;
try
    leakfitData.pAleakfit = dataStruct.(swpstr).pAleakfit;
catch
end
% leakfitData.pAtraceleaksub = pAtraceleaksub;
% update FInfo2
FInfo2.leakfitData = leakfitData;
set(HFleakfit, 'UserData', FInfo2);

%% plot pAtrace and pAleak (traces won't change in this GUI)

% obtain the "conventional" parameters from S
PV = zeros(1,8);
PV(1:4) = dataStruct.StimParams.Vstep;
PV(5:8) = dataStruct.StimParams.Dstep;
% NI = dataStruct.StimParams.NI;
PR = dataStruct.StimParams.PR;
PF = dataStruct.StimParams.PF;
I = 1e6/dataStruct.StimParams.SampleHz;

%
% TPulse = [time(1) PV(6)+PV(7)+PV(8)-time(1)];
xlimits(1) = round(-(PR+PF)*I/1000);
xlimits(2) = sum(PV(5:8));
Times = PV(5:8);

% start plotting:
axes(HGUI2.AxLkfit)
plot(time, pAtrace,'g-',time, pAleak,'r-')
xlim(xlimits)		
title('Leak')
axes(HGUI2.AxLkSub)
plot(time, pAtraceleaksub,'k-')
zoom xon;
xlim(xlimits)
title('Leak Subtracted')
axes(HGUI2.AxLkFitSub)
title('Leak Fit Subtracted')
zoom xon;

namestr = [S.rawfile.name, ...
        '; Cell No: ', num2str(dataStruct.DBParams.CellNum), ...
        '; Xfection: ', dataStruct.DBParams.XFect];
set(HFleakfit, 'Name', namestr);


%% setup leakfit Paramters 
% default leakfit Params
defaultleakfitParams.offset   = 0.8;                                                                  
defaultleakfitParams.P2offset = 0;                                                                 
defaultleakfitParams.P2a0     = 80;                                                                 
defaultleakfitParams.P2tau0   = 3;                                                                  
defaultleakfitParams.P2a1     = -30;                                                                  
defaultleakfitParams.P2tau1   = 100;                                                                  
defaultleakfitParams.P3offset = -25;                                                                  
defaultleakfitParams.P3a0     = -40;                                                                  
defaultleakfitParams.P3tau0   = 1;                                                                  
defaultleakfitParams.P3a1     = 0;                                                                  
defaultleakfitParams.P3tau1   = 0.4;                                                                  
defaultleakfitParams.P4offset = -25;                                                                  
defaultleakfitParams.P4a0     = 0.1;                                                                  
defaultleakfitParams.P4tau0   = 0.2;                                                                  
defaultleakfitParams.P4a1     = 0.1;                                                                  
defaultleakfitParams.P4tau1   = 1.5; 
defaultleakfitParams.lambda   = 0.8; 
 
% leakfitParams = [0.8, 0,  80,   3, -30, 100, ...
%           -25, -40,   1,   0, 0.4  ...
%           -25,   0.1, 0.2,   0.1, 1.5 .8];
      


% try to retrive dataStruct.(swpstr).leakfitParams
% try
%     leakfitParams = dataStruct.(swpstr).leakfitParams;
% catch
%     try
%          % try to load from last sweep
%         leakfitParams = dataStruct.(strcat('Swp', num2str(swpNum-1, '%.4d'))).leakfitParams; 
%     catch
%         leakfitParams = defaultleakfitParams;
%     end
% end


previousfit = 0;
if isfield(dataStruct.(swpstr), 'leakfitParams')
    leakfitParams = dataStruct.(swpstr).leakfitParams;
    curMasks = dataStruct.(swpstr).curMasks;
    previousfit = 1;
end
if previousfit ==0
    for i = swpNum-1:-1:1
        istr = strcat('Swp', num2str(i, '%.4d'));
        if isfield(dataStruct.(istr), 'leakfitParams')
            leakfitParams = dataStruct.(istr).leakfitParams;
            curMasks = dataStruct.(istr).curMasks;
            previousfit = 1;
            break;
        end
    end
end

if previousfit == 0
    maxrun =  getmaxswp(dataStruct);
    for i = swpNum+1:1:maxrun
        istr = strcat('Swp', num2str(i, '%.4d'));
        if isfield(dataStruct.(istr), 'leakfitParams')
            leakfitParams = dataStruct.(istr).leakfitParams;
            curMasks = dataStruct.(istr).curMasks;
            previousfit = 1;
            break;
        end
    end
end

if previousfit == 0
    leakfitParams = defaultleakfitParams;
    T = cumsum(Times);
    for i = 1:3
        curMasks{i} = sprintf('%.1f,%.1f',T(i)-0.4,T(i)+0.2);
    end

    
end

% write leakfitParams to GUI
setParams(leakfitParams, Times) %update FInfo2 here, have to reload it:
FInfo2 = get(HFleakfit, 'UserData');
HGUI2 = FInfo2.HGUI2;

% try 
%     curMasks = dataStruct.(swpstr).curMasks;
% catch
%     try
%         curMasks = dataStruct.(strcat('Swp', num2str(swpNum-1, '%.4d'))).curMasks;
%     catch
%         curMasks = '';
%     end
% end
set(HGUI2.Mask,'string',curMasks);
FInfo2.leakfitData.curMasks = curMasks;
set(HFleakfit, 'UserData', FInfo2);

ChangeFit()



