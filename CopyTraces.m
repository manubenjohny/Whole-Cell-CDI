function CurrentOUT = CopyTraces()


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
   
time = S.(runstr).('Swp0001').time;
NewTime = time-sum(Dstep(1:2));
NewTimeMask = (NewTime>-1)&(NewTime<Dstep(3));
NewTime = NewTime(NewTimeMask);

CurrentOUT = zeros(maxswpNum+1,length(NewTime));
CurrentOUT(1,:) = NewTime;
strX = '%5.4f';
for swpNum = 1:maxswpNum
    swpstr = strcat('Swp', num2str(swpNum, '%.4d'));
    time = S.(runstr).(swpstr).time;
    try
        pAtrace = S.(runstr).(swpstr).pAtrace -  S.(runstr).(swpstr).pAleakfit;
    catch
        pAtrace = S.(runstr).(swpstr).pAtrace -  S.(runstr).(swpstr).pAleak;
    end
    
    CurrentOUT(swpNum+1,:) = pAtrace(NewTimeMask)';
    CurrentOUT(swpNum+1,:) = CurrentOUT(swpNum+1,:) - mean(CurrentOUT(swpNum+1,NewTime<=0));
    
    strX = sprintf('%s\t%s',strX,'%5.4f');
end
strX = [strX '\n'];

figure; 
plot(CurrentOUT(1,:), CurrentOUT(2:end,:));

clipboard('copy',sprintf(strX,CurrentOUT));



