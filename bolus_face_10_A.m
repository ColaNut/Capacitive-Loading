function [ A_row ] = bolus_face_10_A( face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon, epsilon_b )
    
    A_row = zeros( 1, M_x_max * M_y_max * ( N_max + N_10 ) );
    
    A_row( p0 ) = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 + 1 / ( d_z(p) * d_z_10 ) ); % center point
    A_row( p4 ) = ( 1 / d_x )^2; % m + 1
    A_row( p2 ) = ( 1 / d_x )^2; % m - 1
    A_row( p5 ) = ( 1 / d_y )^2; % n + 1
    A_row( p6 ) = ( 1 / d_y )^2; % n - 1
    A_row( p1 ) = 1 / ( d_z_10 * ( d_z(p) + d_z_10 ) / 2 ); % ell + 1
    A_row( p3 ) = 1 / ( d_z(p) * ( d_z(p) + d_z_10 ) / 2 ); % ell - 1

end