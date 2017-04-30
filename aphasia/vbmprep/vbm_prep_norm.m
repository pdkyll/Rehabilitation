function vbm_prep_norm(studies)

%__________________________________________________________________________
%
% This batch script is to make easier your works.
%
% Copyright (c) 2014 Sunghyon Kyeong
% Yonsei University College of Medicine
%
% vbm_prep_norm.m  October 24, 2014
%__________________________________________________________________________

clear jobs;


fprintf('\n-----------------------------------------------------------------------\n');
fprintf('  DARTEL (Normalize to MNI Space ) ... \n');
fprintf('-----------------------------------------------------------------------\n');


VBMpath=studies.VBMpath;
fwhm=studies.fwhm;

fnFlowFields = spm_select('FPList',fullfile(VBMpath,'gm'),'^u_rc1.*.nii');
fnGM  = spm_select('FPList',fullfile(VBMpath,'gm'),'^rc1.*.nii');
fnWM  = spm_select('FPList',fullfile(VBMpath,'wm'),'^rc2.*.nii');
fnFA  = spm_select('FPList',fullfile(VBMpath,'FA'),'^FA.*.nii');

jobs{1}.spm{1}.tools.dartel.mni_norm.template = {fullfile(VBMpath,'gm','Template_6.nii')};
jobs{1}.spm{1}.tools.dartel.mni_norm.data.subjs.flowfields = cellstr(fnFlowFields);
jobs{1}.spm{1}.tools.dartel.mni_norm.data.subjs.images = {cellstr(fnGM), cellstr(fnWM),cellstr(fnFA)}';
% jobs{1}.spm{1}.tools.dartel.mni_norm.data.subjs.images = {cellstr(fnGM), cellstr(fnWM)}';
jobs{1}.spm{1}.tools.dartel.mni_norm.preserve = 1;   % Jacobian Modulation
jobs{1}.spm{1}.tools.dartel.mni_norm.vox = [1 1 1];  % Normalization Voxel Size
jobs{1}.spm{1}.tools.dartel.mni_norm.fwhm = [fwhm fwhm fwhm]; % Smoothing Kernel Size


% spm_jobman('interactive',jobs);  % open a GUI containing all the setup
spm_jobman('run',jobs);
