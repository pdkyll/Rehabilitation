function data = parsing_kinetic_for_hip(data, list_fields, E)


%---------------------------------------------------------------
% Find foot off point
%---------------------------------------------------------------
idx_ST_L = round(data.ST_pct_L);
idx_ST_R = round(data.ST_pct_R);


%---------------------------------------------------------------
% Loading Data (Left - Hip)
%---------------------------------------------------------------
% Angle
idx_HFlex_L  = find_index_having_field('l.hi.angle',list_fields);
HFlex_L      = cell2mat(E(idx_HFlex_L));

% Momentum
idx_HMFlex_L = find_index_having_field('l.hi.moment',list_fields);
HMFlex_L     = cell2mat(E(idx_HMFlex_L));

% Total Hip Power
idx_HPTot_L  = find_index_having_field('l.hi.power',list_fields);
HPTot_L      = cell2mat(E(idx_HPTot_L));


if ~isnan(idx_ST_L) && idx_ST_L<100,
    % From Min-Max Hip Flexion Moment
    [M_val1, M_id1]         = max(HMFlex_L(1:idx_ST_L));
    data.Hip_MO_max_time_L  = M_id1-1;
    data.Hip_MO_max_value_L = M_val1;
    data.Hip_MO_max_power_L = HPTot_L(M_id1);
    data.Hip_MO_max_angle_L = HFlex_L(M_id1);
    
    [M_val2, M_id2]         = min(HMFlex_L(1:idx_ST_L));
    data.Hip_MO_min_time_L  = M_id2-1;
    data.Hip_MO_min_value_L = M_val2;
    data.Hip_MO_min_power_L = HPTot_L(M_id2);
    data.Hip_MO_min_angle_L = HFlex_L(M_id2);
    
    
    % From Min-Max Total Hip Power
    [M_val3, M_id3]          = max(HPTot_L(1:idx_ST_L));
    data.Hip_PO_max_time_L   = M_id3-1;
    data.Hip_PO_max_value_L  = M_val3;
    data.Hip_PO_max_moment_L = HMFlex_L(M_id3);
    data.Hip_PO_max_angle_L  = HFlex_L(M_id3);
    
    [M_val4, M_id4]          = min(HPTot_L(1:idx_ST_L));
    data.Hip_PO_min_time_L   = M_id4-1;
    data.Hip_PO_min_value_L  = M_val4;
    data.Hip_PO_min_moment_L = HMFlex_L(M_id4);
    data.Hip_PO_min_angle_L  = HFlex_L(M_id4);
end



%---------------------------------------------------------------
% Loading Data (Right - Hip)
%---------------------------------------------------------------
% Angle
idx_HFlex_R  = find_index_having_field('r.hi.angle',list_fields);
HFlex_R      = cell2mat(E(idx_HFlex_R));


% Momentum
idx_HMFlex_R = find_index_having_field('r.hi.moment',list_fields);
HMFlex_R     = cell2mat(E(idx_HMFlex_R));


% Total Hip Power
idx_HPTot_R  = find_index_having_field('r.hi.power',list_fields);
HPTot_R      = cell2mat(E(idx_HPTot_R));


if ~isnan(idx_ST_R) && idx_ST_R<100,
    % From Min-Max Hip Flexion Moment
    [M_val1, M_id1]         = max(HMFlex_R(1:idx_ST_R));
    data.Hip_MO_max_time_R  = M_id1-1;
    data.Hip_MO_max_value_R = M_val1;
    data.Hip_MO_max_power_R = HPTot_R(M_id1);
    data.Hip_MO_max_angle_R = HFlex_R(M_id1);
    
    [M_val2, M_id2]         = min(HMFlex_R(1:idx_ST_R));
    data.Hip_MO_min_time_R  = M_id2-1;
    data.Hip_MO_min_value_R = M_val2;
    data.Hip_MO_min_power_R = HPTot_R(M_id2);
    data.Hip_MO_min_angle_R = HFlex_R(M_id2);
    
    
    % From Min-Max Total Hip Power
    [M_val3, M_id3]          = max(HPTot_R(1:idx_ST_R));
    data.Hip_PO_max_time_R   = M_id3-1;
    data.Hip_PO_max_value_R  = M_val3;
    data.Hip_PO_max_moment_R = HMFlex_R(M_id3);
    data.Hip_PO_max_angle_R  = HFlex_R(M_id3);
    
    [M_val4, M_id4]          = min(HPTot_R(1:idx_ST_R));
    data.Hip_PO_min_time_R   = M_id4-1;
    data.Hip_PO_min_value_R  = M_val4;
    data.Hip_PO_min_moment_R = HMFlex_R(M_id4);
    data.Hip_PO_min_angle_R  = HFlex_R(M_id4);
end