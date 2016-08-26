function [ A_row ] = bolus_point_10_A( point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon, epsilon_b, Epsilon_0 )
    
A_row = zeros( 1, M_x_max * M_y_max * ( N_max + N_10 ) );
    
switch point_idx
    case 1
        A_row( p1 ) = ( Epsilon_0 + Epsilon_0 ) * d_x * d_y / ( 4 * d_z_10 ) + Epsilon_0 * d_x * d_y / ( 2 * d_z_10 ); % ell + 1
        A_row( p2 ) = Epsilon_0 * d_y * d_z_10 / (4 * d_x) + epsilon_b * d_y * d_z(p) / (4 * d_x) + Epsilon_0 * d_y * ( d_z(p) + d_z_10 ) / (4 * d_x); % m - 1
        A_row( p3 ) = ( epsilon_b + Epsilon_0 ) * d_x * d_y / ( 4 * d_z(p) ) + Epsilon_0 * d_x * d_y / ( 2 * d_z(p) ); % ell - 1
        A_row( p4 ) = Epsilon_0 * d_y * ( d_z(p) + d_z_10 ) / (2 * d_x); % m + 1
        A_row( p5 ) = Epsilon_0 * d_x * ( d_z(p) + d_z_10 ) / (2 * d_y); % n + 1
        A_row( p6 ) = Epsilon_0 * d_x * d_z_10 / (4 * d_y) + epsilon_b * d_x * d_z(p) / (4 * d_y) + Epsilon_0 * d_x * ( d_z (p) + d_z_10 ) / (4 * d_y);  % n - 1
        A_row( p0 ) = - ( A_row( p1 ) + A_row( p2 ) + A_row( p3 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center point
    case 2
        A_row( p1 ) = ( Epsilon_0 + Epsilon_0 ) * d_x * d_y / ( 4 * d_z_10 ) + Epsilon_0 * d_x * d_y / ( 2 * d_z_10 ); % ell + 1
        A_row( p2 ) = Epsilon_0 * d_y * d_z_10 / (4 * d_x) + epsilon_b * d_y * d_z(p) / (4 * d_x) + Epsilon_0 * d_y * ( d_z(p) + d_z_10 ) / (4 * d_x); % m - 1
        A_row( p3 ) = ( epsilon_b + Epsilon_0 ) * d_x * d_y / ( 4 * d_z(p) ) + Epsilon_0 * d_x * d_y / ( 2 * d_z(p) ); % ell - 1
        A_row( p4 ) = Epsilon_0 * d_y * ( d_z(p) + d_z_10 ) / (2 * d_x); % m + 1
        A_row( p5 ) = Epsilon_0 * d_x * d_z_10 / (4 * d_y) + epsilon_b * d_x * d_z(p) / (4 * d_y) + Epsilon_0 * d_x * ( d_z (p) + d_z_10 ) / (4 * d_y);  % n + 1
        A_row( p6 ) = Epsilon_0 * d_x * ( d_z(p) + d_z_10 ) / (2 * d_y); % n - 1
        A_row( p0 ) = - ( A_row( p1 ) + A_row( p2 ) + A_row( p3 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center points
    case 3
        A_row( p1 ) = ( Epsilon_0 + Epsilon_0 ) * d_x * d_y / ( 4 * d_z_10 ) + Epsilon_0 * d_x * d_y / ( 2 * d_z_10 ); % ell + 1
        A_row( p2 ) = Epsilon_0 * d_y * ( d_z(p) + d_z_10 ) / (2 * d_x); % m - 1
        A_row( p3 ) = ( epsilon_b + Epsilon_0 ) * d_x * d_y / ( 4 * d_z(p) ) + Epsilon_0 * d_x * d_y / ( 2 * d_z(p) ); % ell - 1
        A_row( p4 ) = Epsilon_0 * d_y * d_z_10 / (4 * d_x) + epsilon_b * d_y * d_z(p) / (4 * d_x) + Epsilon_0 * d_y * ( d_z(p) + d_z_10 ) / (4 * d_x); % m + 1
        A_row( p5 ) = Epsilon_0 * d_x * ( d_z(p) + d_z_10 ) / (2 * d_y); % n + 1
        A_row( p6 ) = Epsilon_0 * d_x * d_z_10 / (4 * d_y) + epsilon_b * d_x * d_z(p) / (4 * d_y) + Epsilon_0 * d_x * ( d_z (p) + d_z_10 ) / (4 * d_y);  % n - 1
        A_row( p0 ) = - ( A_row( p1 ) + A_row( p2 ) + A_row( p3 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center point
    case 4
        A_row( p1 ) = ( Epsilon_0 + Epsilon_0 ) * d_x * d_y / ( 4 * d_z_10 ) + Epsilon_0 * d_x * d_y / ( 2 * d_z_10 ); % ell + 1
        A_row( p2 ) = Epsilon_0 * d_y * ( d_z(p) + d_z_10 ) / (2 * d_x); % m - 1
        A_row( p3 ) = ( epsilon_b + Epsilon_0 ) * d_x * d_y / ( 4 * d_z(p) ) + Epsilon_0 * d_x * d_y / ( 2 * d_z(p) ); % ell - 1
        A_row( p4 ) = Epsilon_0 * d_y * d_z_10 / (4 * d_x) + epsilon_b * d_y * d_z(p) / (4 * d_x) + Epsilon_0 * d_y * ( d_z(p) + d_z_10 ) / (4 * d_x); % m + 1
        A_row( p5 ) = Epsilon_0 * d_x * d_z_10 / (4 * d_y) + epsilon_b * d_x * d_z(p) / (4 * d_y) + Epsilon_0 * d_x * ( d_z (p) + d_z_10 ) / (4 * d_y); % n + 1
        A_row( p6 ) = Epsilon_0 * d_x * ( d_z(p) + d_z_10 ) / (2 * d_y); % n - 1
        A_row( p0 ) = - ( A_row( p1 ) + A_row( p2 ) + A_row( p3 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center point
    otherwise
        disp('wrong')
end

end