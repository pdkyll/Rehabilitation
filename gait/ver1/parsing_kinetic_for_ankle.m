function data = parsing_kinetic_for_ankle(raw, data)

hdr = raw(1,:);
dat = raw(2:end,:);


%---------------------------------------------------------------
% Find foot off point
%---------------------------------------------------------------

idx_ST_L = round(data.ST_pct_L/2);
idx_ST_R = round(data.ST_pct_R/2);


%---------------------------------------------------------------
% Left - Ankle
%---------------------------------------------------------------

% Ankle - Angle
ida     = find_column_number(hdr,'FDor A');
FDor_L  = cell2mat(dat(2:52,ida));

% Ankle Flexion Moment
ida     = find_column_number(hdr,'FMDor A');
FMDor_L = cell2mat(dat(2:52,ida));

% Total Ankle Power
ida     = find_column_number(hdr,'APTot A');
APTot_L = cell2mat(dat(2:52,ida));


if ~isnan(idx_ST_L),
    % From Min-Max Ankle Flexion Moment
    [M_val1, M_id1]           = max(FMDor_L(1:idx_ST_L));
    data.Ankle_MO_max_time_L  = 100*(M_id1-1)/50;
    data.Ankle_MO_max_value_L = M_val1;
    data.Ankle_MO_max_power_L = APTot_L(M_id1);
    data.Ankle_MO_max_angle_L = FDor_L(M_id1);
    
    [M_val2, M_id2]           = min(FMDor_L(1:idx_ST_L));
    data.Ankle_MO_min_time_L  = 100*(M_id2-1)/50;
    data.Ankle_MO_min_value_L = M_val2;
    data.Ankle_MO_min_power_L = APTot_L(M_id2);
    data.Ankle_MO_min_angle_L = FDor_L(M_id2);
    
    
    % From Min-Max Total Ankle Power
    [M_val3, M_id3]            = max(APTot_L(1:idx_ST_L));
    data.Ankle_PO_max_time_L   = 100*(M_id3-1)/50;
    data.Ankle_PO_max_value_L  = M_val3;
    data.Ankle_PO_max_moment_L = FMDor_L(M_id3);
    data.Ankle_PO_max_angle_L  = FDor_L(M_id3);
    
    [M_val4, M_id4]            = min(APTot_L(1:idx_ST_L));
    data.Ankle_PO_min_time_L   = 100*(M_id4-1)/50;
    data.Ankle_PO_min_value_L  = M_val4;
    data.Ankle_PO_min_moment_L = FMDor_L(M_id4);
    data.Ankle_PO_min_angle_L  = FDor_L(M_id4);
end


%---------------------------------------------------------------
% Right - Ankle
%---------------------------------------------------------------

% Ankle - Angle
ida     = find_column_number(hdr,'FDor B');
FDor_R  = cell2mat(dat(2:52,ida));

% Ankle Flexion Moment
idb      = find_column_number(hdr,'FMDor B');
FMDor_R = cell2mat(dat(2:52,idb));

% Total Ankle Power
idb      = find_column_number(hdr,'APTot B');
APTot_R  = cell2mat(dat(2:52,idb));


if ~isnan(idx_ST_R),
    % From Min-Max Ankle Flexion Moment
    [M_val1, M_id1]           = max(FMDor_R(1:idx_ST_R));
    data.Ankle_MO_max_time_R  = 100*(M_id1-1)/50;
    data.Ankle_MO_max_value_R = M_val1;
    data.Ankle_MO_max_power_R = APTot_R(M_id1);
    data.Ankle_MO_max_angle_R = FDor_R(M_id1);
    
    [M_val2, M_id2]           = min(FMDor_R(1:idx_ST_R));
    data.Ankle_MO_min_time_R  = 100*(M_id2-1)/50;
    data.Ankle_MO_min_value_R = M_val2;
    data.Ankle_MO_min_power_R = APTot_R(M_id2);
    data.Ankle_MO_min_angle_R = FDor_R(M_id2);
    
    
    % From Min-Max Total Ankle Power
    [M_val3, M_id3]            = max(APTot_R(1:idx_ST_R));
    data.Ankle_PO_max_time_R   = 100*(M_id3-1)/50;
    data.Ankle_PO_max_value_R  = M_val3;
    data.Ankle_PO_max_moment_R = FMDor_R(M_id3);
    data.Ankle_PO_max_angle_R  = FDor_R(M_id3);
    
    [M_val4, M_id4]            = min(APTot_R(1:idx_ST_R));
    data.Ankle_PO_min_time_R   = 100*(M_id4-1)/50;
    data.Ankle_PO_min_value_R  = M_val4;
    data.Ankle_PO_min_moment_R = FMDor_R(M_id4);
    data.Ankle_PO_min_angle_R  = FDor_R(M_id4);
end