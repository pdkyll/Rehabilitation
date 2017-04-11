function data = parsing_kinetic_for_knee(raw, data)

hdr = raw(1,:);
dat = raw(2:end,:);


%---------------------------------------------------------------
% Find foot off point
%---------------------------------------------------------------

idx_ST_L = round(data.ST_pct_L/2);
idx_ST_R = round(data.ST_pct_R/2);


%---------------------------------------------------------------
% Left - Knee
%---------------------------------------------------------------

% Knee Angle
ida     = find_column_number(hdr,'KFlex A');
KFlex_L = cell2mat(dat(2:52,ida));

% Knee Flexion Moment
ida      = find_column_number(hdr,'KMFlex A');
KMFlex_L = cell2mat(dat(2:52,ida));

% Total Knee Power
ida      = find_column_number(hdr,'KPTot A');
KPTot_L  = cell2mat(dat(2:52,ida));


if ~isnan(idx_ST_L),
    % From Min-Max Knee Flexion Moment
    [M_val1, M_id1]          = max(KMFlex_L(1:idx_ST_L));
    data.Knee_MO_max_time_L  = 100*(M_id1-1)/50;
    data.Knee_MO_max_value_L = M_val1;
    data.Knee_MO_max_power_L = KPTot_L(M_id1);
    data.Knee_MO_max_angle_L = KFlex_L(M_id1);
    
    [M_val2, M_id2]          = min(KMFlex_L(1:idx_ST_L));
    data.Knee_MO_min_time_L  = 100*(M_id2-1)/50;
    data.Knee_MO_min_value_L = M_val2;
    data.Knee_MO_min_power_L = KPTot_L(M_id2);
    data.Knee_MO_min_angle_L = KFlex_L(M_id2);
    
    
    % From Total Knee Power
    [M_val3, M_id3]           = max(KPTot_L(1:idx_ST_L));
    data.Knee_PO_max_time_L   = 100*(M_id3-1)/50;
    data.Knee_PO_max_value_L  = M_val3;
    data.Knee_PO_max_moment_L = KMFlex_L(M_id3);
    data.Knee_PO_max_angle_L  = KFlex_L(M_id3);
    
    [M_val4, M_id4]           = min(KPTot_L(1:idx_ST_L));
    data.Knee_PO_min_time_L   = 100*(M_id4-1)/50;
    data.Knee_PO_min_value_L  = M_val4;
    data.Knee_PO_min_moment_L = KMFlex_L(M_id4);
    data.Knee_PO_min_angle_L  = KFlex_L(M_id4);
end


%---------------------------------------------------------------
% Right - Knee
%---------------------------------------------------------------

% Knee Angle
ida     = find_column_number(hdr,'KFlex B');
KFlex_R = cell2mat(dat(2:52,ida));

% Knee Flexion Moment
idb      = find_column_number(hdr,'KMFlex B');
KMFlex_R = cell2mat(dat(2:52,idb));

% Total Knee Power
idb      = find_column_number(hdr,'KPTot B');
KPTot_R  = cell2mat(dat(2:52,idb));


if ~isnan(idx_ST_R),
    
    % From Min-Max Knee Flexion Moment
    [M_val1, M_id1]          = max(KMFlex_R(1:idx_ST_R));
    data.Knee_MO_max_time_R  = 100*(M_id1-1)/50;
    data.Knee_MO_max_value_R = M_val1;
    data.Knee_MO_max_power_R = KPTot_R(M_id1);
    data.Knee_MO_max_angle_R = KFlex_R(M_id1);
    
    [M_val2, M_id2]          = min(KMFlex_R(1:idx_ST_R));
    data.Knee_MO_min_time_R  = 100*(M_id2-1)/50;
    data.Knee_MO_min_value_R = M_val2;
    data.Knee_MO_min_power_R = KPTot_R(M_id2);
    data.Knee_MO_min_angle_R = KFlex_R(M_id2);
    
    
    % From Total Knee Power
    [M_val3, M_id3]           = max(KPTot_R(1:idx_ST_R));
    data.Knee_PO_max_time_R   = 100*(M_id3-1)/50;
    data.Knee_PO_max_value_R  = M_val3;
    data.Knee_PO_max_moment_R = KMFlex_R(M_id3);
    data.Knee_PO_max_angle_R  = KFlex_R(M_id3);
    
    [M_val4, M_id4]           = min(KPTot_R(1:idx_ST_R));
    data.Knee_PO_min_time_R   = 100*(M_id4-1)/50;
    data.Knee_PO_min_value_R  = M_val4;
    data.Knee_PO_min_moment_R = KMFlex_R(M_id4);
    data.Knee_PO_min_angle_R  = KFlex_R(M_id4);
end
