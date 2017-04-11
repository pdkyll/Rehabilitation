function isvalid = checkIndex(idx)

isvalid = false;
if ~isnan(idx) && idx>0 && idx<50,
    isvalid = true;
end