addpath('/Users/skyeong/connectome/tda');
addpath('/Users/skyeong/connectome/tda/core');
addpath('/Volumes/JetDrive/data/RM_kdh/TDA_data/codes/');

% List of variables
XLSpath = '/Users/skyeong/Google Drive/Manuscripts/TDA - Gait pattern/data';
fn_xls = fullfile(XLSpath,'list_of_variables.xlsx');
TT = readtable(fn_xls, 'Sheet' ,'All');
analVars = TT.list_of_variables;  % sptmp


% Load data
CL     = 1; % hemi
doFlip = 1;
fn_xls = fullfile(XLSpath,'gait_final_dataset.xlsx');
T      = readtable(fn_xls);

%--------------------------------------------------------------------------
% Load Data
%--------------------------------------------------------------------------
T_norm   = skim_data(T, analVars, 6,  0); % normal
T_hemi   = skim_data(T, analVars, 1,  1); % hemi
normData = table2array(T_norm);
hemiData = table2array(T_hemi);
% idremove = [57 73 152  216];
idremove=[];
hemiData(idremove,:) = [];

% Normalization
muNC     = mean(normData);
sdNC     = std(normData);
muHemi   = mean(hemiData);
sdHemi   = std(hemiData);
Ndata    = bsxfun(@minus,   hemiData,  muHemi);
Ndata    = bsxfun(@rdivide, Ndata,     sdHemi);

% Set OUTPUT folder
OUTpath = fullfile('/Volumes/JetDrive/data/RM_kdh/TDA_data/TDAinput/hemi');
try, rmdir(OUTpath); end; mkdir(OUTpath)


% Write each variables
for i=1:length(analVars),
    fn_out = fullfile(OUTpath,sprintf('var_%02d_%s.txt',i,analVars{i}));
    dlmwrite(fn_out,T.(analVars{i}));
end


% distance and filter
d     = L2_distance(Ndata',Ndata');
f_inf = max(d);


fn_out = fullfile(OUTpath,'gait_hemi.mat');
save(fn_out,'f_inf','d');





if 0,
    % extract principal component
    [coeff1, score1, latent1, tsquared1, explained1] = pca(Ndata','Algorithm','svd');
    PC1 = coeff1(:,1);
    PC2 = coeff1(:,2);
    PC3 = coeff1(:,3);
    PC4 = coeff1(:,4);
end

