function getheader()

FInfo = get(gcf,'UserData');

S = get(FInfo.Hlines(2),'UserData');
runNum = S.runNum;
% swpNum = S.swpNum;
runstr = ['Run' num2str(runNum, '%.4d')];
DBParams = S.(runstr).DBParams;

str = [repmat('%s\t',1,13), '%s\n Comments:\t%s'];
mystr = sprintf(str, S.rawfile.name, DBParams.Date,num2str(DBParams.CellNum), ...
       num2str(runNum),' ',' ',num2str(DBParams.Rs),num2str(DBParams.Cm), ...
       num2str(DBParams.Comp), DBParams.Leak,' ',...
       DBParams.IntSoln,'TEA-MS',DBParams.ExtSoln,DBParams.Notes);
str2 =  [repmat('\t',1,15),'%s'];
mystr2 = sprintf(str2, DBParams.XFect);

clipboard('copy',[mystr, mystr2]);

   