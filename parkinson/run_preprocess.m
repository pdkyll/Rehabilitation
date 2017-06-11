% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','PET');
spm_jobman('initcfg');


% Directory containing Parkinson data
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/data/RM_kdh/parkinson';
data_path = fullfile(proj_path,'data');
fn_xls    = fullfile(proj_path,'demographic','parkinson_20170609_KSH.xlsx');
T         = readtable(fn_xls,'Sheet','PET_list');
subjlist  = T.subjname;
nsubj     = length(subjlist);



fn_template = fullfile(spm('dir'),'tpm','TPM.nii');

for c=31:nsubj,
    clear matlabbatch;
    subjname = subjlist{c};
    
    fn_pet  = fullfile(data_path,subjname,'pet','pet.nii');
    fn_wpet = fullfile(data_path,subjname,'pet','wpet.nii');
    fn_anat = fullfile(data_path,subjname,'anat','hires.nii');
    
    
    % Realignment
    %----------------------------------------------------------------------
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = {fn_pet};
    matlabbatch{1}.spm.spatial.coreg.estimate.source = {fn_anat};
    
    
    % Normalization
    %----------------------------------------------------------------------
    matlabbatch{2}.spm.spatial.normalise.estwrite.subj.vol = {fn_anat};
    matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample = {fn_pet};
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.tpm = {fn_template};
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.affreg = 'eastern';
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
    matlabbatch{2}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
    matlabbatch{2}.spm.spatial.normalise.estwrite.woptions.interp = 4;
    
    
    % Smoothing
    %----------------------------------------------------------------------
    matlabbatch{3}.spm.spatial.smooth.data = {fn_wpet};
    matlabbatch{3}.spm.spatial.smooth.fwhm = [8 8 8];
    
    spm_jobman('run',matlabbatch);
end

