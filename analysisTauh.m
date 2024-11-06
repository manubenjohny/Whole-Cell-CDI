function b = analysisTauh(CurrentOUT);

t = CurrentOUT(1,:);
I = CurrentOUT(2:end,:);
figure; 
nc = 4;
nr = floor(size(I,1)/nc)+1;

figure;
for jk = 1:size(I,1)
    temptrace = I(jk,:);
    
    pk = find(temptrace == min(temptrace),1);
    t2fit = t(pk:end);
    I2fit = temptrace(pk:end);
    b0 = [-30, 0, 0.5];
    
    b(jk,:) = nlinfit(t2fit,I2fit,@modelfun,b0);
    
    NewFit = b(jk,1)*exp(-(t-b(jk,2))/b(jk,3));
    
    subplot(nr,nc,jk)
    plot(t,temptrace,'k-',t,NewFit,'r-')
    ylim([temptrace(pk)*1.1 0])
    
    
end

function y = modelfun(b,X)
y = b(1)*exp(-(X-b(2))/b(3));