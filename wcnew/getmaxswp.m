
function maxswp = getmaxswp(S)
    maxswp = 0;
    Sfields = fields(S);
    for i = 1:length(Sfields)
        if strcmp(Sfields{i}(1:3), 'Swp')
            maxswp = maxswp + 1;
        end
    end