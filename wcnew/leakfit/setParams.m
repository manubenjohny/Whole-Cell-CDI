function setParams(leakfitParams, Times)
HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');
HGUI2 = FInfo2.HGUI2;

set(HGUI2.offset   ,'string',sprintf('%.4g',leakfitParams.offset));                                                                  
set(HGUI2.P2offset ,'string',sprintf('%.4g',leakfitParams.P2offset));                                                                  
set(HGUI2.P2a0     ,'string',sprintf('%.4g',leakfitParams.P2a0));                                                                  
set(HGUI2.P2tau0   ,'string',sprintf('%.4g',leakfitParams.P2tau0));                                                                  
set(HGUI2.P2a1     ,'string',sprintf('%.4g',leakfitParams.P2a1));                                                                  
set(HGUI2.P2tau1   ,'string',sprintf('%.4g',leakfitParams.P2tau1));                                                                  
set(HGUI2.P3offset ,'string',sprintf('%.4g',leakfitParams.P3offset));                                                                  
set(HGUI2.P3a0     ,'string',sprintf('%.4g',leakfitParams.P3a0));                                                                  
set(HGUI2.P3tau0   ,'string',sprintf('%.4g',leakfitParams.P3tau0));                                                                  
set(HGUI2.P3a1     ,'string',sprintf('%.4g',leakfitParams.P3a1));                                                                  
set(HGUI2.P3tau1   ,'string',sprintf('%.4g',leakfitParams.P3tau1));                                                                  
set(HGUI2.P4offset ,'string',sprintf('%.4g',leakfitParams.P4offset));                                                                  
set(HGUI2.P4a0     ,'string',sprintf('%.4g',leakfitParams.P4a0));                                                                  
set(HGUI2.P4tau0   ,'string',sprintf('%.4g',leakfitParams.P4tau0));                                                                  
set(HGUI2.P4a1     ,'string',sprintf('%.4g',leakfitParams.P4a1));                                                                  
set(HGUI2.P4tau1   ,'string',sprintf('%.4g',leakfitParams.P4tau1)); 
set(HGUI2.lambda   ,'string',sprintf('%.4g',leakfitParams.lambda)); 

% --------------------------------
set(HGUI2.T1   ,'string',Times(1));                                                                  
set(HGUI2.T2   ,'string',Times(2));                                                                  
set(HGUI2.T3   ,'string',Times(3)); 
set(HGUI2.T4   ,'string',Times(4)); 

FInfo2.leakfitData.leakfitParams = leakfitParams;
FInfo2.leakfitData.Times = Times;

set(HFleakfit, 'UserData', FInfo2);
ChangeFit()
