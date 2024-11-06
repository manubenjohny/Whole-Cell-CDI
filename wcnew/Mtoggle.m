function Mtoggle(flagstring)
%	MenuTOGGLE.M	Function Toggles Menu Checks and Refresh Sweep
%
%%

FInfo = get(gcf,'UserData');				% Get UserData Matrix (handles for GUI and traces)
HGUI = FInfo.HGUI;

% Get Appropriate Menu Handle

if strcmp(flagstring,'zero'),Hmenu = HGUI.HMzero;end
if strcmp(flagstring,'leak'),Hmenu = HGUI.HMleak; Hmenu2 = HGUI.HMleakfit;end
if strcmp(flagstring,'leakfit'),Hmenu = HGUI.HMleakfit; Hmenu2 = HGUI.HMleak;end
if strcmp(flagstring,'info'),Hmenu = HGUI.HMinfo;end
if strcmp(flagstring,'lock'),Hmenu = HGUI.HMlock;end
% if strcmp(flagstring,'isotool'),Hmenu = HGUI.HMiso;end


if strcmp(get(Hmenu,'Checked'),'on')
	set(Hmenu,'Checked','off');
else
	set(Hmenu,'Checked','on');
    try
        set(Hmenu2,'Checked','off');
    end
end


%	Refresh the current trace and replot it

HIDline = FInfo.Hlines(2);
S = get(HIDline,'UserData');
infoUpdate = 0;
plotswp(S,S.runNum,S.swpNum, infoUpdate)
