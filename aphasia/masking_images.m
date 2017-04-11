warning('off','all');
addpath('/Users/skyeong/matlabwork/spm12');
addpath('/Users/skyeong/connectome');



%  SETUP DATA PATH AND OUTPUT DIRECTORY
%__________________________________________________________________________

[studies, subjlist, phenotype] = load_study_info('RM_kdh');
nsubj = length(subjlist);
PROJpath = studies{1}.PROJpath;
VBMpath= sprintf('%s/VBM',PROJpath);
fn_mask = fullfile(VBMpath,'mask','mask_ICV_1mm.nii');
vo_mask = spm_vol(fn_mask);
MASK = spm_read_vols(vo_mask);
idmask = find(MASK>0);

% masking GM images
for c=1:nsubj,
    filename = sprintf('smwrc1hires_%s.nii',subjlist{c});
    fn = fullfile(VBMpath,'gm',filename);
    vo = spm_vol(fn);
    IMG = spm_read_vols(vo);
    newIMG = zeros(vo.dim);
    newIMG(idmask) = IMG(idmask)+eps;
    spm_write_vol(vo,newIMG);
end



% masking FA images
for c=1:nsubj,
    filename = sprintf('smwFA_%s.nii',subjlist{c});
    fn = fullfile(VBMpath,'FA',filename);
    vo = spm_vol(fn);
    IMG = spm_read_vols(vo);
    newIMG = zeros(vo.dim);
    newIMG(idmask) = IMG(idmask)+eps;
    spm_write_vol(vo,newIMG);
end