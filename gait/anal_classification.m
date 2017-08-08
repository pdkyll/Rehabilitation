close all;
addpath('/Volumes/JetDrive/data/RM_kdh/matlabscripts/gait/modularity');
addpath('/Volumes/JetDrive/data/RM_kdh/matlabscripts/gait/utils');
addpath('/Volumes/JetDrive/data/RM_kdh/matlabscripts/gait');


% Parameters
% CL = 1; flipMode = 1; saveName = 'hemi';
% CL = 4; flipMode = 3; saveName = 'pain_flip';
% CL = 6; flipMode = 0; saveName = 'normal';
% CL = 7; flipMode = 0; saveName = 'parkinson';
CL = 8; flipMode = 3; saveName = 'nerve_root_flip';
proj_path = '/Users/skyeong/Google Drive/Manuscripts/Subgroup - Gait pattern';

% CL = 4; flipMode = 0; saveName = 'pain_unflip';
% CL = 8; flipMode = 0; saveName = 'nerve_root_unflip';

%--------------------------------------------------------------------------
% List of variables
%--------------------------------------------------------------------------
fn_xls = fullfile(proj_path,'data','list_of_variables.xlsx');
TT1 = readtable(fn_xls, 'Sheet' ,'New');
allVars = TT1.list_of_variables;  % sptmp
TT2 = readtable(fn_xls, 'Sheet' ,saveName);
analVars = TT2.list_of_variables;  % sptmp
nvar = length(analVars);


%--------------------------------------------------------------------------
% Load Featured Gait Variables
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
pk = hist(group,1:max(group));
groupid = find(pk>12);
ngrp = length(groupid);
nsubj = length(group);



%--------------------------------------------------------------------------
% Compute mean values for each subgroup
%--------------------------------------------------------------------------
GRP = struct();
for g=1:ngrp,
    idx = find(group==g);
    dat = skimData(idx,:);
    GRP(g).mu = mean(dat);
end



%--------------------------------------------------------------------------
% Compute membership
%--------------------------------------------------------------------------
SUB = struct();
for c=1:nsubj
    SUB(c).id = c;
    
    dat = skimData(c,:);
    rankvar = zeros(1,3);
    for g=1:ngrp,
        d = GRP(g).mu-dat;
        d = sqrt(d*d');  % square-root of sum of square
        rankvar(g) = d;
    end
    [val,id] =min(rankvar);
    SUB(c).membership = id;
    
end

membership = [SUB.membership]';
idvalid = find(~isnan(group));
accSkim = group(idvalid)==membership(idvalid);
fprintf('%s, accurecy = %.2f (using selected variables)\n', saveName, 100*mean(accSkim));

%--------------------------------------------------------------------------
% Classification analysis
%--------------------------------------------------------------------------
