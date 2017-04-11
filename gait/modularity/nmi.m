function v = nmi(x, y)
% Compute nomalized mutual information I(x,y)/sqrt(H(x)*H(y)).
% Written by Michael Chen (sth4nth@gmail.com).

assert(numel(x) == numel(y));
n = numel(x);
x = reshape(x,1,n);
y = reshape(y,1,n);

l = min(min(x),min(y));
x = x-l+1;
y = y-l+1;
k = max(max(x),max(y));

idx = 1:n;
Mx = sparse(idx,x,1,n,k,n);
My = sparse(idx,y,1,n,k,n);
Pxy = nonzeros(Mx'*My/n); %joint distribution of x and y

Px = mean(Mx,1);
Py = mean(My,1);

% entropy of Px, Py, and Pxy
Hx = -dot(Px,log2(Px+eps));
Hy = -dot(Py,log2(Py+eps));
Hxy = -dot(Pxy,log2(Pxy+eps));


% mutual information
MI = Hx + Hy - Hxy;

% normalized mutual information
v = sqrt((MI/Hx)*(MI/Hy)) ;
