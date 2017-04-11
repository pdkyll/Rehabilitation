function data = parsing_kinematic_for_knee(data, list_fields, E)

%---------------------------------------------------------------
% Find foot off point
%---------------------------------------------------------------
idx_MST_L = round(data.IDS_pct_L + data.SS_pct_L/2);
idx_MST_R = round(data.IDS_pct_R + data.SS_pct_R/2);
idx_ST_L = round(data.ST_pct_L);
idx_ST_R = round(data.ST_pct_R);


%---------------------------------------------------------------
% Loadding Data (Left - Knee)
%---------------------------------------------------------------
idx_KFlex_L = find_index_having_field('l.kn.angle',list_fields);
KFlex_L     = cell2mat(E(idx_KFlex_L));


% Fl_IC - initial point
data.Knee_Fl_IC_angle_L = KFlex_L(1);

% Fl_ST - maximum value
if checkIndex(idx_MST_L),
    [Fl_val1, Fl_id1]       = max(KFlex_L(1:idx_MST_L));
    data.Knee_Fl_ST_time_L  = Fl_id1-1;
    data.Knee_Fl_ST_angle_L = Fl_val1;
end


% Ex_ST - minimum value
if checkIndex(idx_MST_L) && checkIndex(idx_ST_L),
    [Ex_val1, Ex_id1]       = min(KFlex_L(idx_MST_L:idx_ST_L));
    data.Knee_Ex_ST_time_L  = idx_MST_L+Ex_id1-2;
    data.Knee_Ex_ST_angle_L = Ex_val1;
end


% Fl_SW - maximum value
if checkIndex(idx_ST_L),
    [Fl_val2, Fl_id2]       = max(KFlex_L(idx_ST_L:end));
    data.Knee_Fl_SW_time_L  = idx_ST_L+Fl_id2-2;
    data.Knee_Fl_SW_angle_L = Fl_val2;
end


%---------------------------------------------------------------
% Loading Data (Right - Knee)
%---------------------------------------------------------------
idx_KFlex_R = find_index_having_field('r.kn.angle',list_fields);
KFlex_R     = cell2mat(E(idx_KFlex_R));


% Fl_IC - initial point
data.Knee_Fl_IC_angle_R = KFlex_R(1);


% Fl_ST - maximum value
if checkIndex(idx_MST_R),
    [Fl_val1, Fl_id1]       = max(KFlex_R(1:idx_MST_R));
    data.Knee_Fl_ST_time_R  = Fl_id1-1;
    data.Knee_Fl_ST_angle_R = Fl_val1;
end

% Ex_ST - minimum value
if checkIndex(idx_MST_R) && checkIndex(idx_ST_R),
    [Ex_val1, Ex_id1]       = min(KFlex_R(idx_MST_R:idx_ST_R));
    data.Knee_Ex_ST_time_R  = idx_MST_R+Ex_id1-2;
    data.Knee_Ex_ST_angle_R = Ex_val1;
end

% Fl_SW - maximum value
if checkIndex(idx_ST_R),
    [Fl_val2, Fl_id2]       = max(KFlex_R(idx_ST_R:end));
    data.Knee_Fl_SW_time_R  = idx_ST_R+Fl_id2-2;
    data.Knee_Fl_SW_angle_R = Fl_val2;
end