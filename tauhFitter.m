function b = tauhFitter()

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
maxPls = 1;
NewTime = time-sum(Dstep(1:maxPls));
NewTimeMask = (NewTime>-2)&(NewTime<Dstep(maxPls+1));
NewTime = NewTime(NewTimeMask);

CurrentOUT = zeros(maxswpNum+1,length(NewTime));
VF = zeros(maxswpNum,1);
CurrentOUT(1,:) = NewTime;
strX = '%5.4f';
for swpNum = 1:maxswpNum
    swpstr = strcat('Swp', num2str(swpNum, '%.4d'));
    time = S.(runstr).(swpstr).time;
    VF(swpNum) = S.(runstr).(swpstr).FvarValue;
    try
        pAtrace = S.(runstr).(swpstr).pAtrace -  S.(runstr).(swpstr).pAleakfit;
    catch
        pAtrace = S.(runstr).(swpstr).pAtrace -  S.(runstr).(swpstr).pAleak;
    end
    
    CurrentOUT(swpNum+1,:) = pAtrace(NewTimeMask)';
    CurrentOUT(swpNum+1,:) = CurrentOUT(swpNum+1,:) - mean(CurrentOUT(swpNum+1,NewTime<=-1));
    
    strX = sprintf('%s\t%s',strX,'%5.4f');
end
strX = [strX '\n'];

% figure; 
% plot(CurrentOUT(1,:), CurrentOUT(2:end,:));

b = analysisTauh(CurrentOUT);
dat2copy = [VF b];

clipboard('copy',sprintf('%5.4f\t%5.4f\t%5.4f\t%5.4f\n',dat2copy'));
% 
% clipboard('copy',sprintf(strX,CurrentOUT));




function b = analysisTauh(CurrentOUT);

t = CurrentOUT(1,:);
I = CurrentOUT(2:end,:);

nc = 4;
nr = floor(size(I,1)/nc)+1;

figure;
for jk = 1:size(I,1)
    temptrace = I(jk,:);
    
    pk = find(temptrace(1:end/2) == min(temptrace(1:end/2)),1);
    t2fit = t(pk:end-100);
    I2fit = temptrace(pk:end-100);
    b0 = [-30, 0, 0.5];
    
    b(jk,:) = nlinfit(t2fit,I2fit,@modelfun,b0);
    
    NewFit = b(jk,1)*exp(-(t-b(jk,2))/b(jk,3));
    
    subplot(nr,nc,jk)
    plot(t,temptrace,'k-',t,NewFit,'r-')
    ylim([temptrace(pk)*1.1 0])
    
    
end

function y = modelfun(b,X)
y = b(1)*exp(-(X)/b(3));