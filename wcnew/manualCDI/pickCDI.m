function pickCDI()
FInfo = get(gcf,'UserData');
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
runstr = strcat('Run', num2str(runNum, '%.4d'));
ST = S.(runstr).StimParams.ST;

xxx = FInfo.xxx;

if ST ~= 1 % only run this function when the trace is not a ramp
    if ~isfield(FInfo,'HCDIlines') 
       CDIoff2on
       FInfo = get(gcf,'UserData');
       % CDIoff2on update mCDI in FInfo, so need to reload it!
    end
    mCDI = FInfo.mCDI;

    for i = 1:4
        set(FInfo.HCDIlines(i),'Marker','o','MarkerEdgeColor','red')
        [x,y,button] = ginput(1);                
        if button == 1
            if i == 1
                mCDI.peakPrepulse.ival = y;
                mCDI.peakPrepulse.time = x;
                set(FInfo.HCDIlines(i),'XData',x,'YData',y)
                set(FInfo.HCDIlines(i),'Marker','x','MarkerEdgeColor','cyan')
                % Peak should be in Cyan
            else
                mCDI.(['i', num2str(xxx(i-1))]).ival = y;
                mCDI.(['i', num2str(xxx(i-1))]).time = x;
                if abs(mCDI.peakPrepulse.ival/mCDI.peakTestpulse.ival) < 0.05
                    mCDI.(['i', num2str(xxx(i-1))]).rval = 1;
                else
                    mCDI.(['i', num2str(xxx(i-1))]).rval = y/mCDI.peakPrepulse.ival;
                end
                set(FInfo.HCDIlines(i),'XData',x,'YData',y)
                set(FInfo.HCDIlines(i),'Marker','x','MarkerEdgeColor','black')
            end
        end  
        
    end        
    displaytxt(mCDI)
  
    % update S stored as "UserData" in GUI   
    updateSrunswp('mCDI',mCDI);
    % store manual picked CDI to mat file
    writeS2mat()

    % update GUI
    FInfo = get(gcf,'UserData');
    HGUI = FInfo.HGUI;
    set(HGUI.textCDI,'String','has manual CDI picked',...
    'ForeGroundColor',[0 0.5 0])
    FInfo.mCDI = mCDI;
    set(gcf,'UserData', FInfo)
end