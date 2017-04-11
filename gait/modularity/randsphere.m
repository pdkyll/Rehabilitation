function [x,y,z] = randsphere(N)
rvals = 2*rand(N,1)-1;
elevation = asin(rvals);
azimuth = 2*pi*rand(N,1);

radii = 3*(rand(N,1).^(1/3));
[x,y,z] = sph2cart(azimuth,elevation,radii);
x = x/max(abs(x));
y = y/max(abs(y));
z = z/max(abs(z));
