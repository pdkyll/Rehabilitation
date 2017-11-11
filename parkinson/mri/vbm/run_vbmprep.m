warning('off','all');
tic;  ST = clock;



%  Analysis Mode
%--------------------------------------------------------------------------
do_Segment    = 1;
do_mkTemplate = 1;
do_Normaliza  = 0;


%  SPECIFY your own study
%--------------------------------------------------------------------------
PROJpath = '/Volumes/JetDrive/data/RM_kdh/parkinson';
fn_list  = fullfile(PROJpath,'demographic' ,'subjlist_mri.xlsx');
T        = readtable(fn_list);
subjlist = T.subjname;
nsubj    = length(subjlist);
Dx       = T.Dx;

FWHM     = 6;




%  Segmentation
%--------------------------------------------------------------------------
if do_Segment,
    for i=1:nsubj,
        subjname = subjlist{i};
        grpname = Dx{i};
        vbm_prep_segment(PROJpath, subjname, grpname);
    end
end

%  CREATE DARTEL TEMPLATE
%--------------------------------------------------------------------------
if do_mkTemplate
    vbm_prep_mktemplate(PROJpath, subjlist, Dx);
end



%  DARTEL (Normalize to MNI space)
%--------------------------------------------------------------------------
if do_Normaliza
    vbm_prep_norm(PROJpath,subjlist,FWHM);
end


ET = clock;
fprintf('=======================================================================\n');
fprintf('    Started Time : %g-%g-%g  %g:%g:%d \n', round(ST));
fprintf('        End Time : %g-%g-%g  %g:%g:%d \n', round(ET));
fprintf('    Elapsed Time : %g min.\n',toc/60);
fprintf('=======================================================================\n\n');


return ;
