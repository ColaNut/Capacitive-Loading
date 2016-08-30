function [ A_row ] = air_face_da_A( face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da, epsilon, epsilon_b, Epsilon_0 )
    
    A_row = zeros( 1, M_x_max * M_y_max * ( N_da + N_max + N_10 ) );
    
    A_row( p0 ) = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 + 1 / ( d_z_da * d_z(1) ) ); % center point
    A_row( p4 ) = ( 1 / d_x )^2; % m + 1
    A_row( p2 ) = ( 1 / d_x )^2; % m - 1
    A_row( p5 ) = ( 1 / d_y )^2; % n + 1
    A_row( p6 ) = ( 1 / d_y )^2; % n - 1
    A_row( p1 ) = 1 / ( d_z(1) * ( d_z_da + d_z(1) ) / 2 ); % ell + 1
    A_row( p3 ) = 1 / ( d_z_da * ( d_z_da + d_z(1) ) / 2 ); % ell - 1

end