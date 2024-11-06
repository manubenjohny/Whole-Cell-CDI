function [Q,pAtail] = QToff2on(varargin)
%% set fcutoff to zero   
% 0 for non-filter, any positive number as fcutoff
% should always use fcutoff = 0 as tail current is very fast
% see LJS: aGPVM;notfx.xlsm (Cell1)


fcutoff = 0;
FInfo = get(gcf,'UserData');
HGUI = FInfo.HGUI;
set(HGUI.editfcutoff, 'String',fcutoff);
getfcutoff() 

% without user interface, getfcutoff() is not automatically called,
% although we reset fcutoff through programming! getfcutoff() can be
% replace by the following three lines:
% FInfo.fcutoff = fcutoff;
% set(gcf,'UserData',FInfo)
% plotswp(S, S.runNum, S.swpNum, 0) 

%  have to reload FInfo since we update FInfo inside plotswp (inside
%  getcutoff)
FInfo = get(gcf,'UserData');
S = get(FInfo.Hlines(2),'UserData'); 
%% press pushbutton  "HBQTail"
set(HGUI.HBQTail,'BackgroundColor',ones(1,3)*0.4)

%%

pulseQ = 2;
pulseT = 3;

fcutoff = 0;  
glitch_advance = 0;	% sample points from beginning of pulses to ignore in peak detection

peak = 1;       	% 1 for peak measurement, 2 for average around peak (using peak_width)
peak_width = 3;		% pts to side to average for peak

    
 %% manipulate desired trace: leak substraction, setZero, filter
 
runNum = S.runNum;
swpNum = S.swpNum;
runstr = strcat('Run', num2str(runNum, '%.4d'));
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));
time = S.(runstr).(swpstr).time;
try
    pAtrace = S.(runstr).(swpstr).pAtrace -  S.(runstr).(swpstr).pAleakfit;
catch
    pAtrace = S.(runstr).(swpstr).pAtrace -  S.(runstr).(swpstr).pAleak;
end



   
%% 
Dstep = S.(runstr).StimParams.Dstep;
PR = S.(runstr).StimParams.PR;
PF = S.(runstr).StimParams.PF;
I = 1e6/S.(runstr).StimParams.SampleHz;

pulseStartPt = zeros(1,5);
pulseStartPt(1) = PR + PF +1;
for i = 2:5
    pulseStartPt(i) = pulseStartPt(i-1) + round((Dstep(i-1)*1000/I));
end
    
%%
pAtrace = pAtrace - mean(pAtrace(1:PR));

% if fcutoff ~= 0
%     pAtrace = filt2(time, pAtrace, fcutoff);
% end





%%  calculate gating charge


if nargin < 1 || length(varargin{1}) ~= 2
    t1 = -3;
    t2 = 3;
    startpoint = pulseStartPt(pulseQ)+round(t1*1000/I);
    endpoint = pulseStartPt(pulseQ)+round(t2*1000/I);

else
    startpoint = pulseStartPt(1)+ round(varargin{1}(1)*1000/I);
    endpoint = pulseStartPt(1)+round(varargin{1}(2)*1000/I);
end
% t1 = -3;
% t2 = 3;

Q = sum(pAtrace(startpoint:endpoint))*I/1000; %unit: fC

HQ = line(time(startpoint:endpoint),pAtrace(startpoint:endpoint),'LineWidth', 2,'Color', [1 0 0]);


%% peak of tail current    
if nargin < 2 || length(varargin{2}) ~= 2
    t1 = 0;
    t2 = 10;

    startpoint2 = pulseStartPt(pulseT)+round(t1*1000/I);
    endpoint2 = pulseStartPt(pulseT)+round(t2*1000/I);		


    [pAtail, minloc2] = min(pAtrace(startpoint2+glitch_advance:endpoint2));
    minloc2 = minloc2 + glitch_advance;
    if peak == 2
        pAtail = mean(pAtrace(startpoint2-1+minloc2-peak_width:startpoint2-1+minloc2+peak_width));

    end  
    Htail = line(time(minloc2+startpoint2),pAtail,'Marker','x','MarkerSize',25,'MarkerEdgeColor','cyan','LineWidth',2);

else
    % plotting previously picked tail
    tailTime = varargin{2}(1);
    pAtail = varargin{2}(2);
    Htail = line(tailTime,pAtail,'Marker','x','MarkerSize',25,'MarkerEdgeColor','cyan','LineWidth',2);

end

    
%%
FInfo.HQ = HQ; 
FInfo.Htail = Htail;
set(gcf,'UserData', FInfo); 

V2 = S.(runstr).StimParams.Dstep(2);
V3 = S.(runstr).StimParams.Dstep(3);
D2 = Dstep(2);
% if fcutoff == 0 
%     fcutoff = HZ;
% end
datatxt = sprintf('%6.1f \t %6.1f \t %3.3f \t %i \t %i \t %i \t %i\n',...
    [Q, pAtail, -Q/pAtail, V2, V3, D2, fcutoff]);
fprintf('%s',datatxt);
clipboard('copy', datatxt);

zoom reset
zoom xon

end
    