function getfcutoff()

HFmain = getappdata(0, 'HFmain');

FInfo = get(HFmain,'UserData');
HGUI = FInfo.HGUI;

fcutoff = str2num(get(HGUI.editfcutoff, 'String'));
FInfo.fcutoff = fcutoff;
set(HFmain,'UserData',FInfo)

try
    S = get(FInfo.Hlines(2),'UserData');
    infoUpdate = 0;
    plotswp(S, S.runNum, S.swpNum, infoUpdate)
catch
end