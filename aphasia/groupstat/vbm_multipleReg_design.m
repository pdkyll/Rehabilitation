function vbm_multipleReg_design(studies, subjlist, grp, covars)

%  START THE SPM BATCH JOBS
%__________________________________________________________________________

clear matlabbatch;


%   Group description
%______________________________________________________________________

nsubj = length(subjlist);
idg1 = grp(1).idx;
idg2 = grp(2).idx;



fprintf('\n-----------------------------------------------------------------------\n');
fprintf('  2ND LEVEL MODEL SPECIFICATION (Multiple regression) ... \n');
fprintf('-----------------------------------------------------------------------\n');



%   GM data
%______________________________________________________________________

VBMpath = studies.VBMpath;
OUTpath = studies.OUTpath;
fprintf('::: 1way Multiple regression (GM) : %s ...\n', grp(2).name);
vbm = cell(0);
for c=1:nsubj,
    filename = sprintf('smwrc1hires_%s.nii,1',subjlist{c});
    vbm{c} = fullfile(VBMpath, 'gm',filename);
end
vbm = [vbm'];
vbm1 = vbm(idg1,:);
vbm2 = vbm(idg2,:);

savedir = fullfile(OUTpath,['GM_' covars(1).name]); mkdir(savedir);
matlabbatch{1}.spm.stats.factorial_design.dir = {savedir};
matlabbatch{1}.spm.stats.factorial_design.des.mreg.scans = cellstr(vbm2);

for k=1:length(covars),
    vec = covars(k).vector(:);
    matlabbatch{1}.spm.stats.factorial_design.cov(k).c = [vec(idg2);];
    matlabbatch{1}.spm.stats.factorial_design.cov(k).cname = covars(k).name;
end

matlabbatch{1}.spm.stats.factorial_design.masking.tm.tma.athresh = eps;



%   FA data
%______________________________________________________________________

VBMpath = studies.VBMpath;
OUTpath = studies.OUTpath;
fprintf('::: Multiple regression (FA) : %s ...\n', grp(2).name);
FA = cell(0);
for c=1:nsubj,
    filename = sprintf('smwFA_%s.nii,1',subjlist{c});
    FA{c} = fullfile(VBMpath, 'FA',filename);
end
FA = [FA'];
FA1 = FA(idg1,:);
FA2 = FA(idg2,:);

savedir = fullfile(OUTpath,['FA_' covars(1).name]); mkdir(savedir);
matlabbatch{2}.spm.stats.factorial_design.dir = {savedir};
matlabbatch{2}.spm.stats.factorial_design.des.mreg.scans = cellstr(FA2);

for k=1:length(covars),
    vec = covars(k).vector(:);
    matlabbatch{2}.spm.stats.factorial_design.cov(k).c = [vec(idg2);];
    matlabbatch{2}.spm.stats.factorial_design.cov(k).cname = covars(k).name;
end

matlabbatch{2}.spm.stats.factorial_design.masking.tm.tma.athresh = eps;

% spm_jobman('interactive',matlabbatch);
spm_jobman('run',matlabbatch);