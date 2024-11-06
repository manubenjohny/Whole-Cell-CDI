function CaptureAndReplot()
gxlines = get(gca,'children');
for i = 1: length(gxlines)
    Dat(i).X = get(gxlines(i),'xdata');
    Dat(i).Y = get(gxlines(i),'ydata');    
end
figure; 
ax = axes('units','centimeters','position',[1.5 1.5 3*1.618 3]);
col = jet(length(gxlines)+1); 
hold on;
minval = 0;
for i = 1:length(Dat)
    plot(Dat(i).X, Dat(i).Y,'color',col(length(Dat)-i+1,:),'linewidth',0.5)
    minval = min(minval, min(Dat(i).Y(Dat(i).X<500)));
end 
if max(Dat(i).X)<500
    xlim([0 355])
    ylim([minval*1.15, max(10, -0.05*minval)])
    box off;
    line([0 305], [0 0],'color',[0 0 0]);
    line([200 200], [minval*0.9  minval*0.9+100],'color',[0 0 0]);
    line([200 300], [minval*0.9  minval*0.9],'color',[0 0 0]);
    hold off; 
    box off;
    axis off;
else
    xlim([0 813])
    ylim([minval*1.15, max(10, -0.05*minval)])
    box off;
    line([0 813], [0 0],'color',[0 0 0]);
    line([200 200], [minval*0.9  minval*0.9+100],'color',[0 0 0]);
    line([200 300], [minval*0.9  minval*0.9],'color',[0 0 0]);
    hold off; 
    box off;
    axis off;
end
