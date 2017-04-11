function POS = position_circular(Ci)

n_partition = max(Ci);
nrois = length(Ci);
k = 1:n_partition;
pk = hist(Ci,k); pk = pk./sum(pk);

r_inter = 80;
r_intra = 12;
theta = [pi/2:2*pi/n_partition:2*pi+pi/2];
theta = theta(1:n_partition);

x_c = r_inter*cos(theta);
y_c = r_inter*sin(theta);
POS = zeros(nrois,2);


for i=1:n_partition,
    idx = find(Ci==i);
    n_idx = length(idx);
    theta = [0:2*pi/n_idx:2*pi-eps]; theta = theta(1:n_idx);
    xx = r_intra*cos(theta)*pk(i);
    yy = r_intra*sin(theta)*pk(i);
    
    x = r_intra*xx+x_c(i);
    y = r_intra*yy+y_c(i);
    
    POS(idx,:) = [x', y'];
end

