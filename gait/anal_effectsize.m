close all;
addpath('/Volumes/JetDrive/data/RM_kdh/matlabscripts/gait/modularity');
addpath('/Volumes/JetDrive/data/RM_kdh/matlabscripts/gait/utils');
addpath('/Volumes/JetDrive/data/RM_kdh/matlabscripts/gait');


% Parameters
% CL = 1; flipMode = 1; saveName = 'hemi';
% CL = 4; flipMode = 2; saveName = 'pain_flip';
% CL = 6; flipMode = 0; saveName = 'normal';
% CL = 7; flipMode = 0; saveName = 'parkinson';
CL = 8; flipMode = 2; saveName = 'nerve_root_flip';
proj_path = '/Users/skyeong/Google Drive/Manuscripts/Subgroup - Gait pattern';

% CL = 4; flipMode = 0; saveName = 'pain_unflip';
% CL = 8; flipMode = 0; saveName = 'nerve_root_unflip';

%--------------------------------------------------------------------------
% List of variables
%--------------------------------------------------------------------------
fn_xls = fullfile(proj_path,'data','list_of_variables.xlsx');
TT = readtable(fn_xls, 'Sheet' ,'New');
analVars = TT.list_of_variables;  % sptmp
nvar = length(analVars);


%--------------------------------------------------------------------------
% Load Gait Data
%--------------------------------------------------------------------------
fprintf('    : Load and skim dataset\n');
fn_xls   = fullfile(proj_path,'data','gait_final_dataset.xlsx');
T        = readtable(fn_xls);
T_skim   = skim_data(T, analVars, CL,  flipMode); % skimmed data
skimData = table2array(T_skim);



%--------------------------------------------------------------------------
% Load Subgroup Information
%--------------------------------------------------------------------------
fn_csv = fullfile(proj_path,'subgroup',[saveName '.csv']);
group = dlmread(fn_csv);
pk = hist(group,1:6);
groupid = find(pk>10);
ngrp = length(groupid);

fn_out = sprintf('~/Desktop/CohenD_%s.csv',saveName);
fid = fopen(fn_out,'w+');
fprintf(fid,'group1, group2, t-val, corr p, cohen_d, analVar\n');
for ii=1:ngrp,
    i=groupid(ii);
    for jj=(ii+1):ngrp,
        j=groupid(jj);
        dvals = [];
        tvals = [];
        pvals = [];
        for v=1:nvar,
            dat1 = skimData(group==i,v);
            dat2 = skimData(group==j,v);
            d = cohen_d(dat1,dat2);
            dvals(v) = d;
            [h,p,ci,stat] = ttest2(dat1,dat2);
            tvals(v) = stat.tstat;
            pvals(v) = p*nvar;
        end
        [val,id]=sort(abs(dvals),'descend');
        fprintf(fid, 'G%d, G%d, %.2f, %.3f, %.2f, %s \n',i,j,tvals(id(1)), pvals(id(1)), dvals(id(1)),analVars{id(1)});
        fprintf(fid, 'G%d, G%d, %.2f, %.3f, %.2f, %s \n',i,j,tvals(id(2)), pvals(id(2)), dvals(id(2)),analVars{id(2)});
        fprintf(fid, 'G%d, G%d, %.2f, %.3f, %.2f, %s \n',i,j,tvals(id(3)), pvals(id(3)), dvals(id(3)),analVars{id(3)});
        fprintf(fid, 'G%d, G%d, %.2f, %.3f, %.2f, %s \n',i,j,tvals(id(4)), pvals(id(4)), dvals(id(4)),analVars{id(4)});
        fprintf(fid, 'G%d, G%d, %.2f, %.3f, %.2f, %s \n',i,j,tvals(id(5)), pvals(id(5)), dvals(id(5)),analVars{id(5)});
    end
    fprintf(fid,'\n');
end
fclose(fid);

