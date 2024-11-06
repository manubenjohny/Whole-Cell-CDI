function displaytxt(mCDI,xxx)
FInfo = get(gcf,'UserData');
xxx = FInfo.xxx;
Vpre = mCDI.Vpre;
pAprepulse = mCDI.peakPrepulse.ival;
pAtestpulse = mCDI.peakTestpulse.ival;

% xxx = [50, 100, 300];

i_pick3 = mCDI.(['i', num2str(xxx(3))]).ival;
r_pick1 = mCDI.(['i', num2str(xxx(1))]).rval;
r_pick2 = mCDI.(['i', num2str(xxx(2))]).rval;
r_pick3 = mCDI.(['i', num2str(xxx(3))]).rval;

datamatrix = [Vpre, pAprepulse, i_pick3, pAtestpulse, ...
               r_pick1, r_pick2, r_pick3];
datatxt= sprintf('%5.1f \t %6.3f \t %6.3f \t %6.3f \t %6.3f \t %6.3f \t %6.3f\n', datamatrix);
fprintf('%s',datatxt);
clipboard('copy', datatxt);