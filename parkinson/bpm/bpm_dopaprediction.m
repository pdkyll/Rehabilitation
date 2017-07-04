% Copyright 2017 Sunghyon Kyeong

% This code is released under the terms of the GNU GPL v2. This code
% is not FDA approved for clinical use; it is provided
% freely for research purposes. If using this in a publication
% please reference this properly as:

% Finn ES, Shen X, Scheinost D, Rosenberg MD, Huang, Chun MM,
% Papademetris X & Constable RT. (2015). Functional connectome
% fingerprinting: Identifying individuals using patterns of brain
% connectivity. Nature Neuroscience 18, 1664-1671.

% This code provides a framework for implementing functional
% connectivity-based behavioral prediction in a leave-one-subject-out
% cross-validation scheme, as described in Finn, Shen et al 2015 (see above
% for full reference). The first input ('all_mats') is a pre-calculated
% MxMxN matrix containing all individual-subject connectivity matrices,
% where M = number of nodes in the chosen brain atlas and N = number of
% subjects. Each element (i,j,k) in these matrices represents the
% correlation between the BOLD timecourses of nodes i and j in subject k
% during a single fMRI session. The second input ('all_behav') is the
% Nx1 vector of scores for the behavior of interest for all subjects.

% As in the reference paper, the predictive power of the model is assessed
% via correlation between predicted and observed scores across all
% subjects. Note that this assumes normal or near-normal distributions for
% both vectors, and does not assess absolute accuracy of predictions (only
% relative accuracy within the sample). It is recommended to explore
% additional/alternative metrics for assessing predictive power, such as
% prediction error sum of squares or prediction r^2.



% ------------ INPUTS -------------------
% [IMGs, T_pt] = bpm_preparedata;
all_behav = table2array(T_pt);
all_behav(:,1:2) = [];
all_behav = all_behav(:,2:2:end);
all_pet = IMGs(:,9);



% ------------ threshold for feature selection--------------
thresh = 0.05;


% ---------------------------------------
no_sub = size(all_behav,1);
no_dat = size(all_behav,2);

pet_pred_pos = zeros(no_sub,1);
pet_pred_neg = zeros(no_sub,1);


for leftout = 1:no_sub;
    fprintf('Leaving out subj # %6.3f\n',leftout);
    
    % Test dataset: leave out subject
    test_behav = all_behav(leftout,:);
    
    % leave out subject from matrices and behavior
    train_pet = all_pet;
    train_pet(leftout) = [];
    
    train_behav = all_behav;
    train_behav(leftout,:) = [];
    
    % correlate all edges with behavior
    [r_vct,p_vct] = corr(train_behav,train_pet);
    
    % set threshold and define masks
    pos_mask = zeros(no_dat,1);
    neg_mask = zeros(no_dat,1);
    
    %pos_voxs = find(r_vct > 0 & p_vct < thresh);
    %neg_voxs = find(r_vct < 0 & p_vct < thresh);
    pos_voxs = find(r_vct > 0.05);
    neg_voxs = find(r_vct < -0.05);
    
    pos_mask(pos_voxs) = 1;
    neg_mask(neg_voxs) = 1;
    
    % get sum of all edges in TRAIN subs (divide by 2 to control for the
    % fact that matrices are symmetric)
    train_sumpos = zeros(no_sub-1,1);
    train_sumneg = zeros(no_sub-1,1);
    
    for ss = 1:size(train_sumpos);
        train_sumpos(ss) = train_behav(ss,:)*pos_mask;
        train_sumneg(ss) = train_behav(ss,:)*neg_mask;
    end
    
    % (positive pet) build model and run model on TEST subject
    fit_pos = polyfit(train_sumpos, train_pet,1);
    test_sumpos = test_behav*pos_mask;
    pet_pred_pos(leftout) = fit_pos(1)*test_sumpos + fit_pos(2);
    
    
    % run model on TEST sub
    fit_neg = polyfit(train_sumneg, train_pet,1);
    test_sumneg = test_beh*neg_mask;
    pet_pred_neg(leftout) = fit_neg(1)*test_sumneg + fit_neg(2);
end

% compare predicted and observed scores
[R_pos, P_pos] = corr(all_pet,pet_pred_pos);
figure(1); plot(all_pet,pet_pred_pos,'r.');
name1=sprintf('Posi: r=%.2f, p=%.4f\n',R_pos, P_pos);
title(name1);

[R_neg, P_neg] = corr(all_pet,pet_pred_neg);
figure(2); plot(all_pet,pet_pred_neg,'b.');
name2=sprintf('Nega: r=%.2f, p=%.4f\n',R_neg, P_neg);
title(name2);

