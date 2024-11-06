function keystroke(~, evd)
FInfo = get(gcf,'UserData'); 
HGUI = 	 FInfo.HGUI;
hlistbox = HGUI.Hlistbox;

% matDataFolders = FInfo.matDataFolders;
% matDataFolderSel = FInfo.matDataFolderSel;
% matDataFolder = matDataFolders{matDataFolderSel};

switch evd.Key
    case 'return'
        wcivcalrun()
    case 'comma'
        newswp('back')
    case 'period'
        newswp('next')        
    case 'rightarrow'
        newrun('next')
    case 'leftarrow'
        newrun('back')
    case 'downarrow'
        cur = get(hlistbox, 'value');
        maxval  = length(get(hlistbox,'string'));
        if cur<maxval
            set(hlistbox, 'value', cur+1)
            NEWFILE_LBox()
        end
    case 'uparrow'
        cur = get(hlistbox, 'value');
        if cur>1
            set(hlistbox, 'value', cur-1)
            NEWFILE_LBox()
        end        
    case 'space'
        holdswp('keep')
    case 'escape'
        holdswp('wipe')
    case 'c'
        print -dmeta        
    case 'hyphen'
        scale(0.975)
    case 'equal'
        scale(1.025)
end