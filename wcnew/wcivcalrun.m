function wcivcalrun()

%% parameters  
prepulse = 2;		% pulse for rxxx measurement
testpulse = 4;		% pulse for test pulse measurement
printflag = 0;  % print hardcopy of each sweep, 0 off, 1 on.
figpage = 6;
yaxisscale =3*0.75;		% number to multiply ymin of test pulse for max neg y scale value
fcutoff = 800;		%lowpass cutoff in Hz, if set to 0, then no filtering
   
%%  
HFmain = getappdata(0, 'HFmain');
FInfo = get(HFmain,'UserData');
% HGUI = FInfo.HGUI;
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
runstr = strcat('Run', num2str(runNum, '%.4d'));
maxswpNum = getmaxswp(S.(runstr));

HGUI = FInfo.HGUI;
Hlistbox = HGUI.Hlistbox;

filelist = get(Hlistbox,'string');
datafilename =  filelist{get(Hlistbox,'Value')}; 
xxx = FInfo.xxx;

%%
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
t1 = 1;
t2 = 40;
startpoint = pulseStartPt(prepulse)+round(t1*1000/I);		% Pre pulse
endpoint = pulseStartPt(prepulse)+round(t2*1000/I);		

startpoint2 = pulseStartPt(testpulse)+round(t1*1000/I);		% Test pulse
endpoint2 = pulseStartPt(testpulse)+round(t2*1000/I);		

if endpoint2 > pulseStartPt(5) -20
    endpoint2 = pulseStartPt(5) - 20;
end
%%  Setup windows


fighand1 = figure();

datamatrix = zeros(maxswpNum,7);  %7 rows fcor the data. change when adding more data rows.  


%%
for swpNum = 1:maxswpNum
    
    % get pAtrace
    swpstr = strcat('Swp', num2str(swpNum, '%.4d'));
    
    time = S.(runstr).(swpstr).time;

    try
        pAtrace = S.(runstr).(swpstr).pAtrace -  S.(runstr).(swpstr).pAleakfit;
    catch
        pAtrace = S.(runstr).(swpstr).pAtrace -  S.(runstr).(swpstr).pAleak;
    end
    pAtrace = pAtrace - mean(pAtrace(1:PR));
    if fcutoff ~= 0
        pAtrace = filt2(time, pAtrace, fcutoff);
    end

    % get mCDI
    try 
        mCDI = S.(runstr).(swpstr).mCDI;
    catch
        mCDI = calcCDI(swpNum);
    end
    
%% get reference trace (for axis scaling)
    if swpNum ==1 
        ymin = yaxisscale * min(pAtrace(startpoint2:endpoint2));	
        % Find test pulse peak within 20 msec


        % setup axis
        dataaxes = [time(1), time(length(time)-12), ymin, 0.5*abs(ymin)];
        axis (dataaxes);
        axis(axis);
        hold
    end


%% 
    
	plot(time,pAtrace)

	xlim = get(gca,'Xlim');
	ylim = get(gca,'Ylim');
    figure(fighand1)
	plot(xlim,[0 0],'w')
	plot(mCDI.peakPrepulse.time, mCDI.peakPrepulse.ival,'r+')
	plot(mCDI.peakTestpulse.time, mCDI.peakTestpulse.ival,'g+')
    
    % calculate tail:
    width = round(2*1000/I);
    [tail,pos] = min(pAtrace(pulseStartPt(prepulse+1) - width : pulseStartPt(prepulse+1) + width));
    plot(time(pulseStartPt(prepulse+1)-width+pos), tail, 'm+');
%     plot(time(startpoint+round(350*1000/I)-1),pAtrace((startpoint+round(350*1000/I)-1)),'m+') % tail

	plot(mCDI.(['i', num2str(xxx(1))]).time, mCDI.(['i', num2str(xxx(1))]).ival,'co')
	plot([mCDI.(['i', num2str(xxx(1))]).time mCDI.(['i', num2str(xxx(1))]).time], ylim,'c')
    plot(mCDI.(['i', num2str(xxx(2))]).time, mCDI.(['i', num2str(xxx(2))]).ival,'co')
	plot([mCDI.(['i', num2str(xxx(2))]).time mCDI.(['i', num2str(xxx(2))]).time], ylim,'c')
	plot(mCDI.(['i', num2str(xxx(3))]).time, mCDI.(['i', num2str(xxx(3))]).ival,'co')
	plot([mCDI.(['i', num2str(xxx(3))]).time mCDI.(['i', num2str(xxx(3))]).time], ylim,'c')
%     
% 	title_string = ['File = ', strrep(datafilename,'_','\_')   ...
%              ' Run = ', num2str(runNum), ...
%              ' Vpre = ', num2str(mCDI.Vpre), ...
% 			 ' pre(pA) =', num2str(mCDI.peakPrepulse.ival, '%.1f'), ...
%              'test(pA) =', num2str(mCDI.peakTestpulse.ival, '%.1f')];
    title_string = sprintf('File = %s,    Run = %d\n Vpre = %d   peak(pre) = %.1f pA    peat(test) = %.1f pA',...
                strrep(datafilename,'_','\_'),runNum, mCDI.Vpre, ...
                mCDI.peakPrepulse.ival, mCDI.peakTestpulse.ival);
      
	title(title_string, 'FontSize',9);

	text_string = ['    r',num2str(xxx(1)),' = ', num2str(mCDI.(['i', num2str(xxx(1))]).rval, '%.3f'), ...
                   '    r',num2str(xxx(2)),' = ', num2str(mCDI.(['i', num2str(xxx(2))]).rval, '%.3f'), ...
                   '    r',num2str(xxx(3)),' = ', num2str(mCDI.(['i', num2str(xxx(3))]).rval, '%.3f')];
    
    if exist('htext','var') && htext ~= 0; delete(htext);end;

	htext = text((xlim(1)+xlim(2))*0.2,ylim(2)*0.6,text_string, 'FontSize',9);
    
    
	%pause
	if printflag == 1
        index = round(figpage*((swpNum/figpage)-ceil((swpNum/figpage)-1)));
        fignum = 1+ceil(swpNum/figpage);
        figure(fignum);
        if figpage > 1
            subplot(2,round(figpage/2),index);
        else
            clf
        end
        cla;
        hold on	
        axis(dataaxes);

        plot(time,pAtrace)

        xlim = get(gca,'Xlim');
        ylim = get(gca,'Ylim');

        plot(xlim,[0 0],'w')
        plot(mCDI.peakPrepulse.time, mCDI.peakPrepulse.ival,'r+')
        plot(mCDI.peakTestpulse.time, mCDI.peakTestpulse.ival,'g+')
        plot(mCDI.(['i', num2str(xxx(3))]).time, mCDI.(['i', num2str(xxx(3))]).ival,'co')
        plot([mCDI.(['i', num2str(xxx(3))]).time mCDI.(['i', num2str(xxx(3))]).time], ylim,'c')  
        title_string = ['File = ', datafilename,   ...
             ' Run = ', num2str(runNum), ...
             ' Vpre = ', num2str(mCDI.Vpre), ...
             ' pre (pA) =', num2str(mCDI.peakPrepulse.ival), ...
             ' test (pA) =', num2str(mCDI.peakTestpulse.ival)];

        title(title_string, 'FontSize',6);
        drawnow
    else
        pause(0.3)
    end
    
    
 	datamatrix(swpNum, :) = [mCDI.Vpre, mCDI.peakPrepulse.ival, mCDI.(['i', num2str(xxx(3))]).ival, ...
        mCDI.peakTestpulse.ival, mCDI.(['i', num2str(xxx(1))]).rval, mCDI.(['i', num2str(xxx(2))]).rval, mCDI.(['i', num2str(xxx(3))]).rval];

end


%%
datatxt = sprintf('%5.1f \t %6.3f \t %6.3f \t %6.3f \t %6.3f \t %6.3f \t %6.3f\n', datamatrix');
fprintf('%s',datatxt);
clipboard('copy', datatxt);


if printflag == 1
    for i = 2:fignum
        figure(i);
        orient(figure(i), 'landscape')
        print;        
    end
end
