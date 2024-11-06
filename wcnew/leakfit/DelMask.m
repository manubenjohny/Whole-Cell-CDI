
function DelMask()
HFleakfit = getappdata(0, 'HFleakfit');
FInfo2 = get(HFleakfit, 'UserData');
HGUI2 = FInfo2.HGUI2;

curMasks = get(HGUI2.Mask, 'string');
selected = get(HGUI2.Mask, 'value');
if isempty(curMasks)
    disp('Error: No Masks to delete')
    return;    
end
if (selected>1) && (selected<length(curMasks))
    newMasks = curMasks([1:selected-1,selected+1:length(curMasks)]);    
elseif (selected==length(curMasks))
    newMasks = curMasks(1:end-1);
elseif (selected==1)
    newMasks = curMasks(2:end);
end      
set(HGUI2.Mask,'string',newMasks);
if selected>length(newMasks)
    set(HGUI2.Mask,'Value',max(1,length(newMasks)));
end
ChangeFit()

