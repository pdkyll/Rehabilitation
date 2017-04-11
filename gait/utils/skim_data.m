function T = skim_data(T_in,list_of_vars, CL, flipMode)
T = T_in(T_in.CL==CL,:);
if nargin<4, flipMode=0; end;

if flipMode==1,
    for i=1:length(list_of_vars),
        var_name = list_of_vars{i};
        if strcmp(var_name(end-1:end),'_L'),
            var_L = [var_name(1:end-2) '_L'];
            var_R = [var_name(1:end-2) '_R'];
            T(T.AS==2, cellstr(var_L)) = T_in(T_in.AS==2 & T_in.CL==CL, cellstr(var_R));
            T(T.AS==2, cellstr(var_R)) = T_in(T_in.AS==2 & T_in.CL==CL, cellstr(var_L));
        end
    end
elseif flipMode==2,
    for i=1:length(list_of_vars),
        var_name = list_of_vars{i};
        if strcmp(var_name(end-1:end),'_L'),
            var_L = [var_name(1:end-2) '_L'];
            var_R = [var_name(1:end-2) '_R'];
            T(T.ST_sec_L>T.ST_sec_R, cellstr(var_L)) = T_in(T_in.ST_sec_L>T_in.ST_sec_R & T_in.CL==CL, cellstr(var_R));
            T(T.ST_sec_L>T.ST_sec_R, cellstr(var_R)) = T_in(T_in.ST_sec_L>T_in.ST_sec_R & T_in.CL==CL, cellstr(var_L));
        end
    end
end
T = T(:,list_of_vars);
