function vbm_prep_mktemplate(PROJpath, subjlist, Dx)

clear jobs;

fprintf('\n-----------------------------------------------------------------------\n');
fprintf('  DARTEL (create Template) ... \n');
fprintf('-----------------------------------------------------------------------\n');


fnGM = cell(0);
fnWM = cell(0);
for i=1:length(subjlist),
    subjname=subjlist{i};
    if strcmpi(Dx{i},'Control')
        fnGM{i} = spm_select('FPList',fullfile(PROJpath,'data_nc',subjname,'anat'),'^rc1.*.nii');
        fnWM{i} = spm_select('FPList',fullfile(PROJpath,'data_nc',subjname,'anat'),'^rc2.*.nii');
    elseif strcmpi(Dx{i},'Parkinson')
        fnGM{i} = spm_select('FPList',fullfile(PROJpath,'data_pt',subjname,'anat'),'^rc1.*.nii');
        fnWM{i} = spm_select('FPList',fullfile(PROJpath,'data_pt',subjname,'anat'),'^rc2.*.nii');
    end
end


%  SPM PARAMETERS FOR DARTEL
%--------------------------------------------------------------------------

jobs{1}.spm{1}.tools.dartel.warp.images = {[fnGM]'; [fnWM]'}';
jobs{1}.spm{1}.tools.dartel.warp.settings.optim.cyc = 6;  % default value is 3


% spm_jobman('interactive',jobs);  % open a GUI containing all the setup
spm_jobman('run',jobs);
