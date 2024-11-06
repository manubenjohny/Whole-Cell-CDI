function myleakfit = FITLeakMx(Params,t)
HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');
T =  cumsum(FInfo2.leakfitData.Times);

P2 = Params(2)*ones(size(t)) + Params(3)*exp(-(t-T(1))/Params(4)) + Params(5)*exp(-(t-T(1))/Params(6));
P2 = P2.*(t>=T(1)).*(t<=T(2));
P3 = Params(7)*ones(size(t)) + Params(8)*exp(-(t-T(2))/Params(9)) + Params(10)*exp(-(t-T(2))/Params(11));
P3 = P3.*(t>=T(2)).*(t<=T(3));
P4 = zeros(size(t));
testP4 = Params(13)*exp(-(t-T(3))/Params(14)) + Params(15)*exp(-(t-T(3))/Params(16));
P4 = P4+Params(12)*ones(size(t)) + (testP4<Inf).*testP4;
P4 = P4.*(t>=T(3)).*(t<=T(4));
myleakfit =Params(1)+zeros(size(t));
P2 = MovingAvg(Params(17),5,P2);
P3 = MovingAvg(Params(17),5,P3);
P4 = MovingAvg(Params(17),5,P4);
for i =1:length(t)    
   if (t(i)>=T(1) && t(i)<T(2))
       myleakfit(i) = P2(i);
   elseif (t(i)>=T(2) && t(i)<T(3))
       myleakfit(i) = P3(i);
   elseif (t(i)>=T(3) && t(i)<T(4))
       myleakfit(i) = P4(i);
   end
end
myleakfit = ApplyMask(myleakfit);

function smoothx = MovingAvg(lambda,npt, x)
% npt- forward filter.
smoothx = zeros(size(x));
smoothx(1:npt)= x(1:npt);
slambda = 0;
for i = 1:npt
   smoothx(npt+1:end) =  smoothx(npt+1:end)+lambda^(i-1)*x(npt-i+2:end-i+1);
   slambda = slambda + lambda^(i-1);
end
smoothx(npt+1:end) = smoothx(npt+1:end).*1/slambda;
