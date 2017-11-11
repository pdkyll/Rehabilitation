addpath('bpm');

% ------------ INPUTS -------------------
% [IMGs, T_pt] = bpm_preparedata;
[IMGs, T_pt, vo_mask] = load_masked_data;
all_behav = table2array(T_pt);
all_behav(:,1:2) = [];
all_pet = IMGs;

N_behav = size(all_behav,2);
N_pet   = size(all_pet,2);

for i=1:N_pet,
    [r,p] = partialcorr(all_pet(:,i),all_behav, T_pt.Age);
    [h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(p);
    for j=1:N_behav,
        if adj_p(j)<0.05,
            fprintf('i=%d, j=%d, r=%.2f, q=%.4f\n',i,j,r(j),adj_p(j));
            figure; plot(all_pet(:,i),all_behav(:,j),'r.');
        end
    end
end