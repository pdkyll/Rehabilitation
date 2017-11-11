close all;
addpath('/Volumes/JetDrive/data/RM_kdh/matlabscripts/gait/utils');
addpath('/Volumes/JetDrive/data/RM_kdh/matlabscripts/gait');
addpath('/Volumes/JetDrive/data/RM_kdh/matlabscripts/utils/fdr_bh');

%--------------------------------------------------------------------------
% List of variables
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/data/RM_kdh/parkinson';
fn_xls = fullfile(proj_path,'demographic','list_of_variables.xlsx');
TT = readtable(fn_xls, 'Sheet' ,'New');
analVars = cell(0);
analVars{1} = 'subjid';
analVars{2} = 'Age';
Lst = TT.list_of_variables;
for i=1:size(TT,1),
    analVars{i+2} = Lst{i};
end
nvar = length(analVars);




%--------------------------------------------------------------------------
% Load subjlist list - Parkinson
%--------------------------------------------------------------------------
fprintf('    : Load subject list for PET + T1 analysis (parkinson group)\n');
fn_xls   = fullfile(proj_path,'demographic','parkinson_20170609_KSH.xlsx');
T_demographic = readtable(fn_xls);
subjid = T_demographic.subjid;
nsubj = size(subjid);



%--------------------------------------------------------------------------
% Load GAIT data - Parkinson
%--------------------------------------------------------------------------
fprintf('    : Load GAIT data and skim dataset (parkinson group)\n');
fn_xls = fullfile(proj_path,'demographic','gait_final_dataset_n1329.xlsx');
T      = readtable(fn_xls);
T1     = skim_data(T, analVars, 7,  0); % skimmed data
T_pt   = table();
for c=1:nsubj,
    idx = find(T1.subjid==subjid(c));
    if isempty(idx)
        fprintf('no data for %d\n',subjid(c));
    else
        T_pt = [T_pt; T1(T1.subjid==subjid(c),:)];
    end
end



%--------------------------------------------------------------------------
% Load GAIT data - Normal Controls
%--------------------------------------------------------------------------
fprintf('    : Load GAIT and skim dataset (normal controls)\n');
fn_xls = fullfile(proj_path,'demographic','gait_final_dataset_n1329.xlsx');
T      = readtable(fn_xls);
T2     = skim_data(T, analVars, 6,  0); % skimmed data
T_nc   = T2(T2.Age>=65,:);




%--------------------------------------------------------------------------
% Perform two-sample t-test
%--------------------------------------------------------------------------
pvals = zeros(nvar,1);
tstat = zeros(nvar,1);
for i=1:nvar,
    varName = analVars{i};
    [h,p,ci,stat] = ttest2(T_pt.(varName), T_nc.(varName));
    pvals(i) = p;
    tstat(i) = stat.tstat;
end
[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(pvals(3:end));
adj_p = [pvals(1:2); adj_p];



%--------------------------------------------------------------------------
% Write results in csv file
%--------------------------------------------------------------------------
fnout = '~/Desktop/a.csv';
fid = fopen(fnout,'w+');
fprintf(fid,'Variable,PT,NC,t,p\n');
for i=1:nvar,
    varName = analVars{i};
    muPT = mean(T_pt.(varName));
    sdPT = std(T_pt.(varName));
    muNC = mean(T_nc.(varName));
    sdNC = std(T_nc.(varName));
    if adj_p(i)<0.05,
        fprintf(fid,'%s,%.2f +- %.2f,%.2f +- %.2f,%.2f,%.3f,*\n',varName,muPT,sdPT,muNC,sdNC,tstat(i),adj_p(i));
    else
        fprintf(fid,'%s,%.2f +- %.2f,%.2f +- %.2f,%.2f,%.3f\n',varName,muPT,sdPT,muNC,sdNC,tstat(i),adj_p(i));
    end
end
fclose(fid);

