fns = dir(fullfile('roi2','*.img'));
fns = {fns.name};

subjname = cell(0);
MNI = zeros(length(fns),3);
VOL = zeros(length(fns),1);
for i=1:length(fns)
    fn = fullfile('roi2',fns{i});
    subjname{i} = fns{i}(1:end-4);
    vo = spm_vol(fn);
    P = spm_imatrix(vo.mat);
    I = spm_read_vols(vo);
    idroi = find(I>0);
    [vx,vy,vz] = ind2sub(vo.dim, idroi);
    Vxyz = [vx, vy, vz, ones(size(vx))]';
    Rxyz = (vo.mat*Vxyz)';
    MNI(i,:) = mean(Rxyz(:,1:3));
    VOL(i)   = length(idroi)*prod(abs(P(7:9)))/1000;
end
subjname = subjname';
MNI_x = MNI(:,1);
MNI_y = MNI(:,2);
MNI_z = MNI(:,3);
T = table(subjname,VOL,MNI_x,MNI_y,MNI_z);

