warning('off','all');
addpath('/Users/skyeong/matlabwork/spm12');
addpath('/Users/skyeong/connectome');
addpath('/Users/skyeong/connectome/utils');
addpath('/Volumes/JetDrive/data/RM_kdh/aphasia/codes/groupstat');



%  SETUP DATA PATH AND OUTPUT DIRECTORY
%__________________________________________________________________________

[studies, demographic] = load_study_info2('RM_kdh');
subjlist = demographic.subjname;

PROJpath = studies.PROJpath;
VBMpath= sprintf('%s/VBM',PROJpath);
OUTpath= sprintf('%s/VBM/GroupStat',PROJpath); mkdir(OUTpath);

studies.OUTpath = OUTpath;
studies.VBMpath = VBMpath;



%  GROUP LABEL
%__________________________________________________________________________

grp = struct();
grp(1).idx = find(demographic.Dx==1);
grp(1).name = 'Aphasia';
grp(2).idx = find(demographic.Dx==0);
grp(2).name = 'NC';


%  Covariates
%__________________________________________________________________________

% load('/Users/skyeong/data/ADHD200/DARTEL/adhd200_TGMV.mat')
% load('/Users/skyeong/data/psychiatry/DARTEL/psychiatry_TGMV.mat')


covars = struct();
covars(1).name = 'AQ';
covars(1).vector = demographic.AQ;

% covars(1).name = 'Spon_Sp';
% covars(1).vector = demographic.Spon_Sp;

% covars(1).name = 'Compre';
% covars(1).vector = demographic.Compre;

covars(1).name = 'repetition';
covars(1).vector = demographic.repetition;

% covars(1).name = 'naming';
% covars(1).vector = demographic.naming;



covars(2).name = 'TIV';
covars(2).vector = get_data_field(phenotype,'TIV');

covars(3).name = 'age';
covars(3).vector = get_data_field(phenotype,'Age');

% covars(5).name = deblank(phenotype.hdr(7,:));  % adhd index
% covars(5).vector = phenotype.dat(:,7);




%  Run Multiple Regression
%__________________________________________________________________________

% vbm_anova_design(studies, subjlist, grp, covars);
% vbm_anova_estimate(studies);
% vbm_anova_contrast(studies, grp);

vbm_multipleReg_design(studies, subjlist, grp, covars);
vbm_multipleReg_estimate(studies, covars);
vbm_multipleReg_contrast(studies, covars);

