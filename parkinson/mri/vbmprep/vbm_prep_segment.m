function vbm_prep_segment(DATApath, subjname)

spm('Defaults', 'fMRI');


fprintf('\n-----------------------------------------------------------------------\n');
fprintf('  %s,  Segmentation... \n', upper(subjname));
fprintf('-----------------------------------------------------------------------\n');

spmtpm = fullfile(spm('dir'),'tpm');


%  STRUCTURAL IMAGE
%--------------------------------------------------------------------------

mri_path = fullfile(DATApath, subjname, 'anat');
s_mri = spm_select('ExtFPList',mri_path,'^hires.*.$');
if isempty(s_mri), return; end;

clear jobs;
jobs{1}.spm.spatial.preproc.channel.vols = cellstr(s_mri);
jobs{1}.spm.spatial.preproc.channel.biasreg = 0.001;
jobs{1}.spm.spatial.preproc.channel.biasfwhm = 60;
jobs{1}.spm.spatial.preproc.channel.write = [0 0];
jobs{1}.spm.spatial.preproc.tissue(1).tpm = cellstr(fullfile(spmtpm,'TPM.nii,1'));
jobs{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
jobs{1}.spm.spatial.preproc.tissue(1).native = [1 1];
jobs{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
jobs{1}.spm.spatial.preproc.tissue(2).tpm = cellstr(fullfile(spmtpm,'TPM.nii,2'));
jobs{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
jobs{1}.spm.spatial.preproc.tissue(2).native = [1 1];
jobs{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
jobs{1}.spm.spatial.preproc.tissue(3).tpm = cellstr(fullfile(spmtpm,'TPM.nii,3'));
jobs{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
jobs{1}.spm.spatial.preproc.tissue(3).native = [0 0];
jobs{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
jobs{1}.spm.spatial.preproc.tissue(4).tpm = cellstr(fullfile(spmtpm,'TPM.nii,4'));
jobs{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
jobs{1}.spm.spatial.preproc.tissue(4).native = [0 0];
jobs{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
jobs{1}.spm.spatial.preproc.tissue(5).tpm = cellstr(fullfile(spmtpm,'TPM.nii,5'));
jobs{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
jobs{1}.spm.spatial.preproc.tissue(5).native = [0 0];
jobs{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
jobs{1}.spm.spatial.preproc.tissue(6).tpm = cellstr(fullfile(spmtpm,'TPM.nii,6'));
jobs{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
jobs{1}.spm.spatial.preproc.tissue(6).native = [0 0];
jobs{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
jobs{1}.spm.spatial.preproc.warp.mrf = 1;
jobs{1}.spm.spatial.preproc.warp.cleanup = 1;
jobs{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
jobs{1}.spm.spatial.preproc.warp.affreg = 'eastern';
jobs{1}.spm.spatial.preproc.warp.fwhm = 0;
jobs{1}.spm.spatial.preproc.warp.samp = 3;
jobs{1}.spm.spatial.preproc.warp.write = [1 1];

% spm_jobman('interactive',jobs);  % open a GUI containing all the setup
spm_jobman('run',jobs);
