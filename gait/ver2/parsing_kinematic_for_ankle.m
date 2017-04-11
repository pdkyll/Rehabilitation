function data = parsing_kinematic_for_ankle(data, list_fields, E)


%---------------------------------------------------------------
% Find foot off point
%---------------------------------------------------------------
OFC    = data.IDS_pct_R + data.SS_pct_R;
idxOFC = ceil(OFC);
if idxOFC>100,
    OFC     = data.IDS_pct_L + data.SS_pct_L;
    idxOFC  = ceil(OFC);
end
if idxOFC>100, return; end


%---------------------------------------------------------------
% Loading Data (Left - Ankle)
%---------------------------------------------------------------
idxOFO_L   = round(data.IDS_pct_L);
idx_ST_L   = round(data.ST_pct_L);
idxFO_L    = round((data.IDS_pct_L+data.SS_pct_L+data.TDS_pct_L));
if isnan(idxOFO_L), idxOFO_L=5; end;
idx_FDor_L = find_index_having_field('l.an.angle',list_fields);
FDor_L     = cell2mat(E(idx_FDor_L));


% A_DF_IC - initial point (A1)
data.Ankle_DF_IC_angle_L = FDor_L(1);


% A_PF_ST - minimum peak (A2)
if checkIndex(idxOFO_L),
    [A_val2, A_id2] = min(FDor_L(1:idxOFO_L));
    data.Ankle_PF_ST_time_L  = A_id2-1;
    data.Ankle_PF_ST_angle_L = A_val2;
end


% A_DF_ST - maximum peak (A3)
if checkIndex(idx_ST_L),
    [A_val3, A_id3] = max(FDor_L(1:idx_ST_L));
    data.Ankle_DF_ST_time_L  = A_id3-1;
    data.Ankle_DF_ST_angle_L = A_val3;
end

% A_PF_SW - minimum peak (A4)
try, [A_val4, A_id4] = findpeaks(-FDor_L(idxOFC:end),'NPeaks',1,'SortStr','descend');
catch, A_val4=''; A_id4=''; end
if isempty(A_val4),
    try
        [A_val4, A_id4] = min(FDor_L(idxOFC:end));
        A_val4 = -A_val4;
    catch
        A_val4 = nan;
        A_id4  = nan;
    end
end

try, [A_val5, A_id5] = findpeaks(FDor_L(idxOFC:end),'NPeaks',1,'SortStr','descend');
catch, A_val5 = NaN;   A_id5 = NaN; end
if isempty(A_val5),
    try
        [A_val5, A_id5] = max(FDor_L(idxOFC:end));
    catch
        A_val5 = nan;
        A_id5  = nan;
    end
end

if A_id4>A_id5,
    A_val4 = -1*FDor_L(idxOFC);
    A_id4  = 1;
end
data.Ankle_PF_SW_time_L  = idxOFC+A_id4-2;
data.Ankle_PF_SW_angle_L = -1*A_val4;


% A_DF_SW - maximum peak (A5)
data.Ankle_DF_SW_time_L  = idxOFC+A_id5-2;
data.Ankle_DF_SW_angle_L = A_val5;
clear FDor_L;


%---------------------------------------------------------------
% Loading Data (Right - Ankle)
%---------------------------------------------------------------
idxOFO_R   = round(data.IDS_pct_R);
idxFO_R    = round((data.IDS_pct_R+data.SS_pct_R+data.TDS_pct_R));
idx_ST_R   = round(data.ST_pct_R);

if isnan(idxOFO_R), idxOFO_R=5; end;
idx_FDor_R = find_index_having_field('r.an.angle',list_fields);
FDor_R     = cell2mat(E(idx_FDor_R));


% A_DF_IC - initial point (A1)
data.Ankle_DF_IC_angle_R = FDor_R(1);


% A_PF_ST - minimum peak (A2)
if checkIndex(idxOFO_R),
    [A_val2, A_id2] = min(FDor_R(1:idxOFO_R));
    data.Ankle_PF_ST_time_R  = A_id2-1;
    data.Ankle_PF_ST_angle_R = A_val2;
end

% A_DF_ST - maximum peak (A3)
if checkIndex(idx_ST_R),
    [A_val3, A_id3] = max(FDor_R(1:idx_ST_R));
    data.Ankle_DF_ST_time_R  = A_id3-1;
    data.Ankle_DF_ST_angle_R = A_val3;
end

% A_PF_SW - minimum peak (A4)
clear A_val4 A_id4;
try, [A_val4, A_id4] = findpeaks(-FDor_R(idxOFC:end),'NPeaks',1,'SortStr','descend');
catch, A_val4=''; A_id4=''; end
if isempty(A_val4),
    try
        [A_val4, A_id4] = min(FDor_R(idxOFC:end));
        A_val4 = -A_val4;
    catch
        A_val4 = nan;
        A_id4  = nan;
    end
end
clear A_val5 A_id5;
try, [A_val5, A_id5] = findpeaks(FDor_R(idxOFC:end),'NPeaks',1,'SortStr','descend');
catch, A_val5 = nan; A_id5 = nan; end
if isempty(A_val5),
    [A_val5, A_id5] = max(FDor_R(idxOFC:end));
end

if A_id4>A_id5,
    A_val4 = -1*FDor_R(idxOFC);
    A_id4  = 1;
end
data.Ankle_PF_SW_time_R  = idxOFC+A_id4-2;
data.Ankle_PF_SW_angle_R = -1*A_val4;

% A_DF_SW - maximum peak (A5)
data.Ankle_DF_SW_time_R  = idxOFC+A_id5-2;
data.Ankle_DF_SW_angle_R = A_val5;

