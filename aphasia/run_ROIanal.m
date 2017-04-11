warning('off','all');
addpath('/Users/skyeong/matlabwork/spm12');
addpath('/Users/skyeong/connectome');
addpath('/Users/skyeong/connectome/utils');
addpath('/Volumes/JetDrive/data/RM_kdh/aphasia/codes/groupstat');



%  SETUP DATA PATH AND OUTPUT DIRECTORY
%__________________________________________________________________________

[studies, demographic] = load_study_info2('RM_kdh');
subjlist = demographic.subjname;
nsubj = length(subjlist);

PROJpath = studies.PROJpath;
VBMpath= sprintf('%s/VBM',PROJpath);
OUTpath= sprintf('%s/VBM/GroupStat',PROJpath); mkdir(OUTpath);

studies.OUTpath = OUTpath;
studies.VBMpath = VBMpath;

ROIpath='/Volumes/JetDrive/data/RM_kdh/aphasia/ROIs/';
roinames = {'rGM_L','rGM_R','rWM_L','rWM_R','rBroca_L','rBroca_R','Wernike_L','Wernike_R','Striatum_L','Striatum_R','Thalamus_L','Thalamus_R'};
ROIs = struct();
for i=1:length(roinames),
    fn_roi = fullfile(ROIpath,[roinames{i} '.nii,1']);
    vo = spm_vol(fn_roi);
    I = spm_read_vols(vo);
    ROIs(i).name = roinames{i}(2:end);
    ROIs(i).idx = find(I>0);
end

% GM
fprintf('GM density...\n')
fn = fullfile(ROIpath,'rGMmask.nii');
vo = spm_vol(fn);
GMmask = spm_read_vols(vo);
idxgm = find(GMmask>0);
GM = zeros(nsubj,length(ROIs));
for c=1:nsubj
    fn = fullfile(VBMpath,'gm',['smwrc1hires_' subjlist{c} '.nii']);
    vo = spm_vol(fn);
    I = spm_read_vols(vo);
    
    for i=1:length(ROIs),
        idx = intersect(idxgm,ROIs(i).idx);
        vals = I(idx);
        GM(c,i) = mean(vals(~isnan(vals)));
    end
end
dlmwrite('~/Desktop/GM.csv',GM);

% WM
fprintf('WM density...\n')
fn = fullfile(ROIpath,'rWMmask.nii');
vo = spm_vol(fn);
WMmask = spm_read_vols(vo);
idxwm = find(WMmask>0);
WM = zeros(nsubj,length(ROIs));
for c=1:nsubj
    fn = fullfile(VBMpath,'wm',['smwrc2hires_' subjlist{c} '.nii']);
    vo = spm_vol(fn);
    I = spm_read_vols(vo);
    
    for i=1:length(ROIs),
        idx = intersect(idxwm,ROIs(i).idx);
        vals = I(idx);
        WM(c,i) = mean(vals(~isnan(vals)));
    end
end
dlmwrite('~/Desktop/WM.csv',WM);

% FA
fprintf('FA value...\n')
FA = zeros(nsubj,length(ROIs));
for c=1:nsubj
    fn = fullfile(VBMpath,'FA',['smwFA_' subjlist{c} '.nii']);
    vo = spm_vol(fn);
    I = spm_read_vols(vo);
    
    for i=1:length(ROIs),
        idx = intersect(idxwm,ROIs(i).idx);
        vals = I(idx);
        FA(c,i) = mean(vals(~isnan(vals)));
    end
end
dlmwrite('~/Desktop/FA.csv',FA);