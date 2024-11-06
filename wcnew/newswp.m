function newswp(submenu)
%	NEWSWP.M	Allows Selection of a New Run in most recent datafile
%
%




FInfo = get(gcf,'UserData');
% FInfo.HGUI = HGUI;
Hlines = FInfo.Hlines;
% FInfo.Hdel = Hdel;

S = get(Hlines(2),'UserData');
runNum = S.runNum;
swpnum = S.swpNum;
dataStruct = S.(['Run' num2str(runNum, '%.4d')]); 
maxswp = getmaxswp(dataStruct);

% Act according to the submenu selected

if strcmp(submenu,'back')	
    if (swpnum > 1) 
        swpnum = swpnum - 1;
    end
end

if strcmp(submenu,'jump')	
    swpnum=0;
    while (swpnum < 1) || (swpnum > maxswp)
        s = ['Enter Sweep Number (Max ' num2str(maxswp) '): '];
        swpnum = input(s);
    end
end

if strcmp(submenu,'next')	
    if (swpnum < maxswp) 
        swpnum = swpnum + 1;
    end
end

if strcmp(submenu,'skip')	
    if (swpnum + 2 < maxswp) 
        swpnum = swpnum + 2;
    end
end

S.swpNum = swpnum;
infoUpdate = 0;

plotswp(S, S.runNum, S.swpNum, infoUpdate);

% global mCDI
% if mCDI.flag == 1;
%     manualCDI_zsl(3);    
% end