% x = -3:0.5:3;
% y = -3:0.5:3;
% [X,Y] = meshgrid(x, y);
% Z = Y.^2 - X.^2;
% [U,V,W] = surfnorm(Z);

xxxx = 1465;
tmp_m = mod( xxxx, M_x_max );
    if tmp_m == 0
        m = M_x_max;
    else
        m = tmp_m;
    end

    if mod( xxxx, M_x_max * M_y_max ) == 0
        n = M_y_max;
    else
        n = ( mod( xxxx, M_x_max * M_y_max ) - m ) / M_x_max + 1;
    end
    
    ell_all = int32(( xxxx - m - ( n - 1 ) * M_x_max ) / ( M_x_max * M_y_max ) + 1);

    [m, n, ell_all]