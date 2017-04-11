function data = parsing_kinetic_for_knee(data, list_fields, E)


%---------------------------------------------------------------
% Find stance point
%---------------------------------------------------------------
idx_ST_L = round(data.ST_pct_L);
idx_ST_R = round(data.ST_pct_R);


%---------------------------------------------------------------
% Loading Data (Left - Knee)
%---------------------------------------------------------------
% Knee Angle
idx_KFlex_L  = find_index_having_field('l.kn.angle',list_fields);
KFlex_L      = cell2mat(E(idx_KFlex_L));


% Knee Momentum
idx_KMFlex_L = find_index_having_field('l.kn.moment',list_fields);
KMFlex_L     = cell2mat(E(idx_KMFlex_L));


% Total Knee Power
idx_KPTot_L  = find_index_having_field('l.kn.power',list_fields);
KPTot_L      = cell2mat(E(idx_KPTot_L));


if ~isnan(idx_ST_L) && idx_ST_L<100,
    % From Min-Max Knee Flexion Moment
    [M_val1, M_id1]          = max(KMFlex_L(1:idx_ST_L));
    data.Knee_MO_max_time_L  = M_id1-1;
    data.Knee_MO_max_value_L = M_val1;
    data.Knee_MO_max_power_L = KPTot_L(M_id1);
    data.Knee_MO_max_angle_L = KFlex_L(M_id1);
    
    [M_val2, M_id2]          = min(KMFlex_L(1:idx_ST_L));
    data.Knee_MO_min_time_L  = M_id2-1;
    data.Knee_MO_min_value_L = M_val2;
    data.Knee_MO_min_power_L = KPTot_L(M_id2);
    data.Knee_MO_min_angle_L = KFlex_L(M_id2);
    
    
    
    % From Min-Max Total Knee Power
    [M_val3, M_id3]           = max(KPTot_L(1:idx_ST_L));
    data.Knee_PO_max_time_L   = M_id3-1;
    data.Knee_PO_max_value_L  = M_val3;
    data.Knee_PO_max_moment_L = KMFlex_L(M_id3);
    data.Knee_PO_max_angle_L  = KFlex_L(M_id3);
    
    [M_val4, M_id4]           = min(KPTot_L(1:idx_ST_L));
    data.Knee_PO_min_time_L   = M_id4-1;
    data.Knee_PO_min_value_L  = M_val4;
    data.Knee_PO_min_moment_L = KMFlex_L(M_id4);
    data.Knee_PO_min_angle_L  = KFlex_L(M_id4);
end


%---------------------------------------------------------------
% Right - Knee
%---------------------------------------------------------------
% Knee Angle
idx_KFlex_R  = find_index_having_field('r.kn.angle',list_fields);
KFlex_R      = cell2mat(E(idx_KFlex_R));

% Knee Momentum
idx_KMFlex_R = find_index_having_field('r.kn.moment',list_fields);
KMFlex_R     = cell2mat(E(idx_KMFlex_R));


% Total Knee Power
idx_KPTot_R  = find_index_having_field('r.kn.power',list_fields);
KPTot_R      = cell2mat(E(idx_KPTot_R));


if ~isnan(idx_ST_R) && idx_ST_R<100,
    % From Min-Max Knee Flexion Moment
    [M_val1, M_id1]          = max(KMFlex_R(1:idx_ST_R));
    data.Knee_MO_max_time_R  = M_id1-1;
    data.Knee_MO_max_value_R = M_val1;
    data.Knee_MO_max_power_R = KPTot_R(M_id1);
    data.Knee_MO_max_angle_R = KFlex_R(M_id1);
    
    [M_val2, M_id2]          = min(KMFlex_R(1:idx_ST_R));
    data.Knee_MO_min_time_R  = M_id2-1;
    data.Knee_MO_min_value_R = M_val2;
    data.Knee_MO_min_power_R = KPTot_R(M_id2);
    data.Knee_MO_min_angle_R = KFlex_R(M_id2);
    
    
    % From Min-Max Total Knee Power
    [M_val3, M_id3]           = max(KPTot_R(1:idx_ST_R));
    data.Knee_PO_max_time_R   = M_id3-1;
    data.Knee_PO_max_value_R  = M_val3;
    data.Knee_PO_max_moment_R = KMFlex_R(M_id3);
    data.Knee_PO_max_angle_R  = KFlex_R(M_id3);
    
    [M_val4, M_id4]           = min(KPTot_R(1:idx_ST_R));
    data.Knee_PO_min_time_R   = M_id4-1;
    data.Knee_PO_min_value_R  = M_val4;
    data.Knee_PO_min_moment_R = KMFlex_R(M_id4);
    data.Knee_PO_min_angle_R  = KFlex_R(M_id4);
end