function T = skim_normal(T_input,list_of_vars, CL)
T = T_input(T_input.CL==CL,:);
T = T(:,list_of_vars);
