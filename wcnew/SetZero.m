function SetZero(item)
%	SETZERO.M	Function Toggles Set Zero Flag and Sets Up Zero Button
%
%%

% global datafilepath datafilename;
% global x1 x2 ymin ymax;
% 
% % Check that a file has been opened
% 
% datafile=[datafilepath datafilename];
% 
% if strcmp(datafilename,'0')
% 	errcall('OPEN A FILE FIRST');
% 	return;
% end
% 
% %	FInfo:	Row 1: Handles for GUI


FInfo = get(gcf,'UserData');		% Get UserData Matrix (handles for GUI and traces)
HGUI = FInfo.HGUI;
Hmenu = HGUI.HMzero;				% Get Menu Handle
Hbutton = HGUI.HBzero;				% Get Button Handle


if strcmp(item,'menu')				% Menu Toggled 
	if strcmp(get(Hmenu,'Checked'),'on')
		set(Hmenu,'Checked','off');
		set(Hbutton,'Visible','off');
		set(Hbutton,'Callback','');
	else
		set(Hmenu,'Checked','on');
		set(Hbutton,'Visible','on');
		set(Hbutton,'Callback','SetZero(''button'')');
		set(Hbutton,'UserData',[0 0]);
	end
end

if strcmp(item,'button')
	
	Htext = uicontrol(gcf,...
			'Style','text',...
			'BackGroundColor',[0 0 .5],...
			'ForeGroundColor',[1 1 0],...
			'Units','normalized',...
			'Position',[.6 .85 .2 .1],...
			'String','2 mouse clicks select region taken as zero.  Unchecking the Display/Zero undoes the effects of this button.');

	[x1 y button] = ginput(1);	
	ylim = get(gca,'YLim');
	Hline1 = line([x1 x1],ylim,'Color',[0 0 1]);

	[x2 y button] = ginput(1);	
	ylim = get(gca,'YLim');
	Hline2 = line([x2 x2],ylim,'Color',[0 0 1]);

	set(Hbutton,'UserData',[sort([x1 x2]) Hline1 Hline2]); % Note This is Stored In Time
	
	delete(Htext);
	delete(Hline1);
	delete(Hline2);
end


%	Refresh the current trace and replot it

HIDline = FInfo.Hlines(2);

S = get(HIDline,'UserData');
infoUpdate = 0;
plotswp(S,S.runNum,S.swpNum, infoUpdate)
