function keystroke_plot(~, evd)

switch evd.Key
    
    case 'c'
        print -dmeta        
    case 's'
        filename = get(gcf,'name');
        folder = uigetdir(userpath);
        if folder ~= 0
            file = fullfile(folder,filename);
            savefig(file)
        end
    
end