function lkftParamsMx = ParamsStruct2Mx (leakfitParams)
structFields = fields(leakfitParams);
lkftParamsMx = zeros(length(structFields), 1);
for i = 1:length(structFields)-1
    lkftParamsMx(i) = leakfitParams.(structFields{i});
end

