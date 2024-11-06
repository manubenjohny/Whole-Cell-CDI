function plotswp(S,runNum,swpNum, infoUpdate)
%% example of input arguments
% matfile = 'C:\Users\Lingjie\Documents\labwork\DATA\patch_data\edata\edata_mat\e15_ljs.mat';
% clearvars S;
% load(matfile,'S')
% 
% 
% runNum = 1;
% swpNum = 1;
% infoUpdate = 1; % set to 1 when change S or runNum, 0 when only change swpNum
% 


%% get figure information and refresh screen

HFmain = getappdata(0, 'HFmain');

FInfo = get(HFmain,'UserData');

HGUI = 	 FInfo.HGUI;			% GUI Handles
 
Hlines = FInfo.Hlines;			% Line Handles

% Hdel = 	 FInfo.Hdel;			% Objects to Delete for Refresh
% 
% if (Hdel(1) ~= 0)
%     delete(nonzeros(Hdel(2:length(Hdel))));
% end
% 
% Hdel = zeros(size(Hdel));	

%% read data from structure S

% grab the run data 
dataStruct = S.(['Run' num2str(runNum, '%.4d')]); 
% grab some parameters used in the calculation in this function 
% the names of there parameters were derived from old convention 
PV = zeros(1,8);
PV(1:4) = dataStruct.StimParams.Vstep;
PV(5:8) = dataStruct.StimParams.Dstep;
NI = dataStruct.StimParams.NI;
PR = dataStruct.StimParams.PR;
PF = dataStruct.StimParams.PF;
I = 1e6/dataStruct.StimParams.SampleHz;


%% now we grab sweep data
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));
ST = dataStruct.StimParams.ST;
if ST == 1
    xdata = dataStruct.(swpstr).voltage; 
else
    xdata = dataStruct.(swpstr).time;
end

pAtrace = dataStruct.(swpstr).pAtrace;
pAleak = dataStruct.(swpstr).pAleak;

leakFitFlag = 1; % did leak fit for this trace already
try
    pAleakfit = dataStruct.(swpstr).pAleakfit;
catch
    pAleakfit = dataStruct.(swpstr).pAleak;
    leakFitFlag = 0; % have not done leak fit yet!
end

% put something in the GUI indicate whether leakFitFlag = 0 or 1 !!!

if leakFitFlag == 1
    set(HGUI.textLkFit,'String','Did leak fit on this trace before',...			
		'ForeGroundColor',[0 0.5 0])
else
    set(HGUI.textLkFit,'String','No leak fit for this trace',...
        'ForeGroundColor',[1 0 0])

end


if isfield(dataStruct.(swpstr),'mCDI')
    set(HGUI.textCDI,'String','has manual CDI picked',...
		'ForeGroundColor',[0 0.5 0])
else
    set(HGUI.textCDI,'String','no manual CDI picked',...
        'ForeGroundColor',[1 0 0])
end

if isfield(dataStruct.(swpstr),'Qtail')
    if isfield(dataStruct.(swpstr).Qtail,'Q') && isfield(dataStruct.(swpstr).Qtail,'pAtail')
         set(HGUI.textQTail,'String','has manual Qtail picked',...
        'ForeGroundColor',[0 0.5 0])
    elseif isfield(dataStruct.(swpstr).Qtail,'Q') 
        set(HGUI.textQTail,'String','has manual Q picked',...
        'ForeGroundColor',[0 0.5 0])
    elseif isfield(dataStruct.(swpstr).Qtail,'pAtail')
        set(HGUI.textQTail,'String','has manual tail picked',...
        'ForeGroundColor',[0 0.5 0])
    end
else
    set(HGUI.textQTail,'String','no manual QTail picked',...
        'ForeGroundColor',[1 0 0])
end
%% read user setting and prepare for plot

if getFLAG('leakfit')
    ydata = pAtrace - pAleakfit;
elseif getFLAG('leak')		% if it is a ramp and we want leak subtr
    ydata = pAtrace - pAleak;
else
    ydata = pAtrace;
end

if getFLAG('zero')				% Check Flag and Zero Start of Pulse
	HBzero= HGUI.HBzero;
	zeroL = get(HBzero,'UserData');		% zero range stored in userdata of zero button
	zeroL(1:2)=round(zeroL(1:2)*1000/I);

	if zeroL(2)==0
		ydata=ydata-mean(ydata(1:PR));
	else
		ydata=ydata-mean(ydata(zeroL(1):zeroL(2)));
	end
end


if getFLAG('lock')
	set(gca,'XLimMode','manual','YLimMode','manual');
else
	set(gca,'XLimMode','auto','YLimMode','auto');
end


%% now start to plot
% filter ydata
fcutoff = FInfo.fcutoff;
if ST ~=1 && fcutoff ~= 0
    ydata = filt2(xdata, ydata, fcutoff);
end
if Hlines(2) ~= 0
    delete(Hlines(2))
end
Hlines(2) = line(xdata, ydata);

if ~getFLAG('lock')
	if ST == 1					% if it is a ramp
		xlimits = get(gca,'Xlim');
		xlimits(1) = dataStruct.StimParams.Vramp(1);
		xlimits(2) = dataStruct.StimParams.Vramp(2);
		set(gca,'Xlim',sort(xlimits));
	else
		xlimits = get(gca,'Xlim');
		xlimits(1) = round(-(PR+PF)*I/1000);
		xlimits(2) = sum(PV(5:8));
		set(gca,'Xlim',xlimits);
	end
end





%% Put Information into the Two Text Boxes for current trace (HTW1 and HTW2)

% We can use dataStruct.StimParams and dataStruct.DBPramas to grab
% necessary information

% always update these information
HTW1 = HGUI.HTW1;
HTW2 = HGUI.HTW2;

HTW1str = ['Run: ', num2str(runNum), '  ' ...
           'Swp: ', num2str(swpNum),  '  '...
           '(',     num2str(dataStruct.(swpstr).FvarValue), ')'];
set(HTW1,'String', HTW1str,	'Visible', 'on');

PV(NI-3) = dataStruct.(swpstr).FvarValue;
HTW2str = sprintf('V: %4d %4d %4d %d\nD: %4d %4d %4d %4d', PV);
if getFLAG('info')
    set(HTW2, 'String',	HTW2str,'Visible','on');
else
    set(HTW2, 'String','','Visible','off');
end



    
% only update these information when chaning runs or files    
if infoUpdate == 1
    clampPropStr = sprintf('C: %.1f pF      Rs: %.1f Mohm\nComp: %.2g%%   Cell No: %d   RI: %ds',...
    dataStruct.DBParams.Cm, dataStruct.DBParams.Rs,...
    dataStruct.DBParams.Comp,dataStruct.DBParams.CellNum,...
    dataStruct.StimParams.RI);

    HTW3 = HGUI.HTW3;
    set(HTW3,'String',clampPropStr);

    HTW4 = HGUI.HTW4;
    XFectStr = ['XFection: ',dataStruct.DBParams.XFect];
    set(HTW4,'String',XFectStr);

    % update inforbar
    Hinfobar = HGUI.Hinfobar;
    maxrun = S.maxrun;

    infostr = sprintf('Run: %2d/%2d     Internal: %s     External: %s     Comments: %s',...
        runNum, maxrun, dataStruct.DBParams.IntSoln, ...
        dataStruct.DBParams.ExtSoln, dataStruct.DBParams.Notes);
    set(Hinfobar,'string', infostr);
end



%% store necessary information for later usage
% These updates were done before calling plotswp.m
% S.runNum = runNum; S.swpNum = swpNum; S.maxrun = maxrun

set(Hlines(2),'UserData',S);
% S fields: rawfile, Runxxxx, runNum, swpNum, maxrun, xdata, ydata





%%	Update the Figure Information (UserData) (Key to FInfo in WCINIT)
FInfo.HGUI = HGUI;					% GUI Handles
FInfo.Hlines = Hlines;					% Line Handles
% FInfo.Hdel = Hdel;
set(gcf,'UserData', FInfo);				% Write to UserData
getheader()


% replot CDI if selected
if isfield(FInfo,'HCDIlines') 
    CDIon2off
    if ST ~=1
        CDIoff2on()
    end
end