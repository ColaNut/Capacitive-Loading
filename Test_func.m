x = -3:0.5:3;
y = -3:0.5:3;
[X,Y] = meshgrid(x, y);
Z = Y.^2 - X.^2;
[U,V,W] = surfnorm(Z);

m = 7;
n = 7;
ell = 30;

idx = ( ell - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_x_max + m
