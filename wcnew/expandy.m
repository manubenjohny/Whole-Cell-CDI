function expandy

%%
%%	EXPANDY.M	Expand Y Axes About Region
%%

%% Determine if Expand is Already On

FInfo = get(gcf,'UserData');				% Get UserData Matrix (handles for GUI and traces)
HGUI = FInfo.HGUI;
HBexpand = HGUI.HBexpandy;					% Get Menu Handle


expON = get(HBexpand,'UserData');

if (expON==0)
		
	disp('Select Region to expand with the Mouse')

	[~, y1, ~] = ginput(1);	
	[~, y2, ~] = ginput(1);	
	set(gca,'Ylim',sort([y1 y2]));

	set(HBexpand,'UserData',1);	% Turn on Expand Flag

	if ~getFLAG('lock')		% Lock Expanded Axis
		Mtoggle('lock');	
	end

else

	disp('Expand Turned Off')
	
	set(HBexpand,'UserData',0);	% Turn on Expand Flag

	if getFLAG('lock')
		Mtoggle('lock');
	end

end