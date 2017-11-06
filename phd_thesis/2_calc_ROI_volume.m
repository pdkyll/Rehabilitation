
fn_roi = 'lsubj01.img';

% ROI
vol_roi = spm_vol(fn_roi); %load header info
IMG_roi = spm_read_vols(vol_roi);  % load image data

idmask = find(IMG_roi>0);
P = spm_imatrix(vol_roi.mat);
unitVolume =  abs(prod(P(7:9)));

roiVolume = length(idmask)*unitVolume/1000;
fprintf('ROI volume = %.2f cc\n',roiVolume);
