function data = parsing_kinematic_for_hip(raw, data)

hdr = raw(1,:);
dat = raw(2:end,:);


%---------------------------------------------------------------
% Find foot off point
%---------------------------------------------------------------

idx_ST_L = round(data.ST_pct_L/2);
idx_ST_R = round(data.ST_pct_R/2);


%---------------------------------------------------------------
% Left - Hip
%---------------------------------------------------------------
ida     = find_column_number(hdr,'HFlex A');
HFlex_L = cell2mat(dat(2:52,ida));

% Fl_IC - initial point
data.Hip_Fl_IC_angle_L = HFlex_L(1);

if ~isnan(idx_ST_L),
    
    % Ex_ST - minimum value
    [Fl_val, Fl_id]        = min(HFlex_L(1:idx_ST_L));
    data.Hip_Ex_ST_angle_L = Fl_val;
    data.Hip_Ex_ST_time_L  = 100*(Fl_id-1)/50;
    
    % Fl_SW - maximum value
    [Ex_val, Ex_id]        = max(HFlex_L(idx_ST_L:end));
    data.Hip_Fl_SW_angle_L = Ex_val;
    data.Hip_Fl_SW_time_L  = 100*(Ex_id+idx_ST_L-2)/50;
end


%---------------------------------------------------------------
% Right - Hip
%---------------------------------------------------------------
idb     = find_column_number(hdr,'HFlex B');
HFlex_R = cell2mat(dat(2:52,idb));

% Fl_IC - initlal point
data.Hip_Fl_IC_angle_R = HFlex_R(1);

if ~isnan(idx_ST_R),
    % Ex_ST - minimum value
    [Fl_val, Fl_id]        = min(HFlex_R(1:idx_ST_R));
    data.Hip_Ex_ST_angle_R = Fl_val;
    data.Hip_Ex_ST_time_R  = 100*(Fl_id-1)/50;
    
    % Fl_SW - maximum value
    [Ex_val, Ex_id]        = max(HFlex_R(idx_ST_R:end));
    data.Hip_Fl_SW_angle_R = Ex_val;
    data.Hip_Fl_SW_time_R  = 100*(Ex_id+idx_ST_R-2)/50;
end