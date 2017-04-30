warning('off','all');
addpath('vbmprep');



%  Analysis Mode
%--------------------------------------------------------------------------
do_Coreg      = 0;
do_Segment    = 1;
do_mkTemplate = 0;
do_Normaliza  = 0;


%  SPECIFY your own study
%--------------------------------------------------------------------------

PROJpath = '/Volumes/JetDrive/data/RM_kdh/aphasia';
fn_list = fullfile(PROJpath,'subjectInfo' ,'subjlist.xlsx');
T = readtable(fn_list);
subjlist = T.subjname;
nsubj = length(subjlist);

FWHM = 6;
params.fwhm = FWHM;
params.prefix = 'smwr';  % from SPM DARTEL
params.VBMpath = fullfile(PROJpath,'VBM');



%  Initialize SPM job manager
%--------------------------------------------------------------------------

tic;  ST = clock;


%  Coregistration (FA --> T1)
%--------------------------------------------------------------------------
if do_Coreg
    parfor i=1:nsubj,
        subjname = subjlist{i};
        fn_reference = fullfile(PROJpath,'T1',subjname,'hires.nii');
        fn_source = fullfile(PROJpath,'DTI',subjname,'FA.nii');
        vbm_prep_coreg(fn_reference, fn_source);
    end
end

%  Segmentation
%--------------------------------------------------------------------------

if do_Segment,
    DATApath = fullfile(PROJpath,'T1');
    parfor i=1:nsubj,
        subjname = subjlist{i};
        vbm_prep_segment(DATApath, subjname);
    end
end

%  CREATE DARTEL TEMPLATE
%--------------------------------------------------------------------------

if do_mkTemplate
    vbm_prep_mktemplate(studies.PROJpath,params);
end



%  DARTEL (Normalize to MNI space)
%--------------------------------------------------------------------------

if do_Normaliza
    vbm_prep_norm(studies);
end


ET = clock;
fprintf('=======================================================================\n');
fprintf('    Started Time : %g-%g-%g  %g:%g:%d \n', round(ST));
fprintf('        End Time : %g-%g-%g  %g:%g:%d \n', round(ET));
fprintf('    Elapsed Time : %g min.\n',toc/60);
fprintf('=======================================================================\n\n');


return ;
