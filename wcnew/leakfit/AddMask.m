function AddMask()
HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');
HGUI2 = FInfo2.HGUI2;
time = FInfo2.leakfitData.time;

curMasks = get(HGUI2.Mask, 'string');
if isempty(curMasks)
    curMasks = {};
end
axes(HGUI2.AxLkfit)
[x,~] = ginput(2);
% disp([x(1),x(2)])
t = zeros(size(x));
for i = 1:length(x)
    [~,ind] = min(abs(time-x(i)));
    t(i) = time(ind);
end
% t(1) = time(find(((time-x(1)).^2)==min((time-x(1)).^2)));
% t(2) = time(find(((time-x(2)).^2)==min((time-x(2)).^2)));
t = sort(t);
mytext = [num2str(t(1)),',',num2str(t(2))];
curMasks(length(curMasks)+1)={mytext};
set(HGUI2.Mask,'string',curMasks);

FInfo2.leakfitData.curMasks = curMasks;
FInfo2.HGUI2 = HGUI2;
set(HFleakfit, 'UserData', FInfo2);

ChangeFit();
zoom xon
