function writeS2mat()
% save S stored in 'UserData' of FInfo.Hlines(2) into the matfile where S
% is read from
HFmain = getappdata(0, 'HFmain');
FInfo = get(HFmain,'UserData');
S = get(FInfo.Hlines(2),'UserData');

HGUI = 	 FInfo.HGUI;        
Hlistbox = HGUI.Hlistbox;

matDataFolders = FInfo.matDataFolders;
matDataFolderSel = FInfo.matDataFolderSel;
matDataFolder = matDataFolders{matDataFolderSel};

filelist = get(Hlistbox,'string');
datafilename =  filelist{get(Hlistbox,'Value')}; 
datafile = fullfile(matDataFolder,datafilename);
S = rmfield(S,'runNum');
S = rmfield(S,'swpNum');
save(datafile,'S');