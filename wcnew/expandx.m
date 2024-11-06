function expandx(varargin)

%%
%%	EXPANDX.M	Expand Region of Trace
%%

%% Determine if Expand is Already On

FInfo = get(gcf,'UserData');				% Get UserData Matrix (handles for GUI and traces)
HGUI = FInfo.HGUI;
HBexpand = HGUI.HBexpandx;					% Get Menu Handle


expON = get(HBexpand,'UserData');

if (expON == 0) || nargin == 2
		
    if nargin<2
        disp('Select Region to expand with the Mouse')
        [x1,~,~] = ginput(1);
        [x2,~,~] = ginput(1);
    else
        x1 = varargin{1};
        x2 = varargin{2};
    end
   
	set(gca,'Xlim',sort([x1 x2]));

	set(HBexpand,'UserData',1);	% Turn on Expand Flag

	if ~getFLAG('lock')		% Lock Expanded Axis
		Mtoggle('lock');	
	end

else

% 	disp('Expand Turned Off')
	
	set(HBexpand,'UserData',0);	% Turn on Expand Flag

	if getFLAG('lock')
		Mtoggle('lock');
	end

end