function outputAsTraces(G,Vrev)
gxlines = get(gca,'children');
for i = 1: length(gxlines)
    Dat(i).X = get(gxlines(i),'xdata');
    Dat(i).Y = get(gxlines(i),'ydata');    
end


figure; 
S = 0.5;
AH = 1; AW = 5; L = 1; B = 1; 

R = 1;
C = 1;
V = -90:0.1:30;
uni = G*(V-Vrev);
for i = 1:length(Dat)
    axes('units','centimeters','position',[L+(S+AW)*(C-1) B+(S+AH)*(i-1) AW AH]);
    line(Dat(i).X, Dat(i).Y,'marker','none','linestyle','-','Color',[0 0 0]);
    line(V, uni,'marker','none','linestyle','-','Color',0.5+[0 0 0])
    line([-90 30], [0 0],'marker','none','linestyle','-','Color',0.7+[0 0 0])
    line([-80 -80+15], [0.5 0.5],'marker','none','linestyle','-','Color',[0 0 0]+0.5);
    line([-80 -80], [-0.5 0.5],'marker','none','linestyle','-','Color',[0 0 0]+0.5);
    ylim([min(uni)*1.2 0.8])
    xlim([-90 30])
    axis off;
    box off;
end