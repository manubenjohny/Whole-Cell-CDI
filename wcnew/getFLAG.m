function flagvalue = getFLAG(flagstring)

%%
%%	GETFLAG.M	Function that returns flag values for different toggle
%%			switches (coded in the UserData of the figure).
%%

HFmain = getappdata(0, 'HFmain');

FInfo = get(HFmain,'UserData');				% Get UserData Matrix (handles for GUI and traces)

HGUI = FInfo.HGUI;

% Get Appropriate Menu Handle

if strcmp(flagstring,'zero'),Hmenu = HGUI.HMzero;end
if strcmp(flagstring,'leak'),Hmenu = HGUI.HMleak;end
if strcmp(flagstring,'leakfit'),Hmenu = HGUI.HMleakfit;end
if strcmp(flagstring,'info'),Hmenu = HGUI.HMinfo;end
if strcmp(flagstring,'lock'),Hmenu = HGUI.HMlock;end
if strcmp(flagstring,'isotool'),Hmenu = HGUI.HMiso;end

% Set Flag to Appropriate Value
	
if strcmp(get(Hmenu,'Checked'),'on')
	flagvalue = 1;
else
	flagvalue = 0;		
end

