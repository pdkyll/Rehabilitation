addpath('/Users/skyeong/connectome/tda');
addpath('/Users/skyeong/connectome/tda/core');
addpath('/Volumes/JetDrive/data/RM_kdh/TDA_data/codes/');
addpath(genpath('/Users/skyeong/connectome/GroupICATv2.0e'));

% List of variables
fn_xls = '/Users/skyeong/Google Drive/Manuscripts/TDA - Gait pattern/data/list_of_variables.xlsx';
T = readtable(fn_xls);
spatiotemporal = [T.list_of_variables(1:7,:)];  % spatiotemporal
kinematic = [T.list_of_variables(8:19,:)];  % kinematic
kinetic = [T.list_of_variables(20:end,:)];  % kinetic

% Load data
fn_xls = '/Users/skyeong/Google Drive/Manuscripts/TDA - Gait pattern/data/gait_2000_2016_unique_valid_pain.xlsx';
% fn_xls = '/Users/skyeong/Google Drive/Manuscripts/TDA - Gait pattern/data/gait_2000_2016_unique_valid.xlsx';
T = readtable(fn_xls);
AS = T.AS; CL = T.CL;
% AS = (T.AS-mean(T.AS))/std(T.AS);
% CL = (T.CL-mean(T.CL))/std(T.CL);

% Reduce features
data_spatiotemporal = skim_data(T,spatiotemporal);
data_kinematic      = skim_data(T,kinematic );
data_kinetic        = skim_data(T,kinetic);
Ndata_spatiotemporal = snv(data_spatiotemporal')';
Ndata_kinematic      = snv(data_kinematic')';
Ndata_kinetic        = snv(data_kinetic')';

% Write each variables
OUTpath = '/Users/skyeong/connectome/tda/data/gait';
cmd = sprintf('! rm -rf var_*.txt;'); eval(cmd);
for i=1:length(spatiotemporal),
    fn_out = fullfile(OUTpath,['var_' spatiotemporal{i},'.txt']);
    dlmwrite(fn_out,data_spatiotemporal(:,i));
end
for i=1:length(kinematic),
    fn_out = fullfile(OUTpath,['var_' kinematic{i},'.txt']);
    dlmwrite(fn_out,data_kinematic(:,i));
end
for i=1:length(kinetic),
    fn_out = fullfile(OUTpath,['var_' kinetic{i},'.txt']);
    dlmwrite(fn_out,data_kinetic(:,i));
end


% Principal component analysis
[coeff, score, latent, tsquared, explained] = pca(Ndata_spatiotemporal','Algorithm','svd');
pc1_spatiotemporal = coeff(:,1);
fn_out = fullfile(OUTpath,'pc1_spatiotemporal.txt');
dlmwrite(fn_out,pc1_spatiotemporal);
fprintf('1st component: %.2f (spatiotemporal)\n',explained(1));

[coeff, score, latent, tsquared, explained] = pca(Ndata_kinematic','Algorithm','svd');
pc1_kinematic = coeff(:,1);
fn_out = fullfile(OUTpath,'pc1_kinematic.txt');
dlmwrite(fn_out,pc1_kinematic);
fprintf('1st component: %.2f (kinematic)\n',explained(1));

[coeff, score, latent, tsquared, explained] = pca(Ndata_kinetic','Algorithm','svd');
pc1_kinetic = coeff(:,1);
fn_out = fullfile(OUTpath,'pc1_kinetic.txt');
dlmwrite(fn_out,pc1_kinetic);
fprintf('1st component: %.2f (kinetic)\n',explained(1));


% spatiotemporal + kinematic
spatiotemporal_kinetic = [Ndata_spatiotemporal,Ndata_kinetic];
d = L2_distance(spatiotemporal_kinetic',spatiotemporal_kinetic');
f_inf = max(d);
[coeff, score, latent, tsquared, explained] = pca(spatiotemporal_kinetic','Algorithm','svd');
f1 = coeff(:,1);
f2 = coeff(:,2);
save('gait_spatiotemporal+kinetic_pain.mat','pc1_spatiotemporal','pc1_kinetic','f1','f2','f_inf','d','AS','CL');
