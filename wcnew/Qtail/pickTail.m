function pickTail()

FInfo = get(gcf,'UserData');
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
runstr = strcat('Run', num2str(runNum, '%.4d'));
swpNum = S.swpNum;
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));
ST = S.(runstr).StimParams.ST;
Tailtime_center = sum(S.(runstr).StimParams.Dstep(1:2));

if ST ~= 1 % only run this function when the trace is not a ramp
    if ~isfield(FInfo,'HQ') 
       QToff2on
       FInfo = get(gcf,'UserData');
       % QToff2on update HQ and Htail in FInfo, so need to reload it!
       pause(2)
    end
    
    expandx(Tailtime_center - 10,Tailtime_center + 10)
    
    set(FInfo.Htail,'Marker','o','MarkerEdgeColor','red')

    [tailTime,pAtail,button] = ginput(1); 
    if button == 1
        set(FInfo.Htail,'XData',tailTime,'YData',pAtail)
        set(FInfo.Htail,'Marker','x','MarkerEdgeColor','cyan')
    end
    
    pause(2)
    expandx
    
    Qtail.tailTime = tailTime;
    Qtail.pAtail = pAtail;
    noQ = 0;
    try 
        Qtail.Q = S.(runstr).(swpstr).Qtail.Q;
        Qtail.Qtimes = S.(runstr).(swpstr).Qtail.Qtimes;
    catch
        noQ = 1;
    end
    % update S stored as "UserData" in GUI   
    updateSrunswp('Qtail',Qtail);
    % store manual picked CDI to mat file
    writeS2mat()

    % update GUI
    FInfo = get(gcf,'UserData');
    HGUI = FInfo.HGUI;
    if noQ == 1
        set(HGUI.textQTail,'String','has manual tail picked',...
        'ForeGroundColor',[0 0.5 0])
    else
         set(HGUI.textQTail,'String','has manual Qtail picked',...
        'ForeGroundColor',[0 0.5 0])
    end
    set(gcf,'UserData', FInfo)
    
end