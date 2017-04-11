function isvalid = checkIndex(idx)

isvalid = false;
if ~isnan(idx) && idx>0 && idx<100,
    isvalid = true;
end