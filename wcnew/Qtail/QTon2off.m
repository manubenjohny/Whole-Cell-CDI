function QTon2off()
FInfo = get(gcf, 'UserData');
HGUI = FInfo.HGUI;
set(HGUI.HBQTail,'BackgroundColor',ones(1,3)*0.75294)

HQ = FInfo.HQ; Htail = FInfo.Htail;
if (HQ ~= 0)
    delete(HQ)
    FInfo = rmfield(FInfo, 'HQ');
end
if (Htail ~= 0)
    delete(Htail)
    FInfo = rmfield(FInfo, 'Htail');
end
set(gcf,'UserData', FInfo); 

% reset fcutoff to default value: 2000
fcutoff = 2000;
FInfo = get(gcf,'UserData');
HGUI = FInfo.HGUI;
set(HGUI.editfcutoff, 'String',fcutoff);
getfcutoff() 
zoom off


    

