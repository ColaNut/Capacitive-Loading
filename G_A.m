function [ A_row ] = G_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon )
    
    A_row = zeros(1, 14);
    % A_row = zeros( 1, M_x_max * M_y_max * N_max );

    A_row(1) = p1;
    A_row(2) = p2;
    A_row(3) = p3;
    A_row(4) = p4;
    A_row(5) = p5;
    A_row(6) = p6;
    A_row(7) = p0;
    A_row(8)  = epsilon(p + 1) * d_x * d_y / d_z(p + 1); % ell + 1
    A_row(9)  = epsilon(p + 1) * d_y * d_z(p + 1) / (2 * d_x) + epsilon(p) * d_y * d_z(p) / (2 * d_x); % m - 1
    A_row(10) = epsilon(p) * d_x * d_y / d_z(p); % ell - 1
    A_row(11) = A_row( 9 ); % m + 1
    A_row(12) = epsilon(p + 1) * d_x * d_z(p + 1) / (2 * d_y) + epsilon(p) * d_x * d_z(p) / (2 * d_y);  % n + 1
    A_row(13) = A_row( 12 ); % n - 1
    A_row(14) = - ( A_row( 8 ) + A_row( 9 ) + A_row( 10 ) + A_row( 11 ) + A_row( 12 ) + A_row( 13 ) ); % center point

end