DATApath = '/Users/skyeong/data/MDD/T1';

[~, subjlist, phenotype] = load_study_info('MDD');
nsubj = length(subjlist);

TIV = zeros(nsubj,1);
TGMV = zeros(nsubj,1);
for c=1:nsubj,
    subjname = subjlist{c};
    fn_gm = fullfile(DATApath,subjname,'c1hires.nii'); vo_gm = spm_vol(fn_gm);
    
    fn_wm = fullfile(DATApath,subjname,'c2hires.nii'); vo_wm = spm_vol(fn_wm);
    
    fn_csf = fullfile(DATApath,subjname,'c3hires.nii'); vo_csf = spm_vol(fn_csf);
    [tiv, tgmv] = vbm_calc_volume(vo_gm, vo_wm, vo_csf, 0.2);
    
    TIV(c) = tiv./1000;  % in liter
    TGMV(c) = tgmv./1000; % in liter
    fprintf('%s, TIV=%.2f\n',subjname,tiv./1000);
end

fn_out = fullfile(DATApath,'TIV.mat');
save(fn_out,'TIV','TGMV');


%  GROUP LABEL
%__________________________________________________________________________

grp = load_group_info(phenotype);


idg1 = grp(1).idx;
idg2 = grp(2).idx;

[h1, p1, ci1, stat1] = ttest2(TIV(idg1), TIV(idg2));
fprintf('combined: %.1f +- %.1f, inattentive: %.1f +- %.1f (p=%.3f)\n',mean(TIV(idg1)), std(TIV(idg1)), mean(TIV(idg2)), std(TIV(idg2)), p1);

[h2, p2, ci2, stat2] = ttest2(TGMV(idg1), TGMV(idg2));
fprintf('combined: %.1f +- %.1f, inattentive: %.1f +- %.1f (p=%.3f)\n',mean(TGMV(idg1)), std(TGMV(idg1)), mean(TGMV(idg2)), std(TGMV(idg2)), p2);
