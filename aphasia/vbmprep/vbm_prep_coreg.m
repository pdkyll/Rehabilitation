function vbm_prep_coreg(fn_reference, fn_source)

clear matlabbatch;
matlabbatch{1}.spm.spatial.coreg.estimate.ref = {fn_reference};
matlabbatch{1}.spm.spatial.coreg.estimate.source = {fn_source};
% spm_jobman('interactive',matlabbatch);
spm_jobman('run',matlabbatch);