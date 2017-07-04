vo = spm_vol('hammers_79x95x79.nii');
HAMMERS = spm_read_vols(vo);
idhammers = find(HAMMERS>0);


idroi = [35:44 25 26 19 20 51 52 61 62];  % MOTOR
idroi = [35:44 25 26 19 20 53 54 55 56 59 60];  % MOTOR2
idroi = [35:44 25 26 19 20];  % SUBCOR: BG+brainsteim+acc

MASK = zeros(vo.dim);
for i=1:length(idroi),
    idx = find(HAMMERS==idroi(i));
    MASK(idx)=1;
end

vout=vo;
vout.fname='hammers_79x95x79_SUBCOR2.nii';
spm_write_vol(vout,MASK);