close all;
addpath('/Volumes/JetDrive/data/RM_kdh/matlabscripts/gait/modularity');
addpath('/Volumes/JetDrive/data/RM_kdh/matlabscripts/gait/');


% Parameters
% CL = 1; flipMode = 1; saveName = 'hemi';
% CL = 4; flipMode = 0; saveName = 'pain_unflip';
% CL = 4; flipMode = 2; saveName = 'pain_flip';
CL = 4; flipMode = 3; saveName = 'pain_flip';
% CL = 6; flipMode = 0; saveName = 'normal';
% CL = 7; flipMode = 0; saveName = 'parkinson';
% CL = 8; flipMode = 0; saveName = 'nerve_root_unflip';
% CL = 8; flipMode = 2; saveName = 'nerve_root_flip';
% CL = 8; flipMode = 3; saveName = 'nerve_root_flip';
XLSpath = '/Users/skyeong/Google Drive/Manuscripts/Subgroup - Gait pattern/data';


%--------------------------------------------------------------------------
% List of variables
%--------------------------------------------------------------------------
fn_xls = fullfile(XLSpath,'list_of_variables.xlsx');
TT = readtable(fn_xls, 'Sheet' ,'New');
analVars = TT.list_of_variables;  % sptmp



%--------------------------------------------------------------------------
% Load Gait Data
%--------------------------------------------------------------------------
fprintf('    : Load and skim dataset\n');
fn_xls   = fullfile(XLSpath,'gait_final_dataset.xlsx');
T        = readtable(fn_xls);
T_skim   = skim_data(T, analVars, CL,  flipMode); % skimmed data
skimData = table2array(T_skim);


%--------------------------------------------------------------------------
% Normalization
%--------------------------------------------------------------------------
muSkim   = mean(skimData);
sdSkim   = std(skimData);
Ndata    = bsxfun(@minus,   skimData,  muSkim);
Ndata    = bsxfun(@rdivide, Ndata,     sdSkim);
N        = size(Ndata,2);



%--------------------------------------------------------------------------
% Load Subgroup Information
%--------------------------------------------------------------------------
CIpath = '/Users/skyeong/Google Drive/Manuscripts/Subgroup - Gait pattern/Modularity';
fn_csv = fullfile(CIpath,[num2str(CL,'%02d') '_' saveName],'ci_best.csv');
Dx2 = dlmread(fn_csv);
pk = hist(Dx2,unique(Dx2));
idgs = find(pk>=15);
ngrp = length(idgs);

GRAPH = struct();
for i=1:ngrp,
    
    %----------------------------------------------------------------------
    % Correlation Analysis
    %----------------------------------------------------------------------
    Ndata2 = Ndata(Dx2==idgs(i),:);
    [R,P] = corrcoef(Ndata2);
    
    
    %----------------------------------------------------------------------
    % Thresholding
    %----------------------------------------------------------------------
    U = ones(N,N); triU = triu(U,1);
    idxU = find(triU>0);
    
    % FDR-corrected
    [h, corr_p, adj_ci_cvrg, adj_p]=fdr_bh(P(idxU));
    idremove = find(P>=corr_p);
    G = R;
    G(idremove)  = 0;
    G(eye(N)==1) = 0;
    
    
    
    %----------------------------------------------------------------------
    %  Performing Community Detection
    %----------------------------------------------------------------------
    fprintf('    : Community detection\n');
    niter = 1000;
    Ci    = zeros(niter,N);
    Q     = zeros(niter,1);
    parfor j=1:niter,
        [ci1,q1] = community_louvain(G,[],[],'negative_sym');
        Ci(j,:) = ci1;
        Q(j) = q1;
    end
    
    
    
    %----------------------------------------------------------------------
    %  Module Similarity
    %----------------------------------------------------------------------
    fprintf('    : Module similarity\n');
    sNMI = zeros(niter,niter);
    for ci=1:niter,
        for cj=(ci+1):niter,
            mutualinfo = nmi(Ci(ci,:), Ci(cj,:));
            sNMI(ci,cj) = mutualinfo;
        end
    end
    NMI = sNMI + sNMI';
    
    
    %----------------------------------------------------------------------
    %  Find the Best Community
    %----------------------------------------------------------------------
    [val1, idx1] = max(mean(NMI));
    ci_best = squeeze(Ci(idx1,:));
    GRAPH(i).ci_best = ci_best;
    
    
    
    %----------------------------------------------------------------------
    %  Plot Results
    %----------------------------------------------------------------------
    POS = position_sphere(ci_best);
    moduleview2d_sign(R, ci_best, POS);
    GRAPH(i).R = R;
    GRAPH(i).POS = POS;
end


%--------------------------------------------------------------------------
%  Write Results
%--------------------------------------------------------------------------
if ngrp==3,
    fid = fopen('~/Desktop/variables_grouping.csv','w+');
    fprintf(fid,'id,Variable Name,G1,G2,G3\n');
    for j=1:length(analVars),
        fprintf(fid,'%d, %s, %d, %d, %d\n',j,analVars{j}, GRAPH(1).ci_best(j), GRAPH(2).ci_best(j), GRAPH(3).ci_best(j));
    end
    fclose(fid);
elseif ngrp==4,
    id = fopen('~/Desktop/variables_grouping.csv','w+');
    fprintf(fid,'id,Variable Name,G1,G2,G3,G4\n');
    for j=1:length(analVars),
        fprintf(fid,'%d, %s, %d, %d, %d, %d\n',j,analVars{j}, GRAPH(1).ci_best(j), GRAPH(2).ci_best(j), GRAPH(3).ci_best(j), GRAPH(4).ci_best(j));
    end
    fclose(fid);
end