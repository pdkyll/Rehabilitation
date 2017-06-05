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
N        = length(Ndata);


%--------------------------------------------------------------------------
% Correlation Analysis
%--------------------------------------------------------------------------
[R,P] = corrcoef(Ndata');


%--------------------------------------------------------------------------
% Thresholding
%--------------------------------------------------------------------------
U = ones(N,N); triU = triu(U,1);
idxU = find(triU>0);

% FDR-corrected
[h, corr_p, adj_ci_cvrg, adj_p]=fdr_bh(P(idxU));
idremove = find(P>=corr_p);
G = R;
G(idremove)  = 0;
G(eye(N)==1) = 0;



%--------------------------------------------------------------------------
%  Performing Community Detection
%--------------------------------------------------------------------------
fprintf('    : Community detection\n');
niter = 1000;
Ci    = zeros(niter,N);
Q     = zeros(niter,1);
parfor i=1:niter,
    [ci1,q1] = community_louvain(G,[],[],'negative_sym');
    Ci(i,:) = ci1;
    Q(i) = q1;
end



%--------------------------------------------------------------------------
%  Module Similarity
%--------------------------------------------------------------------------
fprintf('    : Module similarity\n');
sNMI = zeros(niter,niter);
for ci=1:niter,
    for cj=(ci+1):niter,
        mutualinfo = nmi(Ci(ci,:), Ci(cj,:));
        sNMI(ci,cj) = mutualinfo;
    end
end
NMI = sNMI + sNMI';


%--------------------------------------------------------------------------
%  Find the Best Community
%--------------------------------------------------------------------------
[val1, idx1] = max(mean(NMI));
ci_best = squeeze(Ci(idx1,:));
pk = hist(ci_best,1:max(ci_best));



%--------------------------------------------------------------------------
%  Plot Results
%--------------------------------------------------------------------------
POS = position_sphere(ci_best);
moduleview2d_sign(R, ci_best, POS);


%--------------------------------------------------------------------------
%  Analysis of Variance (after removing dummy groups)
%--------------------------------------------------------------------------
M = ci_best;
M(M==1)=nan; M(M==3)=nan; M(M==4)=nan;

fvals = zeros(length(analVars),1);
pvals = ones(length(analVars),1);
etas  = zeros(length(analVars),1);
for i=1:length(analVars),
    X = T_skim.(analVars{i});
    [P, anovaTab] = anova1(X,M,'off');
    pvals(i) = P;
    fvals(i) = cell2mat(anovaTab(2,5));
    etas(i) = cell2mat(anovaTab(2,2))/cell2mat(anovaTab(4,2));
end
[h, pthr, adj_ci_cvrg, FDRp]=fdr_bh(pvals);



%--------------------------------------------------------------------------
%  Write Results
%--------------------------------------------------------------------------
dlmwrite('~/Desktop/data.csv',skimData);
dlmwrite('~/Desktop/ci_best.csv',ci_best(:));
dlmwrite('~/Desktop/subjid.csv',table2array(T(T.CL==CL,{'subjid'})));
dlmwrite('~/Desktop/age.csv',table2array(T(T.CL==CL,{'Age'})));


fid = fopen('~/Desktop/summary.csv','w+');
% fprintf(fid,'Var,G1,G2,F(%d_%d),Corr_P\n',cell2mat(anovaTab([2 3],3)));
% fprintf(fid,',n=%d,n=%d\n',sum(M==2),sum(M==5));
fprintf(fid,'Var,G1,G2,G3,F(%d_%d),Corr_P\n',cell2mat(anovaTab([2 3],3)));
fprintf(fid,',n=%d,n=%d,n=%d\n',sum(M==2),sum(M==5),sum(M==6));
% fprintf(fid,'Var,G1,G2,G3,G4,F(%d_%d),Corr_P\n',cell2mat(anovaTab([2 3],3)));
% fprintf(fid,',n=%d,n=%d,n=%d,n=%d\n',sum(M==3),sum(M==4),sum(M==5),sum(M==6));

for i=1:length(analVars),
    X = T_skim.(analVars{i});
    dat1 = X(ci_best==2);
    dat2 = X(ci_best==5);
    dat3 = X(ci_best==6);
%     dat4 = X(ci_best==6);
    % fprintf(fid,'%s, %.2f +- %.2f, %.2f +- %.2f, %.2f, %.3f\n',analVars{i}, mean(dat1),std(dat1),mean(dat2),std(dat2),fvals(i), FDRp(i));
    fprintf(fid,'%s, %.2f +- %.2f, %.2f +- %.2f, %.2f +- %.2f, %.2f, %.3f\n',analVars{i}, mean(dat1),std(dat1),mean(dat2),std(dat2),mean(dat3),std(dat3),fvals(i), FDRp(i));
%     fprintf(fid,'%s, %.2f +- %.2f, %.2f +- %.2f, %.2f +- %.2f, %.2f +- %.2f, %.2f, %.3f\n',analVars{i}, mean(dat1),std(dat1),mean(dat2),std(dat2),mean(dat3),std(dat3),mean(dat4),std(dat4),fvals(i), FDRp(i));
end
fclose(fid);

save(saveName);




figure; imagesc(skimData'); colormap('PARULA')
figure; imagesc(Ndata');colormap('PARULA')
figure; imagesc(R)
figure; imagesc(G)
