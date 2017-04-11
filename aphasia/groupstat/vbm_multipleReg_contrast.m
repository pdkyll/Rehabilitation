function vbm_multipleReg_contrast(studies,covars)


%  Start The SPM Batch Jobs
%__________________________________________________________________________

clear jobs;


fprintf('\n-----------------------------------------------------------------------\n');
fprintf('  MAKE CONTRAST MATRICES ... \n');
fprintf('-----------------------------------------------------------------------\n');


MATpath = studies.OUTpath;


%  GM: Make Contrast for Group differences
%______________________________________________________________________

fprintf('::: group differences (GM) : %s ...\n', covars(1).name);
jobs{1}.stats{1}.con.spmmat = cellstr(fullfile(MATpath,['GM_' covars(1).name],'SPM.mat'));

contrast_name = sprintf('Positive (%s)', covars(1).name);
jobs{1}.stats{1}.con.consess{1}.tcon.name = contrast_name;
jobs{1}.stats{1}.con.consess{1}.tcon.convec = [0 1];

contrast_name = sprintf('Negative (%s)', covars(1).name);
jobs{1}.stats{1}.con.consess{2}.tcon.name = contrast_name;
jobs{1}.stats{1}.con.consess{2}.tcon.convec = [0 -1];
jobs{1}.stats{1}.con.delete = 1;


%  FA; Make Contrast for Group differences
%______________________________________________________________________

fprintf('::: group differences (FA) : %s ...\n', covars(1).name);
jobs{2}.stats{1}.con.spmmat = cellstr(fullfile(MATpath,['FA_' covars(1).name],'SPM.mat'));

contrast_name = sprintf('Positive (%s)', covars(1).name);
jobs{2}.stats{1}.con.consess{1}.tcon.name = contrast_name;
jobs{2}.stats{1}.con.consess{1}.tcon.convec = [0 1];

contrast_name = sprintf('Negative (%s', covars(1).name);
jobs{2}.stats{1}.con.consess{2}.tcon.name = contrast_name;
jobs{2}.stats{1}.con.consess{2}.tcon.convec = [0 -1];
jobs{2}.stats{1}.con.delete = 1;


%spm_jobman('interactive',jobs);  % open a GUI containing all the setup
spm_jobman('run',jobs);


