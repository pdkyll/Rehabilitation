function data = parsing_kinetic_for_hip(raw, data)

hdr = raw(1,:);
dat = raw(2:end,:);


%---------------------------------------------------------------
% Find foot off point
%---------------------------------------------------------------
% ida        = find_column_number(hdr,'Foot Off A');
% foot_off_A = cell2mat(dat(2:52,ida));
% idxOFC     = find(foot_off_A>10);

idx_ST_L = round(data.ST_pct_L/2);
idx_ST_R = round(data.ST_pct_R/2);



%---------------------------------------------------------------
% Left - Hip
%---------------------------------------------------------------

% Hip Angle
ida     = find_column_number(hdr,'HFlex A');
HFlex_L = cell2mat(dat(2:52,ida));

% Hip Flexion Moment
ida      = find_column_number(hdr,'HMFlex A');
HMFlex_L = cell2mat(dat(2:52,ida));

% Total Hip Power
ida      = find_column_number(hdr,'HPTot A');
HPTot_L  = cell2mat(dat(2:52,ida));


if ~isnan(idx_ST_L),
    % From Min-Max Hip Flexion Moment
    [M_val1, M_id1] = max(HMFlex_L(1:idx_ST_L));
    data.Hip_MO_max_time_L  = 100*(M_id1-1)/50;
    data.Hip_MO_max_value_L = M_val1;
    data.Hip_MO_max_power_L = HPTot_L(M_id1);
    data.Hip_MO_max_angle_L = HFlex_L(M_id1);
    
    [M_val2, M_id2] = min(HMFlex_L(1:idx_ST_L));
    data.Hip_MO_min_time_L  = 100*(M_id2-1)/50;
    data.Hip_MO_min_value_L = M_val2;
    data.Hip_MO_min_power_L = HPTot_L(M_id2);
    data.Hip_MO_min_angle_L = HFlex_L(M_id2);
    
    
    % From Min-Max Total Hip Power
    [M_val3, M_id3]          = max(HPTot_L(1:idx_ST_L));
    data.Hip_PO_max_time_L   = 100*(M_id3-1)/50;
    data.Hip_PO_max_value_L  = M_val3;
    data.Hip_PO_max_moment_L = HMFlex_L(M_id3);
    data.Hip_PO_max_angle_L  = HFlex_L(M_id3);
    
    [M_val4, M_id4]          = min(HPTot_L(1:idx_ST_L));
    data.Hip_PO_min_time_L   = 100*(M_id4-1)/50;
    data.Hip_PO_min_value_L  = M_val4;
    data.Hip_PO_min_moment_L = HMFlex_L(M_id4);
    data.Hip_PO_min_angle_L  = HFlex_L(M_id4);
end



%---------------------------------------------------------------
% Right - Hip
%---------------------------------------------------------------

% Hip Angle
ida     = find_column_number(hdr,'HFlex B');
HFlex_R = cell2mat(dat(2:52,ida));


% Hip Flexion Moment
idb      = find_column_number(hdr,'HMFlex B');
HMFlex_R = cell2mat(dat(2:52,idb));

% Total Hip Power
idb      = find_column_number(hdr,'HPTot B');
HPTot_R  = cell2mat(dat(2:52,idb));


if ~isnan(idx_ST_R),
    % From Min-Max Hip Flexion Moment
    [M_val1, M_id1] = max(HMFlex_R(1:idx_ST_R));
    data.Hip_MO_max_time_R  = 100*(M_id1-1)/50;
    data.Hip_MO_max_value_R = M_val1;
    data.Hip_MO_max_power_R = HPTot_R(M_id1);
    data.Hip_MO_max_angle_R = HFlex_R(M_id1);
    
    [M_val2, M_id2] = min(HMFlex_R(1:idx_ST_R));
    data.Hip_MO_min_time_R  = 100*(M_id2-1)/50;
    data.Hip_MO_min_value_R = M_val2;
    data.Hip_MO_min_power_R = HPTot_R(M_id2);
    data.Hip_MO_min_angle_R = HFlex_R(M_id2);
    
    
    % From Min-Max Total Hip Power
    [M_val3, M_id3]          = max(HPTot_R(1:idx_ST_R));
    data.Hip_PO_max_time_R   = 100*(M_id3-1)/50;
    data.Hip_PO_max_value_R  = M_val3;
    data.Hip_PO_max_moment_R = HMFlex_R(M_id3);
    data.Hip_PO_max_angle_R  = HFlex_R(M_id3);
    
    [M_val4, M_id4]          = min(HPTot_R(1:idx_ST_R));
    data.Hip_PO_min_time_R   = 100*(M_id4-1)/50;
    data.Hip_PO_min_value_R  = M_val4;
    data.Hip_PO_min_moment_R = HMFlex_R(M_id4);
    data.Hip_PO_min_angle_R  = HFlex_R(M_id4);
end