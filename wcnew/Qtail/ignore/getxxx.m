function getxxx()
FInfo = get(gcf,'UserData');
HGUI = FInfo.HGUI;

xxx = str2num(get(HGUI.editCDIpara, 'String'));
FInfo.xxx = xxx;
set(gcf,'UserData',FInfo)