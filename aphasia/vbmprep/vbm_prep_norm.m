function vbm_prep_norm(PROJpath,subjlist,fwhm)

clear matlabbatch;

fprintf('\n-----------------------------------------------------------------------\n');
fprintf('  DARTEL (Normalize to MNI Space ) ... \n');
fprintf('-----------------------------------------------------------------------\n');

fn_template = fullfile(PROJpath,'T1',subjlist{1},'Template_6.nii');
matlabbatch{1}.spm.tools.dartel.mni_norm.template = {fn_template};
for c=1:length(subjlist),
    fnImages = cell(0);
    fnFlowFields = spm_select('FPList',fullfile(PROJpath,'T1',subjlist{c}),'^u_rc1.*.nii');
    fnImages{1} = spm_select('FPList',fullfile(PROJpath,'T1',subjlist{c}),'^rc1.*.nii');
    fnImages{2} = spm_select('FPList',fullfile(PROJpath,'T1',subjlist{c}),'^rc2.*.nii');
    fnImages{3} = spm_select('FPList',fullfile(PROJpath,'DTI',subjlist{c}),'^FA.*.nii');
    matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj(c).flowfield = {fnFlowFields};
    matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj(c).images = [fnImages'];
end

matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [1 1 1];  % Normalization Voxel Size
matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = 1;   % Jacobian Modulation
matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [fwhm fwhm fwhm]; % Smoothing Kernel Size

% spm_jobman('interactive',matlabbatch);  % open a GUI containing all the setup
spm_jobman('run',matlabbatch);
