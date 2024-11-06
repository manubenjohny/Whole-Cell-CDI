function computeCDI()
FInfo = get(gcf,'UserData');
S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
runstr = strcat('Run', num2str(runNum, '%.4d'));
ST = S.(runstr).StimParams.ST;


if ST ~= 1
    if isfield(FInfo,'HCDIlines') 
       CDIon2off
    else
       CDIoff2on
    end
end