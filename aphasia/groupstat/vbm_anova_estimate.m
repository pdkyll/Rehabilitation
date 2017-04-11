function vbm_anova_estimate(studies)



%_______START THE SPM BATCH JOBS___________________________________________

clear jobs; 


fprintf('\n-----------------------------------------------------------------------\n');
fprintf('  2nd LEVEL MOODEL ESTIMATION ... \n');
fprintf('-----------------------------------------------------------------------\n');



MATpath = studies.OUTpath;


%  Parameter estimation of ANOVA model
%__________________________________________________________________

fprintf('::: One-way Anova : estimate ...\n');
grp1mat = fullfile(MATpath,'FA','SPM.mat');
jobs{1}.stats{1}.fmri_est.spmmat = cellstr(grp1mat);
jobs{1}.stats{1}.fmri_est.method.Classical = 1;

grp1mat = fullfile(MATpath,'GM','SPM.mat');
jobs{2}.stats{1}.fmri_est.spmmat = cellstr(grp1mat);
jobs{2}.stats{1}.fmri_est.method.Classical = 1;

% spm_jobman('interactive',jobs);  % open a GUI containing all the setup
spm_jobman('run',jobs);


