% Reset origin

fns = dir('subj*.nii');
fns = {fns.name};


for i=1:length(fns);
    %     fn_roi = 'lsubj01.img';
    % fn_T1 = 'subj01.nii';
    fn_T1 = fns{i};
    [p,f,e] = fileparts(fn_T1);
    fn_roi = ['l' f '.img'];
    
    if ~exist(fn_T1,'file'), continue; end
    if ~exist(fn_roi,'file'), continue; end
    
    
    % ROI
    vol_roi = spm_vol(fn_roi); %load header info
    IMG_roi = spm_read_vols(vol_roi);  % load image data
    
    %T1
    vol_T1 = spm_vol(fn_T1);
    
    vol_roi.mat = vol_T1.mat;  % 20150120 updated
    %  vol_roi.mat(:,4) = vol_T1.mat(:,4);
    spm_write_vol(vol_roi,IMG_roi);
end


