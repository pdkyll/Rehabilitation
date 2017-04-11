function data = parsing_kinematic_for_ankle(raw, data)

hdr = raw(1,:);
dat = raw(2:end,:);


%---------------------------------------------------------------
% Find foot off point
%---------------------------------------------------------------
ida        = find_column_number(hdr,'Foot Off A');
foot_off_A = cell2mat(dat(2:52,ida));
idxOFC     = find(foot_off_A>10);


%---------------------------------------------------------------
% Left - Ankle
%---------------------------------------------------------------
idxOFO_L   = round(data.IDS_pct_L/2);
idx_ST_L   = round(data.ST_pct_L/2);
idxFO_L    = round((data.IDS_pct_L+data.SS_pct_L+data.TDS_pct_L)/2);
if isnan(idxOFO_L), idxOFO_L=5; end;
ida        = find_column_number(hdr,'FDor A');
FDor_L     = cell2mat(dat(2:52,ida));


% A_DF_IC - initial point (A1)
data.Ankle_DF_IC_angle_L = FDor_L(1);


% A_PF_ST - minimum peak (A2)
if checkIndex(idxOFO_L),
    [A_val2, A_id2]  = min(FDor_L(1:idxOFO_L));
    data.Ankle_PF_ST_time_L  = 100*(A_id2-1)/50;
    data.Ankle_PF_ST_angle_L = A_val2;
end

% A_DF_ST - maximum peak (A3)
if checkIndex(idx_ST_L)
    [A_val3, A_id3] = max(FDor_L(1:idx_ST_L));
    data.Ankle_DF_ST_time_L  = 100*(A_id3-1)/50;
    data.Ankle_DF_ST_angle_L = A_val3;
end

% A_PF_SW - minimum peak (A4)
try, [A_val4, A_id4] = findpeaks(-FDor_L(idxOFC:end),'NPeaks',1,'SortStr','descend'); 
catch, A_val4=''; A_id4=''; end
if isempty(A_val4),
    [A_val4, A_id4] = min(FDor_L(idxOFC:end));
    A_val4 = -A_val4;
end
try, [A_val5, A_id5] = findpeaks(FDor_L(idxOFC:end),'NPeaks',1,'SortStr','descend');
catch, A_val5 = NaN;   A_id5 = NaN; end
if isempty(A_val5),
    [A_val5, A_id5] = max(FDor_L(idxOFC:end));
end

if A_id4>A_id5,
    A_val4 = -1*FDor_L(idxOFC);
    A_id4  = 1;
end
data.Ankle_PF_SW_time_L  = 100*(idxOFC+A_id4-2)/50;
data.Ankle_PF_SW_angle_L = -1*A_val4;


% A_DF_SW - maximum peak (A5)
data.Ankle_DF_SW_time_L  = 100*(idxOFC+A_id5-2)/50;
data.Ankle_DF_SW_angle_L = A_val5;
clear FDor_L;


%---------------------------------------------------------------
% Right - Ankle
%---------------------------------------------------------------
idxOFO_R   = round(data.IDS_pct_R/2);
idx_ST_R   = round(data.ST_pct_R/2);
idxFO_R    = round((data.IDS_pct_R+data.SS_pct_R+data.TDS_pct_R)/2);
if isnan(idxOFO_R), idxOFO_R=5; end;
idb        = find_column_number(hdr,'FDor B');
FDor_R     = cell2mat(dat(2:52,idb));

% A_DF_IC - initial point (A1)
data.Ankle_DF_IC_angle_R = FDor_R(1);


% A_PF_ST - minimum peak (A2)
clear A_val2 A_id2;
if checkIndex(idxOFO_R)
    [A_val2, A_id2] = min(FDor_R(1:idxOFO_R));
    data.Ankle_PF_ST_time_R  = 100*(A_id2-1)/50;
    data.Ankle_PF_ST_angle_R = A_val2;
end

% A_DF_ST - maximum peak (A3)
clear A_Val3 A_id3;
if checkIndex(idx_ST_R)
    [A_val3, A_id3] = max(FDor_R(1:idx_ST_R));    
    data.Ankle_DF_ST_time_R  = 100*(A_id3-1)/50;
    data.Ankle_DF_ST_angle_R = A_val3;
end

% A_PF_SW - minimum peak (A4)
clear A_val4 A_id4;
try, [A_val4, A_id4] = findpeaks(-FDor_R(idxOFC:end),'NPeaks',1,'SortStr','descend'); 
catch, A_val4=''; A_id4=''; end
if isempty(A_val4),
    [A_val4, A_id4] = min(FDor_R(idxOFC:end));
    A_val4 = -A_val4;
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
data.Ankle_PF_SW_time_R  = 100*(idxOFC+A_id4-2)/50;
data.Ankle_PF_SW_angle_R = -1*A_val4;

% A_DF_SW - maximum peak (A5)
data.Ankle_DF_SW_time_R  = 100*(idxOFC+A_id5-2)/50;
data.Ankle_DF_SW_angle_R = A_val5;

