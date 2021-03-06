function [ A_row ] = CD_line_A( line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon, epsilon_b )
    
    % check this.
    % A_row = zeros( 1, M_x_max * M_y_max * N_max );
    A_row = zeros(1, 14);

switch line_idx
    case 1
        A_row(1)  = p1;
        A_row(2)  = p2;
        A_row(3)  = p3;
        A_row(4)  = p4;
        A_row(5)  = p5;
        A_row(6)  = p6;
        A_row(7)  = p0;
        A_row(8)  = ( epsilon(p) + epsilon_b ) * d_x * d_y / ( 4 * d_z(p) ) + epsilon_b * d_x * d_y / ( 2 * d_z(p) ); % ell + 1
        A_row(9)  = epsilon(p) * d_y * d_z(p) / (4 * d_x) + epsilon(p) * d_y * d_z(p) / (4 * d_x) + epsilon_b * d_y * ( d_z(p) + d_z(p) ) / (4 * d_x); % m - 1
        A_row(10) = A_row( 8 ); % ell - 1
        A_row(11) = epsilon_b * d_y * d_z(p) / d_x; % m + 1
        A_row(12) = epsilon_b * d_x * ( d_z(p) + d_z(p) ) / (2 * d_y); % n + 1
        A_row(13) = epsilon(p) * d_x * d_z(p) / (2 * d_y) + epsilon_b * d_x * d_z(p) / (2 * d_y);  % n - 1
        A_row(14) = - ( A_row( 8 ) + A_row( 9 ) + A_row( 10 ) + A_row( 11 ) + A_row( 12 ) + A_row( 13 ) ); % center point
    case 2
        A_row(1)  = p1;
        A_row(2)  = p2;
        A_row(3)  = p3;
        A_row(4)  = p4;
        A_row(5)  = p5;
        A_row(6)  = p6;
        A_row(7)  = p0;
        A_row(8)  = ( epsilon(p) + epsilon_b ) * d_x * d_y / ( 4 * d_z(p) ) + epsilon_b * d_x * d_y / ( 2 * d_z(p) ); % ell + 1
        A_row(9)  = epsilon(p) * d_y * d_z(p) / (4 * d_x) + epsilon(p) * d_y * d_z(p) / (4 * d_x) + epsilon_b * d_y * ( d_z(p) + d_z(p) ) / (4 * d_x); % m - 1
        A_row(10) = A_row( 8 ); % ell - 1
        A_row(11) = epsilon_b * d_y * ( d_z(p) + d_z(p) ) / (2 * d_x); % m + 1
        A_row(12) = epsilon(p) * d_x * d_z(p) / (2 * d_y) + epsilon_b * d_x * d_z(p) / (2 * d_y);  % n + 1
        A_row(13) = epsilon_b * d_x * d_z(p) / d_y; % n - 1
        A_row(14) = - ( A_row( 8 ) + A_row( 9 ) + A_row( 10 ) + A_row( 11 ) + A_row( 12 ) + A_row( 13 ) ); % center point
    case 3
        A_row(1)  = p1;
        A_row(2)  = p2;
        A_row(3)  = p3;
        A_row(4)  = p4;
        A_row(5)  = p5;
        A_row(6)  = p6;
        A_row(7)  = p0;
        A_row(8)  = ( epsilon(p) + epsilon_b ) * d_x * d_y / ( 4 * d_z(p) ) + epsilon_b * d_x * d_y / ( 2 * d_z(p) ); % ell + 1
        A_row(9)  = epsilon_b * d_y * d_z(p) / d_x; % m - 1
        A_row(10) = A_row( 8 ); % ell - 1
        A_row(11) = epsilon(p) * d_y * d_z(p) / (2 * d_x) + epsilon_b * d_y * d_z(p) / (2 * d_x); % m + 1
        A_row(12) = epsilon_b * d_x * d_z(p) / d_y; % n + 1
        A_row(13) = epsilon(p) * d_x * d_z(p) / (2 * d_y) + epsilon_b * d_x * d_z (p) / (2 * d_y);  % n - 1
        A_row(14) = - ( A_row( 8 ) + A_row( 9 ) + A_row( 10 ) + A_row( 11 ) + A_row( 12 ) + A_row( 13 ) ); % center point
    case 4
        A_row(1)  = p1;
        A_row(2)  = p2;
        A_row(3)  = p3;
        A_row(4)  = p4;
        A_row(5)  = p5;
        A_row(6)  = p6;
        A_row(7)  = p0;
        A_row(8)  = ( epsilon(p) + epsilon_b ) * d_x * d_y / ( 4 * d_z(p) ) + epsilon_b * d_x * d_y / ( 2 * d_z(p) ); % ell + 1
        A_row(9)  = epsilon_b * d_y * d_z (p) / d_x; % m + 1
        A_row(10) = A_row( 8 ); % ell - 1
        A_row(11) = epsilon(p) * d_y * d_z(p) / (2 * d_x) + epsilon_b * d_y * d_z(p) / (2 * d_x); % m - 1
        A_row(12) = epsilon(p) * d_x * d_z(p) / (2 * d_y) + epsilon_b * d_x * d_z (p) / (2 * d_y);  % n + 1
        A_row(13) = epsilon_b * d_x * d_z(p) / d_y; % n - 1
        A_row(14) = - ( A_row( 8 ) + A_row( 9 ) + A_row( 10 ) + A_row( 11 ) + A_row( 12 ) + A_row( 13 ) ); % center point
    otherwise
        warning('wrong');
end

end