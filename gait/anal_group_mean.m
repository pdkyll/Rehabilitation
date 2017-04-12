close all;
warning('off','all');
addpath('/Volumes/JetDrive/data/RM_kdh/matlabscripts/gait');
addpath('/Volumes/JetDrive/data/RM_kdh/matlabscripts/gait/utils');


% Parameters
% CL = 1; flipMode = 1; saveName = 'hemi';
% CL = 4; flipMode = 2; saveName = 'pain_flip';
% CL = 6; flipMode = 0; saveName = 'normal';
% CL = 7; flipMode = 0; saveName = 'parkinson';
% CL = 8; flipMode = 2; saveName = 'nerve_root_flip';


% List of variables
%--------------------------------------------------------------------------
XLSpath = '/Users/skyeong/Google Drive/Manuscripts/Subgroup - Gait pattern/data';
fn_xls = fullfile(XLSpath,'list_of_variables.xlsx');
TT = readtable(fn_xls, 'Sheet' ,'New');
analVars = TT.list_of_variables;  % sptmp


% Prepare datasets for each group
%--------------------------------------------------------------------------
T_hemi       = prepare_skimed_data(analVars, 1, 1);  % Hemi
T_pain       = prepare_skimed_data(analVars, 4, 2);  % pain_flip
T_normal     = prepare_skimed_data(analVars, 6, 0);  % Normal
T_parkinson  = prepare_skimed_data(analVars, 7, 0);  % Parkinson
T_nerve_root = prepare_skimed_data(analVars, 8, 2);  % nerve_root_flip



% Group Mean
%--------------------------------------------------------------------------
fout = '~/Desktop/group_mean.csv';
fid = fopen(fout,'w+');
fprintf(fid,'Variable,Hemi,Pain,NerveRoot,Parkinson,Normal\n');
for i=1:length(analVars)
    varName = analVars{i};
    muHemi = mean(T_hemi.(varName));
    sdHemi = std(T_hemi.(varName));
    
    muPain = mean(T_pain.(varName));
    sdPain = std(T_pain.(varName));
    
    muNormal = mean(T_normal.(varName));
    sdNormal = std(T_normal.(varName));
    
    muParkinson = mean(T_parkinson.(varName));
    sdParkinson = std(T_parkinson.(varName));
    
    muNerveRoot = mean(T_nerve_root.(varName));
    sdNerveRoot = std(T_nerve_root.(varName));
    fprintf(fid,'%s, %.2f aa %.2f,%.2f aa %.2f, %.2f aa %.2f, %.2f aa %.2f, %.2f aa %.2f\n',varName,muHemi,sdHemi,muPain,sdPain,muNerveRoot,sdNerveRoot,muParkinson,sdParkinson,muNormal,sdNormal);
    
end
fclose(fid);


% varName = analVars{37};
% muHemi = mean(T_hemi.(varName));
% seHemi = std(T_hemi.(varName))/sqrt(size(T_hemi,1));
%
% muPain = mean(T_pain.(varName));
% sePain = std(T_pain.(varName))/sqrt(size(T_pain,1));
%
% muNormal = mean(T_normal.(varName));
% seNormal = std(T_normal.(varName))/sqrt(size(T_normal,1));
%
% muParkinson = mean(T_parkinson.(varName));
% seParkinson = std(T_parkinson.(varName))/sqrt(size(T_parkinson,1));
%
% muNerveRoot = mean(T_nerve_root.(varName));
% seNerveRoot = std(T_nerve_root.(varName))/sqrt(size(T_nerve_root,1));
% fout = ['~/Desktop/' varName '.csv'];
% fid = fopen(fout,'w+');
% fprintf(fid,'%s,Mean,SD\n',varName);
% fprintf(fid,'Hemi,%f,%f\n',muHemi,seHemi);
% fprintf(fid,'Pain,%f,%f\n',muPain,sePain);
% fprintf(fid,'NerveRoot,%f,%f\n',muNerveRoot,seNerveRoot);
% fprintf(fid,'Parkinson,%f,%f\n',muParkinson,seParkinson);
% fprintf(fid,'Normal,%f,%f\n',muNormal,seNormal);
% fclose(fid);

