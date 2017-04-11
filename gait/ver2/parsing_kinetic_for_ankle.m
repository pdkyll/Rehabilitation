function data = parsing_kinetic_for_ankle(data, list_fields, E)

%---------------------------------------------------------------
% Find foot off point
%---------------------------------------------------------------
idx_ST_L = round(data.ST_pct_L);
idx_ST_R = round(data.ST_pct_R);


%---------------------------------------------------------------
% Loading Data (Left - Ankle)
%---------------------------------------------------------------
% Ankle Angle
idx_FDor_L  = find_index_having_field('l.an.angle',list_fields);
FDor_L      = cell2mat(E(idx_FDor_L));

% Ankle Momentum
idx_FMDor_L = find_index_having_field('l.an.moment',list_fields);
FMDor_L     = cell2mat(E(idx_FMDor_L));

% Total Ankle Power
idx_APTot_L = find_index_having_field('l.an.power',list_fields);
APTot_L     = cell2mat(E(idx_APTot_L));


if ~isnan(idx_ST_L) && idx_ST_L<100,
    % From Min-Max Ankle Flexion Moment
    [M_val1, M_id1]           = max(FMDor_L(1:idx_ST_L));
    data.Ankle_MO_max_time_L  = M_id1-1;
    data.Ankle_MO_max_value_L = M_val1;
    data.Ankle_MO_max_power_L = APTot_L(M_id1);
    data.Ankle_MO_max_angle_L = FDor_L(M_id1);
    
    [M_val2, M_id2]           = min(FMDor_L(1:idx_ST_L));
    data.Ankle_MO_min_time_L  = M_id2-1;
    data.Ankle_MO_min_value_L = M_val2;
    data.Ankle_MO_min_power_L = APTot_L(M_id2);
    data.Ankle_MO_min_angle_L = FDor_L(M_id2);
    
    
    % From Min-Max Total Ankle Power
    [M_val3, M_id3]            = max(APTot_L(1:idx_ST_L));
    data.Ankle_PO_max_time_L   = M_id3-1;
    data.Ankle_PO_max_value_L  = M_val3;
    data.Ankle_PO_max_moment_L = FMDor_L(M_id3);
    data.Ankle_PO_max_angle_L  = FDor_L(M_id3);
    
    [M_val4, M_id4]            = min(APTot_L(1:idx_ST_L));
    data.Ankle_PO_min_time_L   = M_id4-1;
    data.Ankle_PO_min_value_L  = M_val4;
    data.Ankle_PO_min_moment_L = FMDor_L(M_id4);
    data.Ankle_PO_min_angle_L  = FDor_L(M_id4);
end


%---------------------------------------------------------------
% Loading Data (Right - Ankle)
%---------------------------------------------------------------
% Ankle Angle
idx_FDor_R  = find_index_having_field('r.an.angle',list_fields);
FDor_R      = cell2mat(E(idx_FDor_R));

% Ankle Momentum
idx_FMDor_R = find_index_having_field('r.an.moment',list_fields);
FMDor_R     = cell2mat(E(idx_FMDor_R));

% Total Ankle Power
idx_APTot_R = find_index_having_field('r.an.power',list_fields);
APTot_R     = cell2mat(E(idx_APTot_R));


if ~isnan(idx_ST_R) && idx_ST_R<100,
    % From Min-Max Ankle Flexion Moment
    [M_val1, M_id1]           = max(FMDor_R(1:idx_ST_R));
    data.Ankle_MO_max_time_R  = M_id1-1;
    data.Ankle_MO_max_value_R = M_val1;
    data.Ankle_MO_max_power_R = APTot_R(M_id1);
    data.Ankle_MO_max_angle_R = FDor_R(M_id1);
    
    [M_val2, M_id2]           = min(FMDor_R(1:idx_ST_R));
    data.Ankle_MO_min_time_R  = M_id2-1;
    data.Ankle_MO_min_value_R = M_val2;
    data.Ankle_MO_min_power_R = APTot_R(M_id2);
    data.Ankle_MO_min_angle_R = FDor_R(M_id2);
    
    
    % From Min-Max Total Ankle Power
    [M_val3, M_id3]            = max(APTot_R(1:idx_ST_R));
    data.Ankle_PO_max_time_R   = M_id3-1;
    data.Ankle_PO_max_value_R  = M_val3;
    data.Ankle_PO_max_moment_R = FMDor_R(M_id3);
    data.Ankle_PO_max_angle_R  = FDor_R(M_id3);
    
    [M_val4, M_id4]            = min(APTot_R(1:idx_ST_R));
    data.Ankle_PO_min_time_R   = M_id4-1;
    data.Ankle_PO_min_value_R  = M_val4;
    data.Ankle_PO_min_moment_R = FMDor_R(M_id4);
    data.Ankle_PO_min_angle_R  = FDor_R(M_id4);
end