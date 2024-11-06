function myleakfit = FITLeak(leakfitParams,t)
HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');
T =  cumsum(FInfo2.leakfitData.Times);

P2 = leakfitParams.P2offset * ones(size(t)) + ...
     leakfitParams.P2a0 * exp(-(t-T(1)) / leakfitParams.P2tau0) + ...
     leakfitParams.P2a1 * exp(-(t-T(1)) / leakfitParams.P2tau1);
P2 = P2.*(t>=T(1)).*(t<=T(2));
P3 = leakfitParams.P3offset * ones(size(t)) + ...
     leakfitParams.P3a0 * exp(-(t-T(2)) / leakfitParams.P3tau0) + ...
     leakfitParams.P3a1 * exp(-(t-T(2)) / leakfitParams.P3tau1);
P3 = P3.*(t>=T(2)).*(t<=T(3));
P4 = zeros(size(t));
testP4 = leakfitParams.P4a0 * exp(-(t-T(3)) / leakfitParams.P4tau0) + ...
         leakfitParams.P4a1 * exp(-(t-T(3)) / leakfitParams.P4tau1);
P4 = P4+ leakfitParams.P4offset * ones(size(t)) + (testP4<Inf).* testP4;
P4 = P4.*(t>=T(3)).*(t<=T(4));

myleakfit = leakfitParams.offset + zeros(size(t));
P2 = MovingAvg(leakfitParams.lambda, 5, P2);
P3 = MovingAvg(leakfitParams.lambda, 5, P3);
P4 = MovingAvg(leakfitParams.lambda, 5, P4);
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
