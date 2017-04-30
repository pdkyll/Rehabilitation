function vbm_prep_mktemplate(PROJpath, subjlist)

%__________________________________________________________________________
%
% This batch script is to make easier your works.
%
% Copyright (c) 2014 Sunghyon Kyeong
% Yonsei University College of Medicine
%
% vbm_prep_mktemplate.m  October 24, 2014
%__________________________________________________________________________


clear jobs;


fprintf('\n-----------------------------------------------------------------------\n');
fprintf('  DARTEL (create Template) ... \n');
fprintf('-----------------------------------------------------------------------\n');

VBMpath=fullfile(PROJpath,'VBM');

% rmdir(VBMpath,'s'); % remove directory including subdirectory and files
mkdir(fullfile(VBMpath,'wm'));
mkdir(fullfile(VBMpath,'gm'));


for i=1:length(subjlist),
    subjname=subjlist{i};
    MRIpath = fullfile(PROJpath,'T1',subjname);
    
    rc1 = dir(fullfile(VBMpath,'gm',['rc1hires_' subjname '.nii']));
    rc2 = dir(fullfile(VBMpath,'wm',['rc2hires_' subjname '.nii']));
    if isempty(rc1),
        fn_src = fullfile(MRIpath,'rc1hires.nii');
        fn_des = fullfile(VBMpath,'gm',sprintf('rc1hires_%s.nii',subjname));
        copyfile(fn_src,fn_des,'f');
    end
    if isempty(rc2),
        fn_src = fullfile(MRIpath,'rc2hires.nii');
        fn_des = fullfile(VBMpath,'wm',sprintf('rc2hires_%s.nii',subjname));
        copyfile(fn_src,fn_des,'f');
    end
end


fnGM =spm_select('FPList',fullfile(VBMpath,'gm'),'^rc1.*.nii');
fnWM =spm_select('FPList',fullfile(VBMpath,'wm'),'^rc2.*.nii');



%  SPM PARAMETERS FOR DARTEL
%__________________________________________________________________________


jobs{1}.spm{1}.tools.dartel.warp.images = {cellstr(fnGM), cellstr(fnWM)}';
jobs{1}.spm{1}.tools.dartel.warp.settings.optim.cyc = 6;  % default value is 3


% spm_jobman('interactive',jobs);  % open a GUI containing all the setup
spm_jobman('run',jobs);
