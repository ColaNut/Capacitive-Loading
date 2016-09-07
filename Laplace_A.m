function [ A_row ] = Laplace_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z )

    A_row = zeros(1, 14);
    % A_row = zeros( 1, M_x_max * M_y_max * N_max );

    A_row(1)  = p0;
    A_row(2)  = p4;
    A_row(3)  = p2;
    A_row(4)  = p5;
    A_row(5)  = p6;
    A_row(6)  = p1;
    A_row(7)  = p3;
    A_row(8)  = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 + (1 / d_z(p))^2 ); % center point
    A_row(9)  = ( 1 / d_x )^2; % m + 1
    A_row(10) = ( 1 / d_x )^2; % m - 1
    A_row(11) = ( 1 / d_y )^2; % n + 1
    A_row(12) = ( 1 / d_y )^2; % n - 1
    A_row(13) = ( 1 / d_z(p) )^2; % ell + 1
    A_row(14) = ( 1 / d_z(p) )^2; % ell - 1

end