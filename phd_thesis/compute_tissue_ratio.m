

% Load tissue data
fn_roi = fullfile('1_temporospatial','1_ttest_speed_tvalue.nii');
vo_roi = spm_vol(fn_roi);
ROI = spm_read_vols(vo_roi);
idroi = find(ROI>0);


% Load Segmented Images
fn_map = fullfile(spm('dir'),'tpm','TPM.nii');
[p,f,e] = fileparts(fn_map);
fn_c1 = fullfile(p,[f, suffix, e,',1']); v1 = spm_vol(fn_c1);
fn_c2 = fullfile(p,[f, suffix, e,',2']); v2 = spm_vol(fn_c2);
fn_c3 = fullfile(p,[f, suffix, e,',3']); v3 = spm_vol(fn_c3);

I1 = spm_read_vols(v1);
I2 = spm_read_vols(v2);
I3 = spm_read_vols(v3);

thr = 0.5;
idx = union(find(I1>thr), find(I2>thr));
idx = union(idx,find(I3>thr));
[val,segInfo] = max([I1(idx)'; I2(idx)'; I3(idx)']);



sumval=0;
tissueName={'GM','WM','CSF'};
fprintf('tissueType,tissueVolume(cc)\n');
for i=1:3,
    % Save segmentation images
    I = zeros(v1.dim);
    I(idx(segInfo==i))=1;
    vout = v1;
    vout.fname = fullfile(p,['s', num2str(i), f,e]);
    spm_write_vol(vout,I);
    
    % Winner take all stratagies
    idovp = intersect(find(I>0),idroi);
    fprintf('%s,%.1f\n',tissueName{i},length(idovp)/1000);
    sumval = sumval+length(idovp)/1000;
end