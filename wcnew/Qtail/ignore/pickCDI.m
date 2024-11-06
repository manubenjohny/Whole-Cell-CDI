function pickCDI()
FInfo = get(gcf,'UserData');
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
swpNum = S.swpNum;

runstr = strcat('Run', num2str(runNum, '%.4d'));
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));

ST = S.(runstr).StimParams.ST;

xxx = FInfo.xxx;

if ST ~= 1 % only run this function when the trace is not a ramp
    if ~isfield(FInfo,'HCDIlines') 
       CDIoff2on(xxx)
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
                mCDI.(['i', num2str(xxx(i-1))]).rval = y/mCDI.peakPrepulse.ival;
                set(FInfo.HCDIlines(i),'XData',x,'YData',y)
                set(FInfo.HCDIlines(i),'Marker','x','MarkerEdgeColor','black')
            end
        end  
        
    end        
    displaytxt(mCDI,xxx)
  
    
    % store manual picked CDI to mat file
    S.(runstr).(swpstr).mCDI = mCDI;
    S.analyzedflag = 1;

    HGUI = 	 FInfo.HGUI;        
    Hlistbox = HGUI.Hlistbox;

    matDataFolders = FInfo.matDataFolders;
    matDataFolderSel = FInfo.matDataFolderSel;
    matDataFolder = matDataFolders{matDataFolderSel};


    filelist = get(Hlistbox,'string');
    datafilename =  filelist{get(Hlistbox,'Value')}; 
    datafile = fullfile(matDataFolder,datafilename);
    save(datafile,'S');
    
    set(HGUI.textCDI,'String','has manual CDI picked',...
    'ForeGroundColor',[0 0.5 0])

    FInfo.mCDI = mCDI;
    set(FInfo.Hlines(2),'UserData',S);
    set(gcf,'UserData', FInfo)
end