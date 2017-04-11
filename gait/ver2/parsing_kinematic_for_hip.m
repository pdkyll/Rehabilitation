function data = parsing_kinematic_for_hip(data, list_fields, E)


%---------------------------------------------------------------
% Find foot off point
%---------------------------------------------------------------
idx_ST_L = round(data.ST_pct_L);
idx_ST_R = round(data.ST_pct_R);


%---------------------------------------------------------------
% Loading data (Left - Hip)
%---------------------------------------------------------------
idx_HFlex_L = find_index_having_field('l.hi.angle',list_fields);
HFlex_L     = cell2mat(E(idx_HFlex_L));

% Fl_IC - initial point
data.Hip_Fl_IC_angle_L = HFlex_L(1);

% Ex_ST - minimum value
if checkIndex(idx_ST_L),
    [Fl_val, Fl_id] = min(HFlex_L(1:idx_ST_L));
    data.Hip_Ex_ST_angle_L = Fl_val;
    data.Hip_Ex_ST_time_L  = Fl_id-1;
    
    % Fl_SW - maximum value
    [Ex_val, Ex_id]        = max(HFlex_L(idx_ST_L:end));
    data.Hip_Fl_SW_angle_L = Ex_val;
    data.Hip_Fl_SW_time_L  = Ex_id+idx_ST_L-2;
end


%---------------------------------------------------------------
% Loading data (Right - Hip)
%---------------------------------------------------------------
idx_HFlex_R = find_index_having_field('r.hi.angle',list_fields);
HFlex_R     = cell2mat(E(idx_HFlex_R));

% Fl_IC - initlal point
data.Hip_Fl_IC_angle_R = HFlex_R(1);

% Ex_ST - minimum value
if checkIndex(idx_ST_R),
    [Fl_val, Fl_id]        = min(HFlex_R(1:idx_ST_R));
    data.Hip_Ex_ST_angle_R = Fl_val;
    data.Hip_Ex_ST_time_R  = Fl_id-1;
    
    % Fl_SW - maximum value
    [Ex_val, Ex_id]        = max(HFlex_R(idx_ST_R:end));
    data.Hip_Fl_SW_angle_R = Ex_val;
    data.Hip_Fl_SW_time_R  = Ex_id+idx_ST_R-2;
end