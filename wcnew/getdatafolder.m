function getdatafolder()      

FInfo = get(gcf,'UserData'); 
HGUI = 	 FInfo.HGUI;        
Hlistbox = HGUI.Hlistbox;

matDataFolders = FInfo.matDataFolders;
matDataFolderSel = FInfo.matDataFolderSel;
matDataFolder = matDataFolders{matDataFolderSel};



DirFilter = '*.mat';        
datafilelist = dir(fullfile(matDataFolder, DirFilter));           
numfiles = length(datafilelist);
datafilenames = cell(numfiles,1);
for j = 1:numfiles      
    datafilenames{j} = [datafilelist(j).name];           
end


set(Hlistbox, 'string',datafilenames, 'value', 1);        
