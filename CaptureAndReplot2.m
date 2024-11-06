function CaptureAndReplot2()
gxlines = get(gca,'children');
for i = 1: length(gxlines)
    Dat(i).X = get(gxlines(i),'xdata');
    Dat(i).Y = get(gxlines(i),'ydata');    
end
figure; 
ax = axes('units','centimeters','position',[1.5 1.5 12 3]);
col = zeros(length(gxlines),3);%jet(length(gxlines)+1); 
hold on;
minval = 0;
for i = 1:length(Dat)
    plot(Dat(i).X, Filt2(Dat(i).X',Dat(i).Y',900),'color',col(length(Dat)-i+1,:),'linewidth',0.5)
%     minval = min(minval, min(Dat(i).Y(Dat(i).X<50)));
end 
xlim([0 1050])
ylim([-4 0.8])

box off;
line([0 1050], [0 0],'color',[0 0 0]);
line([100 200], [0.3 0.3],'color',[0 0 0]);

line([50 50], [-2.5 -1.5],'color',[0 0 0]);
% line([100 300], [minval*0.9  minval*0.9],'color',[0 0 0]);
hold off; 
box off;
axis off;