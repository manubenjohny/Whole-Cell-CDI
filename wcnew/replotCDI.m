function replotCDI()
HFmain = getappdata(0, 'HFmain');
FInfo = get(HFmain,'UserData');
S = get(FInfo.Hlines(2),'UserData');
Hlines = nonzeros(FInfo.Hlines(2:end));

% assume there are two lines, the current line is Ba2+ current (scaled),
% and the background line is Ca2+ current (non-scaled, so axis values are
% right)

% if length(Hlines) ~= 2
%     error('inside replotCDI: need TWO traces to replotCDI, bg trace is Ca2+, current trace is Ba2+ (scaled)');
% end

try %if two lines, the current one is Ba2+, background one is Ca2+ 
    xdataBa = get(Hlines(1),'XData');
    ydataBa = get(Hlines(1),'YData');
    xdataCa = get(Hlines(2),'XData');
    ydataCa = get(Hlines(2),'YData');
catch % if only one lines, assume is Ca2+
    xdataCa = get(Hlines(1),'XData');
    ydataCa = get(Hlines(1),'YData');
end

HGUI = 	 FInfo.HGUI;        
Hlistbox = HGUI.Hlistbox;


filelist = get(Hlistbox,'string');
datafilename =  filelist{get(Hlistbox,'Value')}; 
datafilename_noext = regexp(datafilename,'.*(?=\.mat)','match');

runstr = strcat('Run', num2str(S.runNum, '%.4d'));


CellNum = S.(runstr).DBParams.CellNum;
figurename = [datafilename_noext{1},'_Cell',num2str(CellNum)];

% replot, plot Ba2+ first!
figure('Name',figurename,'NumberTitle', 'off','Color','w','keypressfcn',@keystroke_plot)
axes('Box','on')
try
    line(xdataBa, ydataBa,'color', 'k','LineWidth',2)
catch
end
line(xdataCa, ydataCa, 'color','r','LineWidth',2)

%% format
Dstep =  S.(runstr).StimParams.Dstep;


% plot 0.2nA bar for reference
xpos = sum(Dstep(1:2)) + 20;
ypos_up = min(ylim)*0.2;
ypos_down = min(ylim)*0.2-200;
line([xpos,xpos],[ypos_up, ypos_down],'color', 'k','LineWidth',1)
text(xpos*1.03, ypos_down+(ypos_up-ypos_down)*0.2, '0.2nA', 'Rotation',90,'FontSize',15,'FontName','Arial')

% plot 100ms bar for reference
ypos = min(ydataBa) * 1.03;
xpos_left = sum(Dstep(1:2))-120;
xpos_right = sum(Dstep(1:2))-20;
line([xpos_left, xpos_right],[ypos,ypos],'color', 'k','LineWidth',1);
text(xpos_left+(xpos_right-xpos_left)*0.2, ypos + min(ylim)*0.05, '100ms','FontSize',15,'FontName','Arial')


axis([0 sum(Dstep(1:3))-5 ylim])
axis off


%% add text 
HFmain = getappdata(0, 'HFmain');

FInfo = get(HFmain,'UserData');
HGUI = FInfo.HGUI;

fcutoff = str2num(get(HGUI.editfcutoff, 'String'));

swpstr = strcat('Swp', num2str(S.swpNum, '%.4d'));
FvarValue = S.(runstr).(swpstr).FvarValue;

text_string = sprintf('fcutoff: %dHz, %d mV', fcutoff, FvarValue);
text(mean(xlim)*0.7,min(ylim)*0.05,text_string, 'FontSize',12);
%%
