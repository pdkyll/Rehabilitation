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
% during a single fMRI session. The second input ('a_behav') is the
% Nx1 vector of scores for the behavior of interest for all subjects.

% As in the reference paper, the predictive power of the model is assessed
% via correlation between predicted and observed scores across all
% subjects. Note that this assumes normal or near-normal distributions for
% both vectors, and does not assess absolute accuracy of predictions (only
% relative accuracy within the sample). It is recommended to explore
% additional/alternative metrics for assessing predictive power, such as
% prediction error sum of squares or prediction r^2.


clear;
clc;

% ------------ LOAD Behavior data -----------
proj_path = '/Volumes/JetDrive/data/RM_kdh';

T1 = readtable(fullfile(proj_path,'parkinson','demographic','list_of_variables.xlsx'));
varName = T1.list_of_variables;
[IMGs, T_pt, vo_mask, idmask] = load_masked_data;
all_behav = table2array(T_pt);
all_behav(:,1:2) = [];


% threshold for feature selection
p_thresh = 0.01;
v_thresh = 50;



% ------------ INPUTS -------------------
all_vcts  = IMGs;

for i=1:size(all_behav,2),
    a_behav = all_behav(:,i);
    nsub = size(all_vcts,1);
    ndat = size(all_vcts,2);
    
    
    % correlate all edges with behavior
    [r_vct,p_vct] = corr(all_vcts,a_behav);
    %[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(p_vct);
    
    pos_mask = (r_vct > 0 & p_vct < p_thresh);
    neg_mask = (r_vct < 0 & p_vct < p_thresh);
    
    if sum(pos_mask)<v_thresh && sum(neg_mask)<v_thresh, continue; end
    
    if sum(pos_mask)>=v_thresh,
        vo = vo_mask;
        vo.fname=fullfile('ROIpred',[varName{i} '_pos.nii']);
        IMG = zeros(vo.dim);
        IMG(idmask(pos_mask))=1;
        spm_write_vol(vo,IMG);
    end
    if sum(neg_mask)>=v_thresh,
        vo = vo_mask;
        vo.fname=fullfile('ROIpred',[varName{i} '_neg.nii']);
        IMG = zeros(vo.dim);
        IMG(idmask(neg_mask))=1;
        spm_write_vol(vo,IMG);
    end
    
    fprintf('behavior=%s, N pos=%d, N neg=%d\n',varName{i},sum(pos_mask),sum(neg_mask));

    % ---------------------------------------
    behav_pred_pos = zeros(nsub,1);
    behav_pred_neg = zeros(nsub,1);
    
    
    for leftout = 1:nsub;
        %fprintf('\n Leaving out subj # %6.3f',leftout);
        
        % Test dataset: leave out subject
        test_vct = all_vcts(leftout,:);
        
        % leave out subject from matrices and behavior
        train_vcts = all_vcts;
        train_vcts(leftout,:) = [];
        
        train_behav = a_behav;
        train_behav(leftout) = [];
        
        train_sumpos = zeros(nsub-1,1);
        train_sumneg = zeros(nsub-1,1);
        
        for ss = 1:size(train_sumpos);
            train_sumpos(ss) = train_vcts(ss,:)*pos_mask;
            train_sumneg(ss) = train_vcts(ss,:)*neg_mask;
        end
        
        % (positive vcts) build model and run model on TEST subject
        if sum(pos_mask)>0,
            fit_pos = polyfit(train_sumpos, train_behav,1);
            test_sumpos = test_vct*pos_mask;
            behav_pred_pos(leftout) = fit_pos(1)*test_sumpos + fit_pos(2);
        end
        
        % (negative vcts) build model and run model on TEST subject
        if sum(neg_mask)>0,
            fit_neg = polyfit(train_sumneg, train_behav,1);
            test_sumneg = test_vct*neg_mask;
            behav_pred_neg(leftout) = fit_neg(1)*test_sumneg + fit_neg(2);
        end
    end
    
    % compare predicted and observed scores
    if sum(pos_mask)>0,
        [R_pos, P_pos] = corr(a_behav,behav_pred_pos);
        figure; plot(a_behav,behav_pred_pos,'r.');
        msg1 = sprintf('%s (pos), r=%.2f (p=%.4f)',varName{i},R_pos,P_pos);
        title(msg1);
    end
    
    if sum(neg_mask)>0,
        [R_neg, P_neg] = corr(a_behav,behav_pred_neg);
        figure; plot(a_behav,behav_pred_neg,'b.');
        msg2 = sprintf('%s (neg),r=%.2f (p=%.4f)',varName{i},R_neg,P_neg);
        title(msg2);
    end
end