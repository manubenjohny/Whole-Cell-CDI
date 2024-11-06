function mCDI = calcCDI(varargin)

%% retrieve necessary trace information
HFmain = getappdata(0,'HFmain');
FInfo = get(HFmain,'UserData');
% HGUI = FInfo.HGUI;
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;

% xxx : time stamp to calculate CDI
xxx = FInfo.xxx;


if nargin < 1
    swpNum = S.swpNum;
else
    swpNum = varargin{1};
end

runstr = strcat('Run', num2str(runNum, '%.4d'));
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));

% did leak substraction (prefer leak fit if available) when calcCDI
time = S.(runstr).(swpstr).time;
try
    pAtrace = S.(runstr).(swpstr).pAtrace -  S.(runstr).(swpstr).pAleakfit;
catch
    pAtrace = S.(runstr).(swpstr).pAtrace -  S.(runstr).(swpstr).pAleak;
end


%% conventaional paramters used in calculation

Dstep = S.(runstr).StimParams.Dstep;
PR = S.(runstr).StimParams.PR;
PF = S.(runstr).StimParams.PF;
I = 1e6/S.(runstr).StimParams.SampleHz;

pulseStartPt = zeros(1,5);
pulseStartPt(1) = PR + PF +1;
for i = 2:5
    pulseStartPt(i) = pulseStartPt(i-1) + round((Dstep(i-1)*1000/I));
end
% notice that pulseStartPt(5) refers to the pt right after the last pt of
% the trace (since there is only 4 pulse), i.e. that pt is not exist, but
% we can use pulseStartPt(5) -1 to find the last pt of the trace!



%% paramters used in calculating mCDI
prepulse = 2;		% pulse for rxxx measurement
testpulse = 4;		% pulse for test pulse measurement
peak = 1;       	% 1 for peak measurement, 2 for average around peak 
fcutoff = 400;		%lowpass cutoff in Hz, if set to 0, then no filtering
glitch_advance = 20;	% sample points from beginning of pulses to ignore in peak detection
peak_width = 3;		% pts to side to average for peak measurment
r_width = 8;		% pts to side to average for ixxx measurement

% end_retard = 100;	% sample points from beginning of pulses to ignore in peak detection
% replace end_retart by t1 and t2 in the next section
%% still paramters used in calculating mCDI (new parameters)
% restain peak selection between between t1 and t2 from the start of the pulse
t1 = 0;
t2 = 20;
startpoint = pulseStartPt(prepulse)+round(t1*1000/I);		% Pre pulse
endpoint = pulseStartPt(prepulse)+round(t2*1000/I);		

startpoint2 = pulseStartPt(testpulse)+round(t1*1000/I);		% Test pulse
endpoint2 = pulseStartPt(testpulse)+round(t2*1000/I);		
if endpoint2 > pulseStartPt(5) -20
    endpoint2 = pulseStartPt(5) - 20;
end
%% filter pulse and setZero
% use "setZero" when calcCDI
pAtrace = pAtrace - mean(pAtrace(1:PR));

if fcutoff ~= 0
    pAtrace = filt2(time, pAtrace, fcutoff);
end


%% calculate mCDI
% this is the custom analysis area
if peak == 1
    [pAprepulse, minloc] = min(pAtrace(startpoint+glitch_advance:endpoint));
    minloc = minloc + glitch_advance;
    
    [pAtestpulse, minloc2] = min(pAtrace(startpoint2+glitch_advance:endpoint2));
    minloc2 = minloc2 + glitch_advance;
    
    mCDI.peakPrepulse.ival = pAprepulse;
    mCDI.peakPrepulse.time = time(minloc+startpoint);
    mCDI.peakTestpulse.ival = pAtestpulse;        
    mCDI.peakTestpulse.time = time(minloc2+startpoint2);


elseif peak == 2
    [pAprepulse, minloc] = min(pAtrace(startpoint+glitch_advance:endpoint));
    minloc = minloc + glitch_advance;
    pAprepulse = mean(pAtrace(startpoint-1+minloc-peak_width:startpoint-1+minloc+peak_width));

    [pAtestpulse, minloc2] = min(pAtrace(startpoint2+glitch_advance:endpoint2));
    minloc2 = minloc2 + glitch_advance;
    pAtestpulse = mean(pAtrace(startpoint2-1+minloc2-peak_width:startpoint2-1+minloc2+peak_width));

    
    mCDI.peakPrepulse.ival = pAprepulse;
    mCDI.peakPrepulse.time = time(minloc+startpoint);
    mCDI.peakTestpulse.ival = pAtestpulse;
    mCDI.peakTestpulse.time = time(minloc2+startpoint2);

end

for i = 1:length(xxx)
    xxxstr = ['i', num2str(xxx(i))];
    pt = startpoint+round(xxx(i)*1000/I);
    mCDI.(xxxstr).time = time(pt);
    mCDI.(xxxstr).ival = mean(pAtrace(pt - r_width : pt + r_width));
    
    if abs(mCDI.peakPrepulse.ival/mCDI.peakTestpulse.ival) < 0.05
        mCDI.(xxxstr).rval = 1;
    else
        mCDI.(xxxstr).rval = mCDI.(xxxstr).ival / mCDI.peakPrepulse.ival;
    end
end

mCDI.Vpre = S.(runstr).(swpstr).FvarValue;
