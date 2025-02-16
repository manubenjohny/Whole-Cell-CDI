function setupGUInew(rawDataFolders,matDataFolders)
%%	was WCINIT.M



%%	Create A Figure
HFmain=figure('Name', 'Whole Cell Analysis Program', ...
            'NumberTitle', 'off', ...
            'Units', 'normal',...
            'Position', [.01 .33 .66 .60],... % 'UserData', zeros(4,30),...
            'keypressfcn',@keystroke);			% FInfo (Has Handle Info and Sweep Info)

setappdata(0, 'HFmain', HFmain)


%% 	Setup Main Menus


%HMnull= uimenu('Label','<-Run','Visible','on','Callback','newrun(''back'')');
%HMnull= uimenu('Label','Run->','Visible','on','Callback','newrun(''next'')');
HGUI.HMnull= uimenu('Label','--->','Visible','on','Callback','');
HGUI.HMnew= uimenu('Label','&New');
HGUI.HMdisplay= uimenu('Label','Display');
HGUI.HMtools= uimenu('Label','Tools');
% HGUI.HMprint= uimenu('Label','Print','Callback','dumpfig');



%%	Secondary and Tertiary Menus


HGUI.HMnewfig = uimenu(HGUI.HMnew,'Label','New &Window','Callback','wcezstart'); %wcinit
% HGUI.HMnewfile = uimenu(HGUI.HMnew,'Label','New &File','Callback','newfile');
% HGUI.HMnewrun = uimenu(HGUI.HMnew,'Label','New &Run');
% 
% HGUI.HMnewrun1 = uimenu(HGUI.HMnewrun,'Label','Back','Callback','newrun(''back'')');
% HGUI.HMnewrun2 = uimenu(HGUI.HMnewrun,'Label','Jump','Callback','newrun(''jump'')');
% HGUI.HMnewrun3 = uimenu(HGUI.HMnewrun,'Label','Next','Callback','newrun(''next'')');

HGUI.HMzero = uimenu(HGUI.HMdisplay,'Label','Set Zero','Callback','SetZero(''menu'')','Checked','off');
HGUI.HMleak = uimenu(HGUI.HMdisplay,'Label','Leak Subtract','Callback','Mtoggle(''leak'')','Checked','off');
HGUI.HMleakfit = uimenu(HGUI.HMdisplay,'Label','LeakFit Subtract','Callback','Mtoggle(''leakfit'')','Checked','off');

HGUI.HMinfo = uimenu(HGUI.HMdisplay,'Label','Pulse Info','Callback','Mtoggle(''info'')','Checked','on');
HGUI.HMlock = uimenu(HGUI.HMdisplay,'Label','Lock Axes','Callback','Mtoggle(''lock'')','Checked','off');

% HGUI.HMiso = uimenu(HGUI.HMtools,'Label','Isochronal','Callback','isotool(''menu'')','Checked','off','UserData', zeros(10,6));
% HGUI.HMexp = uimenu(HGUI.HMtools,'Label','Exp Fit','Callback','exptool(''menu'')','Checked','off');
HGUI.HMfilt = uimenu(HGUI.HMtools,'Label','LoPass Filter','Callback','lopass');
HGUI.HMasc = uimenu(HGUI.HMtools,'Label','ASCII Dump','Callback','ascdump');
HGUI.HMorgZdata = uimenu(HGUI.HMtools,'Label','organizeRawZData','Callback','organizeRawZData');
HGUI.HMorgEdata = uimenu(HGUI.HMtools,'Label','organizeRawEData','Callback','organizeRawEData');
HGUI.HMBara = uimenu(HGUI.HMtools,'Label','----------------');
HGUI.HMCopyRun = uimenu(HGUI.HMtools,'Label','Copy Run 2 Excel','Callback','copyCurRun');



%% 	Textual Information

HGUI.HTW1 = uicontrol('Style','edit',...
			'Units','normalized',...
			'Position',[0 .93 .2 .07],...
			'Max', 2,...
			'BackGroundColor',[0 0 .5],...
			'ForeGroundColor',[1 1 0],...			
			'Visible','off');

HGUI.HTW2 = uicontrol('Style','edit',...
			'Units','normalized',...
			'Position',[.2 .93 .2 .07],...
			'Max', 2,...
			'BackGroundColor',[0 0 .5],...
			'ForeGroundColor',[1 1 0],...			
			'Visible','off');
      

HGUI.HTW3 = uicontrol('Style','edit',...
            'Tag','ClampProperties',...
			'Units','normalized',...
			'Position',[.2 .86 .2 .07],...
			'Max', 2,...
			'BackGroundColor',[0 0 .5],...
			'ForeGroundColor',[1 1 0],...			
			'Visible','on');
        
        
HGUI.HTW4 = uicontrol('Style','edit',...
             'Tag','Sweep Notes',...
			'Units','normalized',...
			'Position',[0 .86 .2 .07],...
			'Max', 2,...
			'BackGroundColor',[0 0 .5],...
			'ForeGroundColor',[1 1 0],...			
			'Visible','on');
        
      
      

%%	Buttons


% Set Zero
HGUI.HBzero = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.40 .95 .1 .05],...
			'Callback','SetZero(''button'')',...
			'String','Zero',...
			'HorizontalAlignment','center',...
			'UserData',[0 0 0 0],...
			'Visible','on');
        
% Horizontal Line
HGUI.HBline = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.50 .95 .1 .05],...
			'Callback','ltool',...
			'String','H-Line',...
			'HorizontalAlignment','center');

        
        
              

%%%% unimplemented buttons:        
HGUI.HBreplotCDI = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.40 .9 .1 .05],...
			'Callback','replotCDI',...
			'String','replotCDI',...
			'HorizontalAlignment','center',...
			'UserData',[0 0 0 0],...
			'Visible','on');
        
HGUI.HBjetPlotRun = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.5 .9 .1 .05],...
			'Callback','jetPlotRun',...
			'String','jetPlotRun',...
			'HorizontalAlignment','center',...
			'UserData',[0 0 0 0],...
			'Visible','on');
        
 
        
HGUI.textfcutoff = uicontrol('Style','text', ...
			'Units','normalized',...
			'Position',[.40 .86 .05 .03],...
			'String','fcutoff',...
			'HorizontalAlignment','center',...
            'BackgroundColor',ones(1,3)*0.8,...
			'UserData',[0 0 0 0],...
			'Visible','on');

HGUI.editfcutoff = uicontrol('Style','edit', ...
			'Units','normalized',...
			'Position',[.45 .855 .05 .04],...
			'String','2000',...
            'Callback','getfcutoff()',...
			'HorizontalAlignment','center',...
			'UserData',[0 0 0 0],...
			'Visible','on');  

% Expand Axes
HGUI.HBexpandx = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.60 .95 .1 .05],...
			'Callback','expandx',...
			'String','Exp-X',...
			'HorizontalAlignment','center',...
			'UserData',0);

HGUI.HBexpandy = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.60 .90 .1 .05],...
			'Callback','expandy',...
			'String','Exp-Y',...
			'HorizontalAlignment','center',...
			'UserData',0);

% Run and Sweep Advance

HGUI.HBrunback = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.7 .95 .1 .05],...
			'Callback','newrun(''back'')',...
			'String','<--',...
			'HorizontalAlignment','center');

HGUI.HBrunjump = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.8 .95 .1 .05],...
			'Callback','newrun(''jump'')',...
			'String','Run',...
			'HorizontalAlignment','center');

HGUI.HBrunnext = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.9 .95 .1 .05],...
			'Callback','newrun(''next'')',...
			'String','-->',...
			'HorizontalAlignment','center');

HGUI.HBback = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.7 .90 .1 .05],...
			'Callback','newswp(''back'')',...
			'String','<--',...
			'HorizontalAlignment','center');

HGUI.HBjump = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.8 .90 .1 .05],...
			'Callback','newswp(''jump'')',...
			'String','Sweep',...
			'HorizontalAlignment','center');

HGUI.HBnext = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.9 .90 .1 .05],...
			'Callback','newswp(''next'')',...
			'String','-->',...
			'HorizontalAlignment','center');

HGUI.HBskip = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.9 .85 .1 .05],...
			'Callback','newswp(''skip'')',...
			'String','Skip',...
			'HorizontalAlignment','center');

% Saving Sweeps

HGUI.HBkeep = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.9 .80 .1 .05],...
			'Callback','holdswp(''keep'')',...
			'String','Keep',...
			'HorizontalAlignment','center');

HGUI.HBwipe = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.9 .75 .1 .05],...
			'Callback','holdswp(''wipe'')',...
			'String','Wipe',...
			'HorizontalAlignment','center');




HGUI.HBheader = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .65 .1 .05],...
			'Callback','getheader();',...
			'String','Copy Header',...
			'HorizontalAlignment','center');
        
HGUI.HBeditInfo = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .6 .1 .05],...
			'Callback','editinfo',...
			'String','edit Info',...
			'HorizontalAlignment','center',...
			'UserData',[0 0 0 0],...
			'Visible','on');          

HGUI.textCDIpara = uicontrol('Style','text', ...
			'Units','normalized',...
			'Position',[.9 .55 .1 .03],...
            'BackgroundColor',ones(1,3)*0.8,...
			'String','time stamp for CDI calc',...
			'HorizontalAlignment','center',...
			'UserData',[0 0 0 0],...
			'Visible','on');
        
HGUI.editCDIpara = uicontrol('Style','edit', ...
			'Units','normalized',...
			'Position',[.9 .5 .1 .05],...
            'Callback','getxxx()',...
			'String','50, 100, 300',...
			'HorizontalAlignment','center',...
			'UserData',[0 0 0 0],...
			'Visible','on');
        
        
HGUI.HBIVcalc = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .45 .1 .05],...
			'Callback','wcivcalrun()',...
			'String','family CDI',...
			'HorizontalAlignment','center');

                        
HGUI.HBcdi = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.9 .4 .1 .05],...
			'Callback','computeCDI;',...
			'String','Compute CDI',...
			'HorizontalAlignment','center',...
			'UserData',[0 0 0 0],...
			'Visible','on');     
        
HGUI.HBpickCDI = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .35 .1 .05],...
			'Callback','pickCDI;',...
			'String','manual pick CDI',...
			'HorizontalAlignment','center',...
             'BackgroundColor',[1 0.7 0.7]);
        
HGUI.textCDI = uicontrol('Style','text', ...
			'Units','normalized',...
			'Position',[.9 .29 .07 .06],...
			'String','',...
			'HorizontalAlignment','center',...
			'UserData',[0 0 0 0],...
			'Visible','on');

                
HGUI.HBCDIDel = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.97 .29 .03 .06],...
            'Callback','delCDI()',...
			'String','Del',...
			'HorizontalAlignment','center',...
             'BackgroundColor',[1 0.7 0.7]);  
         
HGUI.HBLkFit = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.90 .24 .1 .05],...
			'Callback','LeakFit();',...
			'String','Leak Fit',...
			'HorizontalAlignment','center',...
            'BackgroundColor',[0.7 0.9 1]);


HGUI.textLkFit = uicontrol('Style','text', ...
			'Units','normalized',...
			'Position',[.90 .18 .07 .06],...
			'String','',...
			'HorizontalAlignment','center');
        
HGUI.HBLkDel = uicontrol('Style','pushbutton', ...
			'Units','normalized',...
			'Position',[.97 .18 .03 .06],...
            'Callback','delleak()',...
			'String','Del',...
			'HorizontalAlignment','center',...
             'BackgroundColor',[0.7 0.9 1]);        
               
HGUI.HBQTail = uicontrol('Style','pushbutton',...
            'Units','normalized',...
            'Position',[.90 .13 .1 .05],...
            'Callback','Qtail()',...
            'String','Qtail',...
            'HorizontalAlignment','center');

HGUI.HBQpick = uicontrol('Style','pushbutton',...
            'Units','normalized',...
            'Position',[.90 .09 .05 .04],...
            'Callback','pickQ()',...
            'String','pickQ',...
            'BackGroundColor',[.7 1 .7],...
            'HorizontalAlignment','center');        
HGUI.HBTailpick = uicontrol('Style','pushbutton',...
            'Units','normalized',...
            'Position',[.95 .09 .05 .04],...
            'Callback','pickTail()',...
            'String','pickTail',...
            'BackGroundColor',[.7 1 .7],...
            'HorizontalAlignment','center');           
                        
HGUI.textQTail = uicontrol('Style','text',...
            'Units','normalized',...
            'Position',[.90 .03 .07 .06],...
            'String','',...
            'ForeGroundColor',[1 0 0],...
            'HorizontalAlignment','center'); 
        
HGUI.HBQTailDel = uicontrol('Style','pushbutton',...
            'Units','normalized',...
            'Position',[.97 .03 .03 .06],...
             'Callback','delQtail()',...
            'String','Del',...
            'HorizontalAlignment','center',...
            'BackGroundColor',[.7 1 .7]);         
%%        
HGUI.Hlistbox = uicontrol('Style','listbox', ...
			'Units','normalized',...
			'Position',[0 .05 .13 .8],...
			'Callback','NEWFILE_LBox',...
			'HorizontalAlignment','center',...
            'Visible','off');
        

HGUI.Hopendir = uicontrol('style','pushbutton', ... 
                'Units', 'normalized', ...
                'Position',[0 0 .13 .05], ...
                'String', 'Switch to Edata', ...
                'Callback','switchdatafolder');

                

HGUI.Hinfobar = uicontrol('style','text','Units','normalized',...
			'Position',[.135 0 .9 .03],'string','No File Loaded','fontsize',9,'fontweight','bold','HorizontalAlignment','left','BackgroundColor','yellow');        
        

%%	Set Up Axis

HGUI.Haxis = axes('Box','on',...
		'Position', [.17 .07 .69 .78]);
		

%%
%%	Update the Figure Information
%%

Hlines = zeros(1,30);
% Hdel = zeros(1,30);

FInfo.HGUI = HGUI;
FInfo.Hlines = Hlines;
% FInfo.Hdel = Hdel;

FInfo.rawDataFolders = rawDataFolders;
FInfo.matDataFolders = matDataFolders;
FInfo.matDataFolderSel = 1;
% matDataFolder = matDataFolders{matDataFolderSel};




set(HFmain,'UserData', FInfo);				% Write to UserData



getdatafolder()
getxxx()
try
    NEWFILE_LBox()
catch
end


%% removed buttons
% Isochronal Tool

% HGUI.HBisoWin = uicontrol('Style','pushbutton', ...
% 			'Units','normalized',...
% 			'Position',[.90 .55 .1 .05],...
% 			'Callback','',...
% 			'String','Windows',...
% 			'HorizontalAlignment','center',...
% 			'Visible','off');
% 
% HGUI.HBisoCon = uicontrol('Style','pushbutton', ...
% 			'Units','normalized',...
% 			'Position',[.90 .50 .1 .05],...
% 			'Callback','',...
% 			'String','Pk: Pulse',...
% 			'HorizontalAlignment','center',...
% 			'Visible','off',...
% 			'UserData','1');
% 
% HGUI.HBisoInc = uicontrol('Style','pushbutton', ...
% 			'Units','normalized',...
% 			'Position',[.90 .45 .1 .05],...
% 			'Callback','',...
% 			'String','Increment',...
% 			'HorizontalAlignment','center',...
% 			'Visible','off');
% 
% HGUI.HBisoReset = uicontrol('Style','pushbutton', ...
% 			'Units','normalized',...
% 			'Position',[.90 .40 .1 .05],...
% 			'Callback','',...
% 			'String','Reset',...
% 			'HorizontalAlignment','center',...
% 			'UserData',zeros(10,3),...
% 			'Visible','off');
% Averaging buttons

% HGUI.HBavg1 = uicontrol('Style','pushbutton', ...
% 			'Units','normalized',...
% 			'Position',[.90 .70 .1 .05],...
% 			'Callback','average(''avg1'')',...
% 			'String','avg1',...
% 			'HorizontalAlignment','center',...
% 			'UserData',[0 0 0 0]);
% HGUI.HBavg1T = uicontrol('Style','pushbutton', ...
% 			'Units','normalized',...
% 			'Position',[.9 .65 .1 .05],...
% 			'Callback','plotavg1',...
% 			'String','Trsfr avg1',...
% 			'HorizontalAlignment','center');
% HGUI.HBavgclear = uicontrol('Style','pushbutton', ...
% 			'Units','normalized',...
% 			'Position',[.90 .60 .1 .05],...
% 			'Callback','average(''avgclear'')',...
% 			'String','clravg',...
% 			'HorizontalAlignment','center');

% Add button for getting comments in run        
        
% HGUI.HBgetinfo = uicontrol('Style','pushbutton', ...
%             'Units','normalized',...
%             'Position',[.50 .90 .1 .05],...
%             'Callback','getinfo2(''info'')',...
%             'String','getinfo2',...
%             'HorizontalAlignment','center');

% Default Values for windows and increments
		%very complicated, set these for
                                    %default usage.
% A = zeros(10,6);			%[pulse number of window  start(msw/i pulse) stop(ms w/i pulse) incP incStart incStop]
% A(1,:) = [2  1  10 0 0 0];
% A(2,:) = [2  49  51 0 0 0];
% A(3,:) = [2  99  101 0 0 0];
% A(4,:) = [2  295 299 0 0 0];
% set(HGUI.HMiso,'UserData',A);
% set(HGUI.HBisoReset,'UserData',A(:,1:3));


% Exponential Fitting Tool

% HGUI.HMexp1 = uicontrol('Style','popup', ...
% 			'Units','normalized',...
% 			'Position',[.90 .50 .1 .05],...
% 			'String','1SED|1SEO|1DED|1DFT|2DED|2DFT|1SAR|Model',...
% 			'Callback','',...
% 			'HorizontalAlignment','center',...
% 			'Visible','off');
% 
% HGUI.HBexp2 = uicontrol('Style','pushbutton', ...
% 			'Units','normalized',...
% 			'Position',[.90 .45 .1 .05],...
% 			'Callback','',...
% 			'String','Wipe Fits',...
% 			'HorizontalAlignment','center',...
% 			'Visible','off');
% uicontrol('style','text', 'Units','normalized','Position',[0 .88 .13 .025],'string', 'Data ... ','BackgroundColor',[0 0 .5],'ForeGroundColor',[1 1 0]);
% HDirFilter = uicontrol('style','edit','Callback',@getdatafolder, 'Units','normalized','Position',[0 .85 .13 .03],'string', '');


%%	FInfo:	Row 1: Handles for GUI 		[HMzero HMleaks HMinfo ...]
%%		Row 2: Handles for Line Objects [(Total #) (Current) H1 H2 H3 ...]
%%		Row 3: Handles for Fits to Line Objects
%%		Row 4: Handles for Temporary Stuff

% Put Appropriate Handles for GUI into Figure UserData

% HGUI = [HMzero		HMleak		HMinfo		HBzero		HTW1 ...
%         HTW2 		HMlock		HMiso		HBisoInc	HBisoReset ...
%     	HBisoWin	HMexp		HMexp1		HBexp2		HBexpandx ...
%     	HBexpandy	HBisoCon	HMavg1		HMavgclear	HMavg1T ...
%         Hlistbox    Hinfobar    HBcdi       Haxis       HDirFilter];

% FInfo = get(HFmain,'UserData');				% Get UserData Matrix 