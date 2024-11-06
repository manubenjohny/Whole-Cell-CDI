function updateSrunswp(field, value)
% update S stored in 'UserData' of FInfo.Hlines(2). New FIELD will be added
% to S.(runstr).(swpstr), and S.(runstr).(swpstr).(field) be assigned with
% VALUE.
HFmain = getappdata(0, 'HFmain');
FInfo = get(HFmain,'UserData');
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
swpNum = S.swpNum;
runstr = strcat('Run', num2str(runNum, '%.4d')); 
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));
S.(runstr).(swpstr).(field) = value;
S.analyzedflag = 1;


set(FInfo.Hlines(2),'UserData',S);
set(HFmain,'UserData', FInfo);

