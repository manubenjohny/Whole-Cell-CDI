
function maxrun = getmaxrun(S)
    maxrun = 0;
    Sfields = fields(S);
    for i = 1:length(Sfields)
        if strcmp(Sfields{i}(1:3), 'Run')
            maxrun = maxrun + 1;
        end
    end