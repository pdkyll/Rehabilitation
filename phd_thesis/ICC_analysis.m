T1 = readtable('ROI_intra-rating.xlsx', 'Sheet','roi1');
T2 = readtable('ROI_intra-rating.xlsx', 'Sheet','roi2');

VOL = [T1.VOL T2.VOL];
ICC = IPN_icc(VOL,2,'k')

x = [T1.MNI_x T2.MNI_x];
ICC = IPN_icc(x,2,'k')

y = [T1.MNI_y T2.MNI_y];
ICC = IPN_icc(y,2,'k')

z = [T1.MNI_z T2.MNI_z];
ICC = IPN_icc(z,2,'k')

