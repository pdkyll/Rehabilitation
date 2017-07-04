function [IMGs, T_pt, vo_mask, idmask] = load_masked_data



% ------------ LOAD Behavior data -----------
proj_path = '/Volumes/JetDrive/data/RM_kdh';
fn_list = fullfile(proj_path,'parkinson','demographic','subjlist.mat');
load(fn_list);
nsubj = size(T_pt,1);



% ------------ LOAD Behavior data -----------
fn_mask = fullfile(proj_path,'matlabscripts','atlas','hammers_79x95x79.nii');
vo_mask = spm_vol(fn_mask);
HAMMERS = spm_read_vols(vo_mask);

% fn_mask = fullfile(proj_path,'matlabscripts','atlas','hammers_79x95x79_BG.nii');
% fn_mask = fullfile(proj_path,'matlabscripts','atlas','hammers_79x95x79_MOTOR2.nii');
% fn_mask = fullfile(proj_path,'matlabscripts','atlas','hammers_79x95x79_SUBCOR.nii');
fn_mask = fullfile(proj_path,'matlabscripts','atlas','hammers_79x95x79_SUBCOR2.nii');
vo_mask = spm_vol(fn_mask);
MASK = spm_read_vols(vo_mask);
idmask = find(MASK>0);


% ------------ LOADS Imaging data  -------------------
IMGs = zeros(nsubj,length(idmask));
idxCbl = HAMMERS==17 | HAMMERS==18;
for c=1:nsubj;
    subjname = T_demographic(T_demographic.subjid==T_pt.subjid(c),:).subjname;
    fn_pet = fullfile(proj_path,'parkinson','data',char(subjname),'pet','swpet.nii');
    vo = spm_vol(fn_pet);
    I = spm_read_vols(vo);
    
    IMGs(c,:) = I(idmask)./mean(I(idxCbl));
end
