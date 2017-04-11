function data = parsing_kinematic_for_knee(raw, data)

hdr = raw(1,:);
dat = raw(2:end,:);


%---------------------------------------------------------------
% Find foot off point
%---------------------------------------------------------------
% ida         = find_column_number(hdr,'Foot Off A');
% foot_off_A  = cell2mat(dat(2:52,ida));
% idxOFC      = find(foot_off_A>10);

idx_MST_L = round((data.IDS_pct_L + data.SS_pct_L/2)/2);
idx_MST_R = round((data.IDS_pct_R + data.SS_pct_R/2)/2);
idx_ST_L = round(data.ST_pct_L/2);
idx_ST_R = round(data.ST_pct_R/2);

%---------------------------------------------------------------
% Left - Knee
%---------------------------------------------------------------
ida     = find_column_number(hdr,'KFlex A');
KFlex_L = cell2mat(dat(2:52,ida));

% Fl_IC - initial point
data.Knee_Fl_IC_angle_L = KFlex_L(1);


% Fl_ST - maximum value
if ~isnan(idx_MST_L),
    [Fl_val1, Fl_id1]       = max(KFlex_L(1:idx_MST_L));
    data.Knee_Fl_ST_time_L  = 100*(Fl_id1-1)/50;
    data.Knee_Fl_ST_angle_L = Fl_val1;
end


% Ex_ST - minimum value
if ~isnan(idx_MST_L) && ~isnan(idx_ST_L),
    [Ex_val1, Ex_id1]       = min(KFlex_L(idx_MST_L:idx_ST_L));
    data.Knee_Ex_ST_time_L  = 100*(idx_MST_L+Ex_id1-2)/50;
    data.Knee_Ex_ST_angle_L = Ex_val1;
end


% Fl_SW - maximum value
if ~isnan(idx_ST_L),
    [Fl_val2, Fl_id2]       = max(KFlex_L(idx_ST_L:end));
    data.Knee_Fl_SW_time_L  = 100*(idx_ST_L+Fl_id2-2)/50;
    data.Knee_Fl_SW_angle_L = Fl_val2;
end


%---------------------------------------------------------------
% Right - Knee
%---------------------------------------------------------------
idb     = find_column_number(hdr,'KFlex B');
KFlex_R = cell2mat(dat(2:52,idb));

% Fl_IC - initial point
data.Knee_Fl_IC_angle_R = KFlex_R(1);


% Fl_ST - maximum value
if ~isnan(idx_MST_R),
    [Fl_val1, Fl_id1]       = max(KFlex_R(1:idx_MST_R));
    data.Knee_Fl_ST_time_R  = 100*(Fl_id1-1)/50;
    data.Knee_Fl_ST_angle_R = Fl_val1;
end

% Ex_ST - minimum value
if ~isnan(idx_MST_R) && ~isnan(idx_ST_R),
    [Ex_val1, Ex_id1]       = min(KFlex_R(idx_MST_R:idx_ST_R));
    data.Knee_Ex_ST_time_R  = 100*(idx_MST_R+Ex_id1-2)/50;
    data.Knee_Ex_ST_angle_R = Ex_val1;
end

% Fl_SW - maximum value
if ~isnan(idx_ST_R),
    [Fl_val2, Fl_id2]       = max(KFlex_R(idx_ST_R:end));
    data.Knee_Fl_SW_time_R  = 100*(idx_ST_R+Fl_id2-2)/50;
    data.Knee_Fl_SW_angle_R = Fl_val2;
end
