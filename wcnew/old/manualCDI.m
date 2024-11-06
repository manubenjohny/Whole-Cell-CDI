function res = manualCDI(opt)
% opt = 1 means change CDI
% opt = 2 means just display CDI
% update by ljs on 2/8/14: redefine startpoint(2) and
% endpoint(2)(not use end_retard anymore)
% notice data analysis before this date could be slightly different!

if nargin<1
    manualCDI(1);
    return
end


FInfo = get(gcf,'UserData');
HGUI = FInfo.HGUI;

S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
swpNum = S.swpNum;

runstr = strcat('Run', num2str(runNum, '%.4d'));
swpstr = strcat('Swp', num2str(swpNum, '%.4d'));


try 
   mCDI = S.(runstr).(swpstr).mCDI;
catch
   mCDI.flag = 0; 
end

switch opt
    case 2        % switch display on/off
       % we switch color for the button
    if mCDI.flag >0
        mCDI.flag = 0;
        set(HGUI.HBcdi,'BackgroundColor', [7.5294e-001  7.5294e-001  7.5294e-001])
        if isfield(mCDI,'lines')
        %   delete(mCDI.lines(1:4)); 
            delete(mCDI.lines(:)); 
        %   mCDI = rmfield(mCDI,'lines');
        end
        return;
    else
        mCDI = computeRatio();
    end
    case 1
        if ~isfield(mCDI,'lines')
            mCDI = computeRatio();
        end    
        for i = 1:4
            set(mCDI.lines(i),'Marker','o','MarkerEdgeColor','red')
            [x,y,button] = ginput(1);                
            if button == 1
                mCDI.measure(i).ival = y;
                mCDI.measure(i).time = x;
                set(mCDI.lines(i),'XData',x,'YData',y)
            end  
            if i>1
                set(mCDI.lines(i),'Marker','x','MarkerEdgeColor','black')
            else
                set(mCDI.lines(i),'Marker','x','MarkerEdgeColor','cyan') % Peak should be in Cyan
            end
        end        
        mCDI = RecomputeRatio(mCDI);
        displayRatio(mCDI);
    case 3                   
        set(HGUI.HBcdi,'BackgroundColor',  [7.5294e-001  7.5294e-001  7.5294e-001])
        if isfield(mCDI,'lines')
            delete(mCDI.lines(1:4)); 
            mCDI = rmfield(mCDI,'lines');
        end            
        mCDI = computeRatio(opt);      
end

% update info
S.(runstr).(swpstr).mCDI = mCDI;
set(FInfo.Hlines(2),'UserData',S);
set(gcf, 'UserData',FInfo)

% write to file
Hlistbox = HGUI.Hlistbox;

matDataFolders = FInfo.matDataFolders;
matDataFolderSel = FInfo.matDataFolderSel;
matDataFolder = matDataFolders{matDataFolderSel};


filelist = get(Hlistbox,'string');
datafilename =  filelist{get(Hlistbox,'Value')}; 
datafile = fullfile(matDataFolder,datafilename);
save(datafile,'S');



function mCDI = computeRatio(opt)
Finfo = get(gcf,'UserData');
HGUI = 	 Finfo.HGUI;			% GUI Handles
    mCDI.flag = 1;    
    set(HGUI.HBcdi,'BackgroundColor',  [4e-001  4e-001  4e-001])
%%  user input    
    emptyCat = 0;
    pathname = datafilepath;
	filename = datafilename;
    % filename = '070708.mbj';
    fullname = strcat(pathname,filename);
    
    
    TP = get(Finfo(2,2),'UserData');
    
    
    rnum = TP(2,1);
    maxrun = TP(2,2);
    
	%rnum =4;  
	pulse = 2;		% pulse for rxxx measurement
	pulse2 = 4;		% pulse for test pulse measurement
	printflag = 0;  % print hardcopy of each sweep, 0 off, 1 on.
    figpage = 6;
	yaxisscale =3*0.75;		% number to multiply ymin of test pulse for max neg y scale value
	peak = 1;       	% 1 for peak measurement, 2 for av5erage around peak 
    fcutoff = 400;		%lowpass cutoff in Hz, if set to 0, then no filtering
    glitch_advance = 20;	% sample points from beginning of pulses to ignore in peak detection
    end_retard = 100;	% sample points from beginning of pulses to ignore in peak detection
	reftrace = 2;		% used for axis scaling, based on test pulse size
	peak_width = 3;		% pts to side to average
	r_width = 8;		% pts to side to average for Ixxx
    

%%  open file

	datafileID = fopen(fullname,'rb+');
	[dirblock,count]=fread(datafileID,256,'short');
	maxrun=dirblock(1);

	infoADRS = dirblock(rnum*2+1);
	status = fseek(datafileID,infoADRS*512,-1);
	[infoblock,count]=fread(datafileID,128,'short');

	if infoblock(1) == 32100
		fileOK = 1;
		
        else
		%  datafilename = 0;            % MBJ Not sure this is used in file
                                        % elsewhere .. commented out to
                                        % ensure that the global variable
                                        % isn't changed thanks to an error.
		disp ('files info block is weird')
	end

	fclose(datafileID);

%% get infoblock information

	maxswp = 	infoblock(1+1);			% number of sweeps
	VH =		infoblock(2+1);			% holding potential
	I = 		infoblock(6+1);			% sample interval (usec)
	G = 		infoblock(7+1)/10;		% gain (mV/pA)
	LF = 		infoblock(8+1);			% leak flag

	if LF
		maxswp = maxswp/2;
	end;

	NB =		infoblock(13+1);		% number of blocks per sweep
	PR =		infoblock(15+1);		% points before first pulse
	ST =		infoblock(18+1);		% sample type (0-step, 1-ramp, 2-family)
	NI =		infoblock(19+1);		% variable changed in family
	HZ =		infoblock(21+1);		% lopass filter frequency

	family(1:3)=	infoblock(23:25);		% Family start,stop,increment
	PV(1:8) =	infoblock(29:36);		% Pulse Block PV(NI-3) incremented in family

	DE1 =		infoblock(38+1);		% First pulse saved
	DE2 =		infoblock(39+1);		% Last pulse saved

	PF = 	1000*(3.48*exp(-HZ/150)+ ...
		0.73*exp(-HZ/650)+ ...
		0.2*exp(-HZ/2700)+ ...
		0.032*exp(-HZ/43500));

	PF = round(PF/infoblock(6+1));			% Filter delay in points



%% find startpoint, endpoint indices, for desired pulse

	% calculate start/endpoint indices
	TBlock = [];
	TBlock(14) = PR+PF;  				% Length (in points) of initial region
	TBlock(15) = TBlock(14)+1;			% Location of Start Pulse 1 (points)
	TBlock(16) = TBlock(15)+round(PV(5)*1000/I);	% Location of Start Pulse 2 (points)	
	TBlock(17) = TBlock(16)+round(PV(6)*1000/I);	% Location of Start Pulse 3 (points)
	TBlock(18) = TBlock(17)+round(PV(7)*1000/I);	% Location of Start Pulse 4 (points)
	TBlock(19) = TBlock(18)+round(PV(8)*1000/I)-1;	% Last Point of Pulse 4

    t1 = 1;
    t2 = 40;
	startpoint = TBlock(15+(pulse-1))+round(t1*1000/I);		% Pre pulse
	endpoint = TBlock(15+(pulse-1))+round(t2*1000/I);		

	startpoint2 = TBlock(15+(pulse2-1))+round(t1*1000/I);		% Test pulse
	endpoint2 = TBlock(15+(pulse2-1))+round(t2*1000/I);		

% 	startpoint = TBlock(15+(pulse-1));		% Pre pulse
% 	endpoint = TBlock(15+pulse)-1;		
% 
% 	startpoint2 = TBlock(15+(pulse2-1));		% Test pulse
% 	endpoint2 = TBlock(15+pulse2)-1;		


%%  Setup timebase

xdata = I/1000*([1:NB*256]-(PR+PF+1));		
time = I/1000*([1:NB*256]-(PR+PF+1));		% PR+PF+1 is where first pulse starts
 

%% open file
datafileID = fopen(fullname,'rb');
swpnum = TP(2,3);


if (LF ~= 0) 						% Leak Pulses were acquired

    traceADRS = infoADRS+2+NB+2*NB*(swpnum-1);
    leakADRS =  traceADRS+NB;

    fseek(datafileID,512*traceADRS,-1);
    [dtrace,count]=fread(datafileID,256*NB,'short');

    Vpre = dtrace(length(dtrace)-1);
    mCDI.Vpre = Vpre;
    fseek(datafileID,512*leakADRS,-1);
    [leak,count]=fread(datafileID,256*NB,'short');

    dtrace=	[dtrace(1:NB*256-12) - ...
        (leak(1:NB*256-12) - mean(leak(1:PR)))*infoblock(37)/16;...
        dtrace(NB*256-11:NB*256)];
else								% No Interpulse leaks

    traceADRS = infoADRS+2+NB+NB*(swpnum-1);

    fseek(datafileID,512*traceADRS,-1);
    [dtrace,count]=fread(datafileID,256*NB,'short');

end
	
	%zero level the trace
	dtrace(1:NB*256-11)=dtrace(1:NB*256-11)-mean(dtrace(1:PR));
	%
	
	pAtrace = dtrace*(10000/2048)/G;
    %time = I/1000*([1:NB*256]-(PR+PF+1));
    if fcutoff ~= 0
		pAtrace = filt2(time, pAtrace', fcutoff)';
	end
    
	% this is the custom analysis area
	if peak == 1
		[pAprepulse, minloc] = min(pAtrace(startpoint+glitch_advance:endpoint));
		minloc = minloc + glitch_advance;
		%
		[pAtestpulse, minloc2] = min(pAtrace(startpoint2+glitch_advance:endpoint2));
		minloc2 = minloc2 + glitch_advance;
		%
        % MBJ new params;
        %mCDI.measure(1).type = 1;
        mCDI.measure(1).ival = pAprepulse;
        %mCDI.measure.peak.loc = minloc+startpoint;
        mCDI.measure(1).time = time(minloc+startpoint);
        mCDI.measure(1).value = 1;
        
        mCDI.measure(1).pAtestpulse = pAtestpulse;        
        mCDI.measure(1).time2 = time(minloc2+startpoint);
                
        
	elseif peak == 2
		[pAprepulse, minloc] = min(pAtrace(startpoint+glitch_advance:endpoint));
		minloc = minloc + glitch_advance;
		pAprepulse = mean(pAtrace(startpoint-1+minloc-peak_width:startpoint-1+minloc+peak_width));
		
        [pAtestpulse, minloc2] = min(pAtrace(startpoint2+glitch_advance:endpoint2));
		minloc2 = minloc2 + glitch_advance;
		pAtestpulse = mean(pAtrace(startpoint2-1+minloc2-peak_width:startpoint2-1+minloc2+peak_width));
        
        % MBJ new params;        
        %mCDI.measure(1).type = 1;
        mCDI.measure(1).ival = pAprepulse;
        %mCDI.measure.peak.loc = minloc+startpoint;
        mCDI.measure(1).time = time(minloc+startpoint);
        mCDI.measure(1).value = 1;
        mCDI.measure(1).pAtestpulse = pAtestpulse;
        %mCDI.measure.peak.loc2 = minloc2+startpoint;
        mCDI.measure(1).time2 = time(minloc2+startpoint);
                
    end
    
    %
    
    % R100
	i100 = mean(pAtrace(startpoint-1+round(100*1000/I)-r_width:startpoint-1+round(100*1000/I)+r_width));
	r100 = i100/pAprepulse;
	if minloc > round(100*1000/I)
		r100 = 1;
    end
    mCDI.measure(3).ival = i100;
    %mCDI.measure.r100.loc = startpoint-1+round(100*1000/I);
    mCDI.measure(3).time = time(startpoint-1+round(100*1000/I));
    mCDI.measure(3).value = r100;
    
	i300 = mean(pAtrace(startpoint-1+round(295*1000/I)-r_width:startpoint-1+round(295*1000/I)+r_width));
	r300 = i300/pAprepulse;
	if minloc > round(295*1000/I)
		r300 = 1;
    end

    mCDI.measure(4).ival = i300;
    %mCDI.measure(4).loc = startpoint-1+round(295*1000/I);
    mCDI.measure(4).time = time(startpoint-1+round(295*1000/I));
    mCDI.measure(4).value = r300;
    
    i50 = mean(pAtrace(startpoint-1+round(50*1000/I)-r_width:startpoint-1+round(50*1000/I)+r_width));
	r50 = i50/pAprepulse;
	if minloc > round(50*1000/I)
		r50 = 1;
	end
    mCDI.measure(2).ival = i50;
    %mCDI.measure.r50.loc = startpoint-1+round(50*1000/I);
    mCDI.measure(2).time = time(startpoint-1+round(50*1000/I));
    mCDI.measure(2).value = r50;
       
    % Now that we have all the measurements lets plot these and 
    % use hline. to define new points. 
    axes(HGUI(24))       
    mCDI.lines(1) = line(mCDI.measure(1).time, mCDI.measure(1).ival,'Marker','x','MarkerSize',25,'MarkerEdgeColor','cyan','LineWidth',2);        
    for i = 2:4
        mCDI.lines(i) = line(mCDI.measure(i).time, mCDI.measure(i).ival,'Marker','x','MarkerSize',25,'MarkerEdgeColor','black','LineWidth',2);        
    end
    %[mCDI.measure(1).ival mCDI.measure(2).ival mCDI.measure(3).ival mCDI.measure(4).ival]
    %set(HGUI(23),'Selected','off')    
    displayRatio(mCDI)
    
    % Now we need to recompute CDI
    

function mCDI = RecomputeRatio(mCDI)
peak = mCDI.measure(1).ival;
for i = 2:4
    mCDI.measure(i).value = mCDI.measure(i).ival/peak;    
end

function displayRatio(mCDI)
Vpre = mCDI.Vpre;
pAprepulse = mCDI.measure(1).ival;
i300 = mCDI.measure(4).ival;
pAtestpulse = mCDI.measure(1).pAtestpulse;
r50 = mCDI.measure(2).value;
r100 = mCDI.measure(3).value;
r300 = mCDI.measure(4).value;

datamatrix = [Vpre, pAprepulse, i300, pAtestpulse, r50, r100,r300];
datatxt= sprintf('%5.1f \t %6.3f \t %6.3f \t %6.3f \t %6.3f \t %6.3f \t %6.3f\n', datamatrix');
fprintf('%s',datatxt);
clipboard('copy', datatxt);