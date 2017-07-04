function [IMGs, T_pt] = bpm_preparedata



% ------------ LOAD Behavior data -----------
proj_path = '/Volumes/JetDrive/data/RM_kdh';
fn_list = fullfile(proj_path,'parkinson','demographic','subjlist.mat');
load(fn_list);
nsubj = size(T_pt,1);



% ------------ LOAD Behavior data -----------
fn_mask = fullfile(proj_path,'matlabscripts','atlas','hammers_79x95x79.nii');
vo_mask = spm_vol(fn_mask);
HAMMERS = spm_read_vols(vo_mask);
% 1/2. 35/36: CauNuc
% 3/4. 37/38: AccNuc
% 5/6. 39/40: Putamen
% 9/10. 43/44: Palidum
% 11/12 1/2: hippocampus
% 13/14 3/4: amygdala
% 15/16 25/26: ACC
%        17/18: Cerebellum




% ------------ LOADS Imaging data  -------------------
idatlas = [35:40 43 44];
IMGs = zeros(nsubj,length(idatlas));
ROIs = zeros(nsubj,length(idatlas));
idxCbl = HAMMERS==17 | HAMMERS==18;
for c=1:nsubj;
    subjname = T_demographic(T_demographic.subjid==T_pt.subjid(c),:).subjname;
    fn_pet = fullfile(proj_path,'parkinson','data',char(subjname),'pet','swpet.nii');
    vo = spm_vol(fn_pet);
    I = spm_read_vols(vo);
    
    for i=1:length(idatlas),
        idxroi = HAMMERS==idatlas(i);
        IMGs(c,i) = mean(I(idxroi))./mean(I(idxCbl));
    end
   
end
