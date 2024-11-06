function QToff2on()
FInfo = get(gcf,'UserData');
HGUI = FInfo.HGUI;
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
swpNum = S.swpNum;

runstr = strcat('Run', num2str(runNum, '%.4d'));
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));

if ~isfield(FInfo, 'HQTlines')
    try 
        QT = S.(runstr).(swpstr).QT;
    catch
        QT = calcQT();
    end
else
    error('inside QToff2on: already have HQTlines');
end

% "press" on the button
set(HGUI.HBQTail,'BackgroundColor',ones(1,3)*0.4)

%%
% plot peak as cyan cross(don't plot peakTestpulse for now)
axes(HGUI.Haxis)
FInfo.HCDIlines(1) = line(mCDI.peakPrepulse.time, mCDI.peakPrepulse.ival,...
    'Marker','x','MarkerSize',25,'MarkerEdgeColor','cyan','LineWidth',2);

% plot iXXX as black cross
mCDIfields = fields(mCDI);
for i = length(mCDIfields):-1:1
    fieldname = mCDIfields{i};
    if fieldname(1) ~= 'i'
        mCDIfields(i) = [];
    end

end
for i = 1:length(mCDIfields)
    fieldname = mCDIfields{i};
    FInfo.HCDIlines(length(FInfo.HCDIlines)+1) = ...
        line(mCDI.(fieldname).time, mCDI.(fieldname).ival,...
        'Marker','x','MarkerSize',25,'MarkerEdgeColor','black','LineWidth',2);
    
end
displaytxt(mCDI)
FInfo.mCDI = mCDI;
set(gcf,'UserData', FInfo)