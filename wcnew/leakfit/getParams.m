function [leakfitParams, Times] = getParams()
HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');
HGUI2 = FInfo2.HGUI2;

leakfitParams.offset    = str2num(get(HGUI2.offset    ,'string'));
leakfitParams.P2offset  = str2num(get(HGUI2.P2offset  ,'string'));
leakfitParams.P2a0      = str2num(get(HGUI2.P2a0      ,'string'));
leakfitParams.P2tau0    = str2num(get(HGUI2.P2tau0    ,'string'));
leakfitParams.P2a1      = str2num(get(HGUI2.P2a1      ,'string'));
leakfitParams.P2tau1    = str2num(get(HGUI2.P2tau1    ,'string'));
leakfitParams.P3offset  = str2num(get(HGUI2.P3offset  ,'string'));
leakfitParams.P3a0      = str2num(get(HGUI2.P3a0      ,'string'));
leakfitParams.P3tau0    = str2num(get(HGUI2.P3tau0    ,'string'));
leakfitParams.P3a1      = str2num(get(HGUI2.P3a1      ,'string'));
leakfitParams.P3tau1    = str2num(get(HGUI2.P3tau1    ,'string'));
leakfitParams.P4offset  = str2num(get(HGUI2.P4offset  ,'string'));
leakfitParams.P4a0      = str2num(get(HGUI2.P4a0      ,'string'));
leakfitParams.P4tau0    = str2num(get(HGUI2.P4tau0    ,'string'));
leakfitParams.P4a1      = str2num(get(HGUI2.P4a1      ,'string'));
leakfitParams.P4tau1    = str2num(get(HGUI2.P4tau1    ,'string'));
leakfitParams.lambda    = str2num(get(HGUI2.lambda    ,'string'));
% Params = [offset,P2offset,P2a0,P2tau0,P2a1,P2tau1,P3offset,P3a0, ... 
%      P3tau0,P3a1,P3tau1,P4offset,P4a0,P4tau0,P4a1,P4tau1,lambda];
%  HGUI2.data.Params = Params;
 
Times(1) = str2num(get(HGUI2.T1    ,'string'));
Times(2) = str2num(get(HGUI2.T2    ,'string'));
Times(3) = str2num(get(HGUI2.T3    ,'string'));
Times(4) = str2num(get(HGUI2.T4    ,'string'));

if length(fields(leakfitParams)) < 16
 disp('Error: Some Param is Invalid or Missing')
end

FInfo2.leakfitData.leakfitParams = leakfitParams;
FInfo2.leakfitData.Times = Times;
set(HFleakfit, 'UserData', FInfo2);
