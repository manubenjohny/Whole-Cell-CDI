function NEWFILE_LBox()

%function NEWFILE_LBox(hObject, eventdata, matDataFolder)

%%
%%	NEWFILE.M	Open a New Data File, Put Up First Trace
%%

% global datafilepath datafilename HFmain;
FInfo = get(gcf,'UserData'); 
HGUI = 	 FInfo.HGUI;        
Hlistbox = HGUI.Hlistbox;
% set(HGUI.Hlistbox,'Visible','Off');


matDataFolders = FInfo.matDataFolders;
matDataFolderSel = FInfo.matDataFolderSel;
matDataFolder = matDataFolders{matDataFolderSel};


filelist = get(Hlistbox,'string');
datafilename =  filelist{get(Hlistbox,'Value')}; 
datafile = fullfile(matDataFolder,datafilename);


set(gcf,'Name', datafilename);


% load data
clearvars S;
load(datafile,'S')
S.runNum = 1;
S.swpNum = 1;
S.maxrun = getmaxrun(S);
infoUpdate = 1;
getfcutoff()

% Plot the Sweep and update information 
plotswp(S, S.runNum, S.swpNum, infoUpdate);
set(HGUI.Hlistbox,'Visible','On');

