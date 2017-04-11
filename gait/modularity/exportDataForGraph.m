
fid = fopen('~/Desktop/summaryForGraph.csv','w+');
fprintf(fid,'Var,muG1,muG2,muG3,sdG1,sdG2,sdG3\n');
% fprintf(fid,'Var,muG1,muG2,muG3,muG4,sdG1,sdG2,sdG3,sdG4\n');

for i=1:length(analVars),
    X = T_skim.(analVars{i});
    dat1 = X(ci_best==1);
    dat2 = X(ci_best==3);
    dat3 = X(ci_best==5);
%     dat4 = X(ci_best==5);
    % fprintf(fid,'%s, %.2f +- %.2f, %.2f +- %.2f\n',analVars{i}, mean(dat1),std(dat1),mean(dat2),std(dat2),fvals(i), FDRp(i));
    fprintf(fid,'%s, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f\n',analVars{i}, mean(dat1),mean(dat2),mean(dat3),std(dat1),std(dat2),std(dat3));
%     fprintf(fid,'%s, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f\n',analVars{i}, mean(dat1),mean(dat2),mean(dat3),mean(dat4), std(dat1),std(dat2),std(dat3),std(dat4));
end
fclose(fid);