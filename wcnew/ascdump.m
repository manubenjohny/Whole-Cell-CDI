function ascdump
%%	ASCDUMP.M	ASCII Dump of Sweep with option to skip points

FInfo = get(gcf,'UserData');			


HIDline = FInfo.Hlines(2);
S = get(HIDline, 'UserData');
runNum = S.runNum;
swpNum = S.swpNum;

runstr = strcat('Run', num2str(runNum, '%.4d'));
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));

I = 1e6/S.(runstr).StimParams.SampleHz;



HGUI = 	 FInfo.HGUI;        
Hlistbox = HGUI.Hlistbox;

matDataFolders = FInfo.matDataFolders;
matDataFolderSel = FInfo.matDataFolderSel;
matDataFolder = matDataFolders{matDataFolderSel};

filelist = get(Hlistbox,'string');
datafilename =  filelist{get(Hlistbox,'Value')}; 
datafilename_noext = regexp(datafilename,'.*(?=\.mat)','match');

targetfilefolder = fullfile(matDataFolder,'ascdump_container');
if exist(targetfilefolder, 'dir') ~= 7
    mkdir(targetfilefolder)
end

targetfile = fullfile(targetfilefolder,...
    [datafilename_noext{1},'_',runstr,'_',swpstr,'.txt']);



trace = get(HIDline,'YData');
time = get(HIDline,'XData');



disp(' ');
disp(['Range:  ' num2str(time(1)) ' to ' num2str(time(length(time)))]);

t = input ('Enter Range for Output [t1 t2]: ');

if isempty(t)
    ti = [1 length(time)];
    disp('Full Range');
else
    ti = [0 0];
    ti(1) = find(time >= (t(1) - I/1000/2) & time < (t(1) + I/1000/2));
    ti(2) = find(time >= (t(2) - I/1000/2) & time < (t(2) + I/1000/2));

    disp(' ');
    disp(['Selected Range: [' num2str(time(ti(1))) ' ' num2str(time(ti(2))) ']']);
end

% Determine how many points to output
disp(' ');
disp(['Sampling I (usec):  ' num2str(I)]);
    disp(['Points per ms:      ' num2str(1000/I)]);

skippts = input ('Output 1/x points. Enter x: '); 

if isempty(skippts)
    skippts = 1;
    disp(['x: ' num2str(skippts)']);
end

x = [ti(1):skippts:ti(2)];
data = [time(x);trace(x)];

% Open up file and write trace

dumpfile = input(sprintf('Enter File Name %s : ',targetfile),'s');

if isempty(dumpfile)
    dumpfile = targetfile;
end

dumpfileID = fopen(dumpfile,'w');
fprintf(dumpfileID, '%f\t%f\n',data);
fclose(dumpfileID);

disp('Done.');