function [ A_row ] = bolus_horizental_line_da_A( line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da, epsilon, epsilon_b, Epsilon_0 )
    
    A_row = zeros( 1, M_x_max * M_y_max * ( N_da + N_max + N_10 ) );
    
    if ~( p == 0)
        error('Invalid layer');
    end

switch line_idx
    case 1
        A_row( p1 ) = ( epsilon_b + Epsilon_0 ) * d_x * d_y / ( 2 * d_z(1) ); % ell + 1
        A_row( p2 ) = epsilon_b * d_y * d_z(1) / (2 * d_x) + Epsilon_0 * d_y * d_z_da / (2 * d_x); % m - 1
        A_row( p3 ) = ( Epsilon_0 + Epsilon_0 ) * d_x * d_y / ( 2 * d_z_da ); % ell - 1
        A_row( p4 ) = Epsilon_0 * d_y * ( d_z_da + d_z(1) ) / (2 * d_x); % m + 1
        A_row( p5 ) = epsilon_b * d_x * d_z(1) / (4 * d_y) + ...
            Epsilon_0 * d_x * d_z_da / (4 * d_y) + Epsilon_0 * d_x * ( d_z_da + d_z(1) ) / (4 * d_y);  % n + 1
        A_row( p6 ) = A_row( p5 ); % n - 1
        A_row( p0 ) = - ( A_row( p1 ) + A_row( p2 ) + A_row( p3 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center point
    case 2
        A_row( p1 ) = ( epsilon_b + Epsilon_0 ) * d_x * d_y / ( 2 * d_z(1) ); % ell + 1
        A_row( p2 ) = Epsilon_0 * d_y * ( d_z_da + d_z(1) ) / (2 * d_x); % m - 1
        A_row( p3 ) = ( Epsilon_0 + Epsilon_0 ) * d_x * d_y / ( 2 * d_z_da ); % ell - 1
        A_row( p4 ) = epsilon_b * d_y * d_z(1) / (2 * d_x) + Epsilon_0 * d_y * d_z_da / (2 * d_x); % m + 1
        A_row( p5 ) = epsilon_b * d_x * d_z(1) / (4 * d_y) + Epsilon_0 * d_x * d_z_da / (4 * d_y) + Epsilon_0 * d_x * ( d_z_da + d_z(1) ) / (4 * d_y);  % n + 1
        A_row( p6 ) = A_row( p5 ); % n - 1
        A_row( p0 ) = - ( A_row( p1 ) + A_row( p2 ) + A_row( p3 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center points
    case 3
        A_row( p1 ) = ( epsilon_b + Epsilon_0 ) * d_x * d_y / ( 2 * d_z(1) ); % ell + 1
        A_row( p2 ) = epsilon_b * d_y * d_z(1) / (4 * d_x) ...
            + Epsilon_0 * d_y * d_z_da / (4 * d_x) + Epsilon_0 * d_y * ( d_z_da + d_z(1) ) / (4 * d_x); % m - 1
        A_row( p3 ) = ( Epsilon_0 + Epsilon_0 ) * d_x * d_y / ( 2 * d_z_da) ; % ell - 1
        A_row( p4 ) = A_row( p2 ); % m + 1
        A_row( p5 ) = Epsilon_0 * d_x * ( d_z_da + d_z(1) ) / (2 * d_y); % n + 1
        A_row( p6 ) = epsilon_b * d_x * d_z(1) / (2 * d_y) + Epsilon_0 * d_x * d_z_da / (2 * d_y); % n - 1
        A_row( p0 ) = - ( A_row( p1 ) + A_row( p2 ) + A_row( p3 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center point
    case 4
        A_row( p1 ) = ( epsilon_b + Epsilon_0 ) * d_x * d_y / ( 2 * d_z(1) ); % ell + 1
        A_row( p2 ) = epsilon_b * d_y * d_z(1) / (4 * d_x) ...
            + Epsilon_0 * d_y * d_z_da / (4 * d_x) + Epsilon_0 * d_y * ( d_z_da + d_z(1) ) / (4 * d_x); % m - 1
        A_row( p3 ) = ( Epsilon_0 + Epsilon_0 ) * d_x * d_y / ( 2 * d_z_da ); % ell - 1
        A_row( p4 ) = A_row( p2 ); % m + 1
        A_row( p5 ) = epsilon_b * d_x * d_z(1) / (2 * d_y) + Epsilon_0 * d_x * d_z_da / (2 * d_y); % n + 1
        A_row( p6 ) = Epsilon_0 * d_x * ( d_z_da + d_z(1) ) / (2 * d_y); % n - 1
        A_row( p0 ) = - ( A_row( p1 ) + A_row( p2 ) + A_row( p3 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center point
    otherwise
        error('wrong');
end

end