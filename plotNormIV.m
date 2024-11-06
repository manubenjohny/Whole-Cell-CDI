function plotNormIV(ax,fname,flag)
BaDat = xlsread(fname,'Average','B18:AD30');
CaDat = xlsread(fname,'Average','B65:AD77');
BaFit = xlsread(fname,'Average','BA35:BA45');
CaFit = xlsread(fname,'Average','BD35:BD45');
% 
if flag <1
    Vtemp = BaDat(:,1);
    InormBa = BaDat(:,28);
    InormBaSEM = BaDat(:,29);
    FitPar = [BaFit];
    Cx = [0 0 0];
else
    Vtemp = CaDat(:,1);
    InormBa = CaDat(:,28);
    InormBaSEM = CaDat(:,29);
    FitPar = [CaFit];
    Cx = [1 0 0];
end
line(Vtemp, InormBa, 'marker','o','markeredgecolor',Cx,'markerfacecolor','none','parent',ax,'linestyle','none','markersize',3)
line([Vtemp Vtemp]', [InormBa-InormBaSEM InormBa+InormBaSEM]', 'color',Cx,'marker','none','parent',ax,'linestyle','-')
line([Vtemp-3 Vtemp+3]', [InormBa-InormBaSEM InormBa-InormBaSEM]', 'color',Cx,'marker','none','parent',ax,'linestyle','-')
line([Vtemp-3 Vtemp+3]', [InormBa+InormBaSEM InormBa+InormBaSEM]', 'color',Cx,'marker','none','parent',ax,'linestyle','-')
set(gca,'xaxisLocation','top','TickDir','out','color','none','TickLen',[0.02 0.02],'xtick',-50:10:50)

Vfit = -80:0.1:80;


xlim([-55 55]);
% ylim([-1 0]);
% w = warning ('off','all');
% try
% bnew = nlinfit(Vtemp, InormBa,@modelfun,FitPar);
InormFit = modelfun(FitPar, Vfit);
line(Vfit,InormFit,'color',Cx,'linestyle','-');
% clipboard('copy',sprintf('%5.4f\n',bnew))
% end



function InormFit = modelfun(BaFit,Vfit)
InormFit =((((1-BaFit(1))./(1 + exp(-(Vfit-BaFit(6))/BaFit(7)))) + (BaFit(1)./((1+exp(-(Vfit-BaFit(4))/BaFit(2))).^BaFit(3)))) ).*BaFit(11).*(Vfit-BaFit(9))./(1-exp((Vfit-BaFit(9))/BaFit(10)));


