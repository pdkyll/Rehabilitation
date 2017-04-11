function vbm_anova_design(studies, subjlist, grp, covars)

%  START THE SPM BATCH JOBS
%__________________________________________________________________________

spmtpm = fullfile(spm('dir'),'tpm');
clear matlabbatch;


%   Group description
%______________________________________________________________________

nsubj = length(subjlist);
idg1 = grp(1).idx;
idg2 = grp(2).idx;



fprintf('\n-----------------------------------------------------------------------\n');
fprintf('  2ND LEVEL MODEL SPECIFICATION (TWO SAMPLE T-TEST) ... \n');
fprintf('-----------------------------------------------------------------------\n');



%   GM data
%______________________________________________________________________

VBMpath = studies.VBMpath;
OUTpath = studies.OUTpath;
fprintf('::: load vbm data ...\n');
vbm = cell(0);
for c=1:nsubj,
    filename = sprintf('smwrc1hires_%s.nii,1',subjlist{c});
    vbm{c} = fullfile(VBMpath, 'gm',filename);
end
vbm = [vbm'];
vbm1 = vbm(idg1,:);
vbm2 = vbm(idg2,:);

fprintf('::: 1way Anova (GM) : %s vs. %s ...\n', grp(1).name,grp(2).name);
savedir = fullfile(OUTpath,'GM'); mkdir(savedir);

matlabbatch{1}.spm.stats.factorial_design.dir = cellstr(savedir);
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = cellstr(vbm1);
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = cellstr(vbm2);


for k=1:length(covars),
    vec = covars(k).vector(:);
    matlabbatch{1}.spm.stats.factorial_design.cov(k).c = [vec(idg1); vec(idg2);];
    matlabbatch{1}.spm.stats.factorial_design.cov(k).cname = covars(k).name;
end
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tma.athresh = eps;


%   FA data
%______________________________________________________________________

FA = cell(0);
for c=1:nsubj,
    filename = sprintf('smwFA_%s.nii,1',subjlist{c});
    FA{c} = fullfile(VBMpath, 'FA',filename);
end
FA = [FA'];
FA1 = FA(idg1,:);
FA2 = FA(idg2,:);

fprintf('::: 1way Anova (FA) : %s vs. %s ...\n', grp(1).name,grp(2).name);
savedir = fullfile(OUTpath,'FA'); mkdir(savedir);

matlabbatch{2}.spm.stats.factorial_design.dir = cellstr(savedir);
matlabbatch{2}.spm.stats.factorial_design.des.t2.scans1 = cellstr(FA1);
matlabbatch{2}.spm.stats.factorial_design.des.t2.scans2 = cellstr(FA2);

for k=1:length(covars),
    vec = covars(k).vector(:);
    matlabbatch{2}.spm.stats.factorial_design.cov(k).c = [vec(idg1); vec(idg2);];
    matlabbatch{2}.spm.stats.factorial_design.cov(k).cname = covars(k).name;
end
matlabbatch{2}.spm.stats.factorial_design.masking.tm.tma.athresh = eps;


% spm_jobman('interactive',matlabbatch);  % open a GUI containing all the setup
spm_jobman('run',matlabbatch);


