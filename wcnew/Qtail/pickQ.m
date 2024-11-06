function pickQ()

FInfo = get(gcf,'UserData');
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
runstr = strcat('Run', num2str(runNum, '%.4d'));
swpNum = S.swpNum;
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));
ST = S.(runstr).StimParams.ST;
Qtime_center = S.(runstr).StimParams.Dstep(1);

if ST ~= 1 % only run this function when the trace is not a ramp
    if ~isfield(FInfo,'HQ') 
       QToff2on
%        FInfo = get(gcf,'UserData');
       % QToff2on update HQ and Htail in FInfo, so need to reload it!
       pause(2)
    end
%     HQ = FInfo.HQ;

    expandx(Qtime_center - 10,Qtime_center + 10)
    [Qtimes,~,~] = ginput(2);        
    QTon2off
    [Q,~] = QToff2on(Qtimes);
    pause(2)
    expandx
    
    Qtail.Qtimes = Qtimes;
    Qtail.Q = Q;
    notail = 0;
    try 
        Qtail.pAtail = S.(runstr).(swpstr).Qtail.pAtail;
        Qtail.tailTime = S.(runstr).(swpstr).Qtail.tailTime;
    catch
        notail = 1;
    end
    % update S stored as "UserData" in GUI   
    updateSrunswp('Qtail',Qtail);
    % store manual picked CDI to mat file
    writeS2mat()

    % update GUI
    FInfo = get(gcf,'UserData');
    HGUI = FInfo.HGUI;
    if notail == 1
        set(HGUI.textQTail,'String','has manual Q picked',...
        'ForeGroundColor',[0 0.5 0])
    else
         set(HGUI.textQTail,'String','has manual Qtail picked',...
        'ForeGroundColor',[0 0.5 0])
    end
    set(gcf,'UserData', FInfo)
    
end