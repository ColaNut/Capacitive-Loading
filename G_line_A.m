function [ A_row ] = G_line_A( line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon, epsilon_b )
    
    A_row = zeros( 1, M_x_max * M_y_max * N_max );
    
switch line_idx
    case 1
        A_row( p1 ) = ( epsilon(p + 1) + epsilon_b ) * d_x * d_y / ( 2 * d_z(p + 1) ); % ell + 1
        A_row( p2 ) = epsilon(p + 1) * d_y * d_z(p + 1) / (2 * d_x) + epsilon(p) * d_y * d_z(p) / (2 * d_x); % m - 1
        A_row( p3 ) = ( epsilon(p) + epsilon_b ) * d_x * d_y / ( 2 * d_z(p) ); % ell - 1
        A_row( p4 ) = epsilon_b * d_y * ( d_z(p) + d_z(p + 1) ) / (2 * d_x); % m + 1
        A_row( p5 ) = epsilon(p + 1) * d_x * d_z(p + 1) / (4 * d_y) + ...
            epsilon(p) * d_x * d_z(p) / (4 * d_y) + epsilon_b * d_x * ( d_z (p) + d_z(p + 1) ) / (4 * d_y);  % n + 1
        A_row( p6 ) = A_row( p5 ); % n - 1
        A_row( p0 ) = - ( A_row( p1 ) + A_row( p2 ) + A_row( p3 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center point
    case 2
        A_row( p1 ) = ( epsilon(p + 1) + epsilon_b ) * d_x * d_y / ( 2 * d_z(p + 1) ); % ell + 1
        A_row( p2 ) = epsilon_b * d_y * ( d_z(p) + d_z(p + 1) ) / (2 * d_x); % m - 1
        A_row( p3 ) = ( epsilon(p) + epsilon_b ) * d_x * d_y / ( 2 * d_z(p) ); % ell - 1
        A_row( p4 ) = epsilon(p + 1) * d_y * d_z(p + 1) / (2 * d_x) + epsilon(p) * d_y * d_z(p) / (2 * d_x); % m + 1
        A_row( p5 ) = epsilon(p + 1) * d_x * d_z(p + 1) / (4 * d_y) + epsilon(p) * d_x * d_z(p) / (4 * d_y) + epsilon_b * d_x * ( d_z (p) + d_z(p + 1) ) / (4 * d_y);  % n + 1
        A_row( p6 ) = A_row( p5 ); % n - 1
        A_row( p0 ) = - ( A_row( p1 ) + A_row( p2 ) + A_row( p3 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center points
    case 3
        A_row( p1 ) = ( epsilon(p + 1) + epsilon_b ) * d_x * d_y / ( 2 * d_z(p + 1) ); % ell + 1
        A_row( p2 ) = epsilon(p + 1) * d_y * d_z(p + 1) / (4 * d_x) ...
            + epsilon(p) * d_y * d_z(p) / (4 * d_x) + epsilon_b * d_y * ( d_z(p) + d_z(p + 1) ) / (4 * d_x); % m - 1
        A_row( p3 ) = ( epsilon(p) + epsilon_b ) * d_x * d_y / ( 2 * d_z(p)) ; % ell - 1
        A_row( p4 ) = A_row( p2 ); % m + 1
        A_row( p5 ) = epsilon_b * d_x * ( d_z(p) + d_z(p + 1) ) / (2 * d_y); % n + 1
        A_row( p6 ) = epsilon(p + 1) * d_x * d_z(p + 1) / (2 * d_y) + epsilon(p) * d_x * d_z(p) / (2 * d_y); % n - 1
        A_row( p0 ) = - ( A_row( p1 ) + A_row( p2 ) + A_row( p3 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center point
    case 4
        A_row( p1 ) = ( epsilon(p + 1) + epsilon_b ) * d_x * d_y / ( 2 * d_z(p + 1) ); % ell + 1
        A_row( p2 ) = epsilon(p + 1) * d_y * d_z(p + 1) / (4 * d_x) ...
            + epsilon(p) * d_y * d_z(p) / (4 * d_x) + epsilon_b * d_y * ( d_z(p) + d_z(p + 1) ) / (4 * d_x); % m - 1
        A_row( p3 ) = ( epsilon(p) + epsilon_b ) * d_x * d_y / ( 2 * d_z(p) ); % ell - 1
        A_row( p4 ) = A_row( p2 ); % m + 1
        A_row( p5 ) = epsilon(p + 1) * d_x * d_z(p + 1) / (2 * d_y) + epsilon(p) * d_x * d_z(p) / (2 * d_y); % n + 1
        A_row( p6 ) = epsilon_b * d_x * ( d_z(p) + d_z(p + 1) ) / (2 * d_y); % n - 1
        A_row( p0 ) = - ( A_row( p1 ) + A_row( p2 ) + A_row( p3 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center point
    otherwise
        disp('wrong')
end

end


