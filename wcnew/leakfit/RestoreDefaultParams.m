function RestoreDefaultParams()
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

HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');

Times = FInfo2.leakfitData.Times;

setParams(defaultleakfitParams, Times) 
