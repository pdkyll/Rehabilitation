function POS = position_sphere(Ci)

n_partition = max(Ci);
nrois = length(Ci);
k = 1:n_partition;
pk = hist(Ci,k); pk = pk./sum(pk);

r_inter = 60;
r_intra = 100;
theta = [pi/2:2*pi/n_partition:2*pi+pi/2];
theta = theta(1:n_partition);

x_c = r_inter*cos(theta);
y_c = r_inter*sin(theta);
POS = zeros(nrois,2);


for i=1:n_partition,
    idx = find(Ci==i);
    n_idx = length(idx);
    
    [xx,yy] = randsphere(n_idx);
    
    x = r_intra*xx*pk(i)+x_c(i);
    y = r_intra*yy*pk(i)+y_c(i);
    
    POS(idx,:) = [x(:), y(:)];
end

