function vbm_anova_contrast(studies, grp)


%  Start The SPM Batch Jobs
%__________________________________________________________________________

clear jobs;


%  Group Description
%__________________________________________________________________________

grpname1 = grp(1).name;
grpname2 = grp(2).name;


fprintf('\n-----------------------------------------------------------------------\n');
fprintf('  MAKE CONTRAST MATRICES ... \n');
fprintf('-----------------------------------------------------------------------\n');


MATpath = studies.OUTpath;


%  GM: Make Contrast for Group differences
%______________________________________________________________________

fprintf('::: group differences (GM) : %s vs. %s ...\n', grpname1, grpname2);
jobs{1}.stats{1}.con.spmmat = cellstr(fullfile(MATpath,'GM','SPM.mat'));

contrast_name = sprintf('%s > %s', grpname1, grpname2);
jobs{1}.stats{1}.con.consess{1}.tcon.name = contrast_name;
jobs{1}.stats{1}.con.consess{1}.tcon.convec = [1 -1];

contrast_name = sprintf('%s < %s', grpname1, grpname2);
jobs{1}.stats{1}.con.consess{2}.tcon.name = contrast_name;
jobs{1}.stats{1}.con.consess{2}.tcon.convec = [-1 1];


%  FA; Make Contrast for Group differences
%______________________________________________________________________

fprintf('::: group differences (FA) : %s vs. %s ...\n', grpname1, grpname2);
jobs{2}.stats{1}.con.spmmat = cellstr(fullfile(MATpath,'FA','SPM.mat'));

contrast_name = sprintf('%s > %s', grpname1, grpname2);
jobs{2}.stats{1}.con.consess{1}.tcon.name = contrast_name;
jobs{2}.stats{1}.con.consess{1}.tcon.convec = [1 -1];

contrast_name = sprintf('%s < %s', grpname1, grpname2);
jobs{2}.stats{1}.con.consess{2}.tcon.name = contrast_name;
jobs{2}.stats{1}.con.consess{2}.tcon.convec = [-1 1];


%spm_jobman('interactive',jobs);  % open a GUI containing all the setup
spm_jobman('run',jobs);


