function CDIon2off()
FInfo = get(gcf,'UserData');
HGUI = FInfo.HGUI;

% retset button to "unpressed" condition
set(HGUI.HBcdi,'BackgroundColor', ones(1,3)*0.75294)

% delete plot of CDI
if isfield(FInfo, 'HCDIlines') && isempty(nonzeros(FInfo.HCDIlines ==0))
    delete(FInfo.HCDIlines(:));
    FInfo = rmfield(FInfo, 'HCDIlines');
else
    error('inside CDIon2off: try to delete but cannot find HCDIlines');
end
set(gcf,'UserData',FInfo)


