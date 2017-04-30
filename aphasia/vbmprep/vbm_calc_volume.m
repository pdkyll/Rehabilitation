function [tiv, tgmv] = vbm_calc_volume(vo_gm, vo_wm, vo_csf, thr)

IMG_gm = spm_read_vols(vo_gm);
IMG_wm = spm_read_vols(vo_wm); 
IMG_csf = spm_read_vols(vo_csf);

idgm = find(IMG_gm>thr);
idwm = find(IMG_wm>thr);
idcsf = find(IMG_csf>thr);

idtiv = union(idgm,idwm);
idtiv = union(idtiv,idcsf);

P = spm_imatrix(vo_gm.mat);
Scale = abs(P(7:9));
unitVol = prod(Scale);


tiv = length(idtiv)*unitVol/1000;  % in cubic centimeter (cc)
tgmv = sum(IMG_gm(idgm))*unitVol/1000; % in cubic centimeter (cc)