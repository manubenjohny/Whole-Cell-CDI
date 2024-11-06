function jetplotSel()


HGUI3 = get(gcf, 'UserData');
axes(HGUI3.haxis)
hlines = get(HGUI3.haxis, 'children');
delete(hlines)


sel = get(HGUI3.hswplist,'Value');
swplist = get(HGUI3.hswplist,'String');


HFmain = getappdata(0, 'HFmain');
FInfo = get(HFmain,'UserData');
S = get(FInfo.Hlines(2),'UserData');
fcutoff = FInfo.fcutoff;

runNum = S.runNum; 
runstr = strcat('Run', num2str(runNum, '%.4d'));
dataStruct = S.(runstr);
ST = dataStruct.StimParams.ST;



PR = dataStruct.StimParams.PR;
map = jet;
Ymin = 0;
for i = 1:length(sel)
    swpstr = swplist{sel(i)};
    try
        xdata = dataStruct.(swpstr).time;
    catch
        xdata = dataStruct.(swpstr).voltage;
    end
    try 
        ydata = dataStruct.(swpstr).pAtrace - dataStruct.(swpstr).pAleakfit;
    catch
        ydata = dataStruct.(swpstr).pAtrace - dataStruct.(swpstr).pAleak;
    end
    Ymin = min(Ymin, min(ydata));
    ydata=ydata-mean(ydata(1:PR));
    if ST ~=1 && fcutoff ~= 0
        ydata = filt2(xdata, ydata, fcutoff);
    end
    if length(sel) > 1
        color = map(round(1+(i-1)/(length(sel)-1)*(length(map)-1)),:);
    else
        color = map(1,:);
    end          
    line(xdata,ydata,'color',color);
    
end
axis(HGUI3.haxis,[min(xdata), max(xdata(1:end-12)), Ymin, -Ymin*0.2]); 

