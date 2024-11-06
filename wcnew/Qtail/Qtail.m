function Qtail()
FInfo = get(gcf,'UserData');
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
runstr = strcat('Run', num2str(runNum, '%.4d'));
ST = S.(runstr).StimParams.ST;
swpNum = S.swpNum;
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));
try 
    Q = S.(runstr).(swpstr).Qtail.Qtimes;
catch 
    Q = [];
end

try
    tail = [S.(runstr).(swpstr).Qtail.tailTime, ...
        S.(runstr).(swpstr).Qtail.pAtail];
catch
    tail = [];
end

if ST ~= 1
    if isfield(FInfo,'HQ') && isfield(FInfo,'Htail')
       QTon2off
    else
       QToff2on(Q,tail)
    end
end