function newrun(submenu)

%%
%%	NEWRUN.M	Allows Selection of a New Run in most recent datafile
%%
%%

FInfo = get(gcf,'UserData');
% FInfo.HGUI = HGUI;
Hlines = FInfo.Hlines;
% FInfo.Hdel = Hdel;

S = get(Hlines(2),'UserData');
rnum = S.runNum;
rnum_max = S.maxrun;


if strcmp(submenu,'back')	
	if (rnum > 1) 
		rnum = rnum - 1;
	end
end

if strcmp(submenu,'jump')	
	rnum=0;
	while (rnum < 1) || (rnum > rnum_max) 		
		s = ['Enter Run Number (Max ' num2str(rnum_max) '): '];
		rnum = input(s);
	end
end

if strcmp(submenu,'next')	
    if rnum < rnum_max 
        rnum = rnum + 1;
    end
end



% Set pointer to first sweep
S.runNum = rnum;
S.swpNum = 1;
infoUpdate = 1;

plotswp(S, S.runNum, S.swpNum, infoUpdate);

% getheader_zsl();
% global mCDI
% if mCDI.flag == 1;
%     manualCDI_zsl(3);    
% end