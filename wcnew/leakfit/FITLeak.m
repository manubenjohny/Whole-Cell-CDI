function myleakfit = FITLeak(leakfitParams,t)
HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');
T =  cumsum(FInfo2.leakfitData.Times);

x = (t-T(1)).*(t>=T(1)).*(t<=T(2));
P2 = leakfitParams.P2offset * ones(size(t)) + ...
     leakfitParams.P2a0 * exp(-x / leakfitParams.P2tau0) + ...
     leakfitParams.P2a1 * exp(-x / leakfitParams.P2tau1);

x = (t-T(2)).*(t>=T(2)).*(t<=T(3));
P3 = leakfitParams.P3offset * ones(size(t)) + ...
     leakfitParams.P3a0 * exp(-x / leakfitParams.P3tau0) + ...
     leakfitParams.P3a1 * exp(-x / leakfitParams.P3tau1);

x = (t-T(3)).*(t>=T(3)).*(t<=T(4));
P4 = leakfitParams.P4offset * ones(size(t))+ ...
     leakfitParams.P4a0 * exp(-x / leakfitParams.P4tau0) + ...
     leakfitParams.P4a1 * exp(-x / leakfitParams.P4tau1);


myleakfit = leakfitParams.offset + P2.*(t>=T(1)).*(t<=T(2))+...
    +P3.*(t>=T(2)).*(t<=T(3))+ P4.*(t>=T(3)).*(t<=T(4));
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
