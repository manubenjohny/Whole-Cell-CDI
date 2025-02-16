function setupGUI(matDataFolder)

%%
%%	was WCINIT.M
%%
%%	Initialize New Figure with GUI and UserData (FInfo)
%%
%%

% global HFmain mCDI;
% % MBJ --> searched through and edited out all gcf (at a single level) and replaced it w/ HFmain so
% % that one could hack ivcalc in wcviewer provided we know what the current file is
% clear global mCDI


%%	Create A Figure


HFmain=figure('Name','Whole Cell Analysis Program', ...
            'NumberTitle', 'off', ...
            'Units', 'normal',...
            'Position', [.01 .33 .66 .60],...
            'UserData', zeros(4,30),...
            'keypressfcn',@(obj, evd) keystroke(obj, evd));			% FInfo (Has Handle Info and Sweep Info)




%% 	Setup Main Menus


%HMnull= uimenu('Label','<-Run','Visible','on','Callback','newrun(''back'')');
%HMnull= uimenu('Label','Run->','Visible','on','Callback','newrun(''next'')');
HMnull= uimenu('Label','--->','Visible','on','Callback','');
HMnew= uimenu('Label','&New');
HMdisplay= uimenu('Label','Display');
HMtools= uimenu('Label','Tools');
HMprint= uimenu('Label','Print','Callback','dumpfig');



%%	Secondary and Tertiary Menus


HMnewfig=uimenu(HMnew,'Label','New &Window','Callback','wcinit');
HMnewfile=uimenu(HMnew,'Label','New &File','Callback','newfile');
HMnewrun=uimenu(HMnew,'Label','New &Run');

HMnewrun1=uimenu(HMnewrun,'Label','Back','Callback','newrun(''back'')');
HMnewrun2=uimenu(HMnewrun,'Label','Jump','Callback','newrun(''jump'')');
HMnewrun3=uimenu(HMnewrun,'Label','Next','Callback','newrun(''next'')');

HMzero= uimenu(HMdisplay,'Label','Set Zero','Callback','SetZero(''menu'')','Checked','on');
HMleak=	uimenu(HMdisplay,'Label','Leak Subtract','Callback','Mtoggle(2)','Checked','on');
% HMleakfit=	uimenu(HMdisplay,'Label','Leak Subtract','Callback','Mtoggle(3)','Checked','on');

HMinfo=	uimenu(HMdisplay,'Label','Pulse Info','Callback','Mtoggle(4)','Checked','on');
HMlock=	uimenu(HMdisplay,'Label','Lock Axes','Callback','Mtoggle(7)','Checked','off');

HMiso=	uimenu(HMtools,'Label','Isochronal','Callback','isotool(''menu'')','Checked','off','UserData', zeros(10,6));
HMexp=	uimenu(HMtools,'Label','Exp Fit','Callback','exptool(''menu'')','Checked','off');
HMfilt=	uimenu(HMtools,'Label','LoPass Filter','Callback','lopass');
HMasc=	uimenu(HMtools,'Label','ASCII Dump','Callback','ascdump');


%% 	Textual Information

HTW1= uicontrol('Style','edit',...
			'Units','normalized',...
			'Position',[0 .93 .2 .07],...
			'Max', 2,...
			'BackGroundColor',[0 0 .5],...
			'ForeGroundColor',[1 1 0],...			
			'Visible','off');

HTW2= uicontrol('Style','edit',...
			'Units','normalized',...
			'Position',[.2 .93 .2 .07],...
			'Max', 2,...
			'BackGroundColor',[0 0 .5],...
			'ForeGroundColor',[1 1 0],...			
			'Visible','off');
      

HTW3= uicontrol('Style','edit',...
            'Tag','ClampProperties',...
			'Units','normalized',...
			'Position',[.2 .86 .2 .07],...
			'Max', 2,...
			'BackGroundColor',[0 0 .5],...
			'ForeGroundColor',[1 1 0],...			
			'Visible','on');
      
      

%%	Buttons


% Set Zero

HBzero=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.40 .95 .1 .05],...
			'Callback','SetZero(''button'')',...
			'String','Zero',...
			'HorizontalAlignment','center',...
			'UserData',[0 0 0 0],...
			'Visible','on');
        
HBcdi=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.40 .9 .1 .05],...
			'Callback','manualCDI(2);',...
			'String','Compute Ratio',...
			'HorizontalAlignment','center',...
			'UserData',[0 0 0 0],...
			'Visible','on');        

% Horizontal Line

HBline=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.50 .95 .1 .05],...
			'Callback','ltool',...
			'String','H-Line',...
			'HorizontalAlignment','center');

% Expand Axes

HBexpandx=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.60 .95 .1 .05],...
			'Callback','expandx',...
			'String','Exp-X',...
			'HorizontalAlignment','center',...
			'UserData',[0]);

HBexpandy=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.60 .90 .1 .05],...
			'Callback','expandy',...
			'String','Exp-Y',...
			'HorizontalAlignment','center',...
			'UserData',[0]);

% Run and Sweep Advance

HBrunback=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.7 .95 .1 .05],...
			'Callback','newrun(''back'')',...
			'String','<--',...
			'HorizontalAlignment','center');

HBrunjump=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.8 .95 .1 .05],...
			'Callback','newrun(''jump'')',...
			'String','Run',...
			'HorizontalAlignment','center');

HBrunnext=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.9 .95 .1 .05],...
			'Callback','newrun(''next'')',...
			'String','-->',...
			'HorizontalAlignment','center');

HBback=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.7 .90 .1 .05],...
			'Callback','newswp(''back'')',...
			'String','<--',...
			'HorizontalAlignment','center');

HBjump=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.8 .90 .1 .05],...
			'Callback','newswp(''jump'')',...
			'String','Sweep',...
			'HorizontalAlignment','center');

HBnext=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.9 .90 .1 .05],...
			'Callback','newswp(''next'')',...
			'String','-->',...
			'HorizontalAlignment','center');

HBskip=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.9 .85 .1 .05],...
			'Callback','newswp(''skip'')',...
			'String','Skip',...
			'HorizontalAlignment','center');

% Saving Sweeps

HBkeep=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.9 .80 .1 .05],...
			'Callback','holdswp(''keep'')',...
			'String','Keep',...
			'HorizontalAlignment','center');

HBwipe=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.9 .75 .1 .05],...
			'Callback','holdswp(''wipe'')',...
			'String','Wipe',...
			'HorizontalAlignment','center');


% Isochronal Tool

HBisoWin=uicontrol(	'Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .55 .1 .05],...
			'Callback','',...
			'String','Windows',...
			'HorizontalAlignment','center',...
			'Visible','off');

HBisoCon=uicontrol(	'Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .50 .1 .05],...
			'Callback','',...
			'String','Pk: Pulse',...
			'HorizontalAlignment','center',...
			'Visible','off',...
			'UserData','1');

HBisoInc=uicontrol(	'Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .45 .1 .05],...
			'Callback','',...
			'String','Increment',...
			'HorizontalAlignment','center',...
			'Visible','off');

HBisoReset=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .40 .1 .05],...
			'Callback','',...
			'String','Reset',...
			'HorizontalAlignment','center',...
			'UserData',zeros(10,3),...
			'Visible','off');
% Averaging buttons

HMavg1 = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .70 .1 .05],...
			'Callback','average(''avg1'')',...
			'String','avg1',...
			'HorizontalAlignment','center',...
			'UserData',[0 0 0 0]);
HMavg1T = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.9 .65 .1 .05],...
			'Callback','plotavg1',...
			'String','Trsfr avg1',...
			'HorizontalAlignment','center');
HMavgclear = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .60 .1 .05],...
			'Callback','average(''avgclear'')',...
			'String','clravg',...
			'HorizontalAlignment','center');

% Add button for getting comments in run        
        
HMgetinfo = uicontrol('Style','pushbutton', ...
            'Units','normalized',...
            'Position',[.50 .90 .1 .05],...
            'Callback','getinfo2(''info'')',...
            'String','getinfo2',...
            'HorizontalAlignment','center');

HMheader = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .35 .1 .05],...
			'Callback','getheader();',...
			'String','Copy Header',...
			'HorizontalAlignment','center');

HMIVcalc = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .3 .1 .05],...
			'Callback','wcivcal300()',...
			'String','IVCalc',...
			'HorizontalAlignment','center');

        
HMChangeCDI = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .25 .1 .05],...
			'Callback','manualCDI();',...
			'String','ChangeRatio',...
			'HorizontalAlignment','center');

HMLkFit = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .2 .1 .05],...
			'Callback','LeakFit();',...
			'String','Leak Fit',...
			'HorizontalAlignment','center');
       
Hlistbox = uicontrol('Style','listbox', ...
			'Units','normalized',...
			'Position',[0 .05 .13 .8],...
			'Callback',{@NEWFILE_LBox,matDataFolder},...
			'HorizontalAlignment','center');
        
uicontrol('style','text', 'Units','normalized','Position',[0 .88 .13 .025],'string', 'Data ... ','BackgroundColor',[0 0 .5],'ForeGroundColor',[1 1 0]);
HDirFilter = uicontrol('style','edit','Callback',@getdatafolder, 'Units','normalized','Position',[0 .85 .13 .03],'string', '');

Hopendir = uicontrol('style','pushbutton', ... 
                    'Units', 'normalized', ...
                    'Position',[0,0,.13,.05], ...
                    'String', 'Open Data Folder', ...
                    'Callback','getdatafolder');
                
                
% Default Values for windows and increments
		%very complicated, set these for
                                    %default usage.
		A = zeros(10,6);			%[pulse number of window  start(msw/i pulse) stop(ms w/i pulse) incP incStart incStop]
		A(1,:) = [2  1  10 0 0 0];
		A(2,:) = [2  49  51 0 0 0];
		A(3,:) = [2  99  101 0 0 0];
		A(4,:) = [2  295 299 0 0 0];
		set(HMiso,'UserData',A);
		set(HBisoReset,'UserData',A(:,1:3));


% Exponential Fitting Tool

HMexp1=uicontrol('Style','popup', ...
			'Units','normalized',...
			'Position',[.90 .50 .1 .05],...
			'String','1SED|1SEO|1DED|1DFT|2DED|2DFT|1SAR|Model',...
			'Callback','',...
			'HorizontalAlignment','center',...
			'Visible','off');

HBexp2=uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .45 .1 .05],...
			'Callback','',...
			'String','Wipe Fits',...
			'HorizontalAlignment','center',...
			'Visible','off');
Hinfobar = uicontrol('style','text','Units','normalized',...
			'Position',[.135 0 .9 .03],'string','No File Loaded','fontsize',9,'fontweight','bold','HorizontalAlignment','left','BackgroundColor','yellow');        
        

%%	Set Up Axis



Haxis = axes('Box','on',...
		'Position', [.17 .07 .69 .78]);
		

%%
%%	Update the Figure Information
%%
%%	FInfo:	Row 1: Handles for GUI 		[HMzero HMleaks HMinfo ...]
%%		Row 2: Handles for Line Objects [(Total #) (Current) H1 H2 H3 ...]
%%		Row 3: Handles for Fits to Line Objects
%%		Row 4: Handles for Temporary Stuff

% Put Appropriate Handles for GUI into Figure UserData

HGUI = [HMzero		HMleak		HMinfo		HBzero		HTW1 ...
        HTW2 		HMlock		HMiso		HBisoInc	HBisoReset ...
    	HBisoWin	HMexp		HMexp1		HBexp2		HBexpandx ...
    	HBexpandy	HBisoCon	HMavg1		HMavgclear	HMavg1T ...
        Hlistbox    Hinfobar    HBcdi       Haxis       HDirFilter];

FInfo = get(gcf,'UserData');				% Get UserData Matrix 
FInfo(1,1:length(HGUI)) = HGUI;
set(HFmain,'UserData', FInfo);				% Write to UserData


% 
% global userdatafolder mCDI
% mCDI.flag = 0;

getdatafolder(matDataFolder)
NEWFILE_LBox(gcf,FInfo,matDataFolder)



