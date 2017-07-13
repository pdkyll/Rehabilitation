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
% for full reference). The first input ('all_vcts') is a pre-calculated
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



% Voxelwise Behavior Prediction Model (VBPM)


clear;
clc;

% ------------ LOAD Behavior data -----------
proj_path = '/Volumes/JetDrive/data/RM_kdh';

T1 = readtable(fullfile(proj_path,'parkinson','demographic','list_of_variables.xlsx'));
varName = T1.list_of_variables;
[IMGs, T_pt, vo_mask, idmask] = load_masked_data;
all_behav = table2array(T_pt);
all_behav(:,1:2) = [];
all_vcts  = IMGs;


% threshold for feature selection
p_thresh = 0.005;
v_thresh = 10;

% ---------------------------------------
nsub = size(all_vcts,1);
nvox = size(all_vcts,2);
nbeh = size(all_behav,2);

behav_pred_pos = nan(nbeh,nsub);
behav_pred_neg = nan(nbeh,nsub);

CommonVoxels = struct();
for i=1:nbeh,
    
    a_behav = all_behav(:,i);
    fprintf('VBPM - Variable Name: %s\n',varName{i});
    
    commonVx_pos = [];
    commonVx_neg = [];
    
    
    for leftout = 1:nsub;
        %fprintf('\n Leaving out subj # %6.3f',leftout);
        
        % leave out subject from matrices and behavior
        train_vcts = all_vcts;
        train_vcts(leftout,:) = [];
        
        train_behav = a_behav;
        train_behav(leftout) = [];
        
        
        % TEST subject
        test_vct = all_vcts(leftout,:);
        
        
        % correlate all edges with behavior
        [r_vct,p_vct] = corr(train_vcts,train_behav);
        
        
        % set threshold and define masks
        pos_mask = zeros(nvox,1);
        neg_mask = zeros(nvox,1);
        
        pos_nodes = find(r_vct > 0 & p_vct < p_thresh);
        neg_nodes = find(r_vct < 0 & p_vct < p_thresh);
        
        pos_mask(pos_nodes) = 1;
        neg_mask(neg_nodes) = 1;
        
        % Identify common voxels
        if leftout==1,
            commonVx_pos = find(pos_mask);
            commonVx_neg = find(neg_mask);
        else
            commonVx_pos = intersect(commonVx_pos,find(pos_mask));
            commonVx_neg = intersect(commonVx_neg,find(neg_mask));
        end
        
        % get sum of all edges in TRAIN subs (divide by 2 to control for the
        % fact that matrices are symmetric)
        train_sumpos = train_vcts*pos_mask;
        train_sumneg = train_vcts*neg_mask;
        
        if sum(pos_mask)>=v_thresh,
            P_pos = polyfit(train_sumpos, train_behav,1);
            
            % build model on TRAIN subs
            test_sumpos = test_vct*pos_mask;
            
            % run model on TEST sub
            behav_pred_pos(i,leftout) = polyval(P_pos,test_sumpos);
        end
        if sum(neg_mask)>=v_thresh,
            P_neg = polyfit(train_sumneg, train_behav,1);
            
            % build model on TRAIN subs
            test_sumneg = test_vct*neg_mask;
            
            % run model on TEST sub
            behav_pred_neg(i,leftout) = polyval(P_neg,test_sumneg);
        end
        
    end
    CommonVoxels(i).Positive = commonVx_pos;
    CommonVoxels(i).Negative = commonVx_neg;
    
end


% Find variable name that can be predicted using PET
for i=1:nbeh,
    pos_mask = CommonVoxels(i).Positive;
    neg_mask = CommonVoxels(i).Negative;
    
    if ~isempty(pos_mask),
        % Significance of behavioral prediction model
        [R_pos, P_pos] = corrcoef(behav_pred_pos(i,:)',all_behav(:,i));
        if P_pos(1,2)<0.05
            fprintf('%s, nPos=%d\n',varName{i},length(pos_mask));
            vo = vo_mask;
            vo.fname=fullfile('ROIpred',[varName{i} '_pos.nii']);
            IMG = zeros(vo.dim);
            IMG(idmask(pos_mask))=1;
            spm_write_vol(vo,IMG);
            
            % compare predicted and observed scores
            figure; plot(behav_pred_pos(i,:),all_behav(:,i)','r.');
            title(['POS: ' varName{i} sprintf(' p=%.3f',P_pos(1,2))]);
        end
    end
    if ~isempty(neg_mask),
        % Significance of behavioral prediction model
        [R_neg, P_neg] = corrcoef(behav_pred_neg(i,:)',all_behav(:,i));
        if P_neg(1,2)<0.05,
            fprintf('%s, nNeg=%d\n',varName{i},length(neg_mask));
            vo = vo_mask;
            vo.fname=fullfile('ROIpred',[varName{i} '_neg.nii']);
            IMG = zeros(vo.dim);
            IMG(idmask(neg_mask))=1;
            spm_write_vol(vo,IMG);
            
            % compare predicted and observed scores
            figure; plot(behav_pred_neg(i,:),all_behav(:,i)','b.');
            title(['NEG: ' varName{i} sprintf(' p=%.3f',P_neg(1,2))]);
        end
    end
end

