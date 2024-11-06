function saveeditinfo()
% 
HGUI4 = get(gcf,'UserData');
DBfields = HGUI4.DBfields;
DBfieldsNUM = {'CellNum','Rs','Cm','Comp'};

HFmain = getappdata(0, 'HFmain');
FInfo = get(HFmain,'UserData');
S = get(FInfo.Hlines(2),'UserData');

runNum = S.runNum; 
runstr = strcat('Run', num2str(runNum, '%.4d'));

DBParams = S.(runstr).DBParams;


flag = 0;
for i = 1:length(DBfields)
      
        curr = get(HGUI4.(['edit',DBfields{i}]),'String');
        ori = get(HGUI4.(['textori',DBfields{i}]),'String');
        
        if strcmp(curr,ori) == 0
            if ismember(DBfields{i},DBfieldsNUM)
                DBParams.(['ori',DBfields{i}]) = str2num(ori);
                DBParams.(DBfields{i}) = str2num(curr);              
            else
                DBParams.(['ori',DBfields{i}]) = ori;
                DBParams.(DBfields{i}) = curr;
            end
             DBParams.lastEditDate = date;
             flag = 1;
        end
        
        
   
end
if flag == 1  
    % save to S
    S.(runstr).DBParams = DBParams;
    S.analyzedflag = 1;
    set(FInfo.Hlines(2),'UserData',S); 
    set(HFmain,'UserData',FInfo);

    % save to real file
    matDataFolders = FInfo.matDataFolders;
    matDataFolderSel = FInfo.matDataFolderSel;
    matDataFolder = matDataFolders{matDataFolderSel};
    
    Hlistbox = FInfo.HGUI.Hlistbox;
    filelist = get(Hlistbox,'string');
    datafilename =  filelist{get(Hlistbox,'Value')}; 
    datafile = fullfile(matDataFolder,datafilename);
    save(datafile,'S');
    %close current figure
    figHandles = get(0,'Children');
    for i = length(figHandles):-1:1
        if figHandles(i) ~= HFmain
            close(figHandles(i))
        end
    end
    % plotswp again (mainly for update info) 
    infoUpdate = 1;
    plotswp(S, S.runNum, S.swpNum, infoUpdate)
end