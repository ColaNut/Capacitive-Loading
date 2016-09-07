function [ A_row ] = top_down_bolus_point_A( point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon, epsilon_b, Epsilon_0 )
    
    % A_row = zeros( 1, M_x_max * M_y_max * N_max );
    A_row = zeros(1, 12);

switch point_idx
    case 1
        A_row(1)  = p2;
        A_row(2)  = p3;
        A_row(3)  = p4;
        A_row(4)  = p5;
        A_row(5)  = p6;
        A_row(6)  = p0;
        A_row(7)  = Epsilon_0 * d_y * d_z(p) / (4 * d_x) + epsilon_b * d_y * d_z(p) / (4 * d_x) + Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (4 * d_x); % m - 1
        A_row(8)  = 2 * 3 * Epsilon_0 * d_x * d_y / (4 * d_z(p)); % ell - 1
        A_row(9)  = Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (2 * d_x); % m + 1
        A_row(10) = Epsilon_0 * d_x * ( d_z(p) + d_z(p) ) / (2 * d_y); % n + 1
        A_row(11) = Epsilon_0 * d_x * d_z(p) / (4 * d_y) + epsilon_b * d_x * d_z(p) / (4 * d_y) + Epsilon_0 * d_x * ( d_z (p) + d_z(p) ) / (4 * d_y); % n - 1
        A_row(12) = - ( A_row( 7 ) + A_row( 8 ) + A_row( 9 ) + A_row( 10 ) + A_row( 11 ) ); % center point
    case 2
        A_row(1)  = p2;
        A_row(2)  = p3;
        A_row(3)  = p4;
        A_row(4)  = p5;
        A_row(5)  = p6;
        A_row(6)  = p0;
        A_row(7)  = Epsilon_0 * d_y * d_z(p) / (4 * d_x) + epsilon_b * d_y * d_z(p) / (4 * d_x) + Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (4 * d_x); % m - 1
        A_row(8)  = 2 * 3 * Epsilon_0 * d_x * d_y / (4 * d_z(p)); % ell - 1
        A_row(9)  = Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (2 * d_x); % m + 1
        A_row(10) = Epsilon_0 * d_x * d_z(p) / (4 * d_y) + epsilon_b * d_x * d_z(p) / (4 * d_y) + Epsilon_0 * d_x * ( d_z (p) + d_z(p) ) / (4 * d_y);  % n + 1
        A_row(11) = Epsilon_0 * d_x * ( d_z(p) + d_z(p) ) / (2 * d_y); % n - 1
        A_row(12) = - ( A_row( 7 ) + A_row( 8 ) + A_row( 9 ) + A_row( 10 ) + A_row( 11 ) ); % center point
    case 3
        A_row(1)  = p2;
        A_row(2)  = p3;
        A_row(3)  = p4;
        A_row(4)  = p5;
        A_row(5)  = p6;
        A_row(6)  = p0;
        A_row(7)  = Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (2 * d_x); % m - 1
        A_row(8)  = 2 * 3 * Epsilon_0 * d_x * d_y / (4 * d_z(p)); % ell - 1
        A_row(9)  = Epsilon_0 * d_y * d_z(p) / (4 * d_x) + epsilon_b * d_y * d_z(p) / (4 * d_x) + Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (4 * d_x); % m + 1
        A_row(10) = Epsilon_0 * d_x * ( d_z(p) + d_z(p) ) / (2 * d_y); % n + 1
        A_row(11) = Epsilon_0 * d_x * d_z(p) / (4 * d_y) + epsilon_b * d_x * d_z(p) / (4 * d_y) + Epsilon_0 * d_x * ( d_z (p) + d_z(p) ) / (4 * d_y);  % n - 1
        A_row(12) = - ( A_row( 7 ) + A_row( 8 ) + A_row( 9 ) + A_row( 10 ) + A_row( 11 ) ); % center point
    case 4
        A_row(1)  = p2;
        A_row(2)  = p3;
        A_row(3)  = p4;
        A_row(4)  = p5;
        A_row(5)  = p6;
        A_row(6)  = p0;
        A_row(7)  = Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (2 * d_x); % m - 1
        A_row(8)  = 2 * 3 * Epsilon_0 * d_x * d_y / (4 * d_z(p)); % ell - 1
        A_row(9)  = Epsilon_0 * d_y * d_z(p) / (4 * d_x) + epsilon_b * d_y * d_z(p) / (4 * d_x) + Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (4 * d_x); % m + 1
        A_row(10) = Epsilon_0 * d_x * d_z(p) / (4 * d_y) + epsilon_b * d_x * d_z(p) / (4 * d_y) + Epsilon_0 * d_x * ( d_z (p) + d_z(p) ) / (4 * d_y); % n + 1
        A_row(11) = Epsilon_0 * d_x * ( d_z(p) + d_z(p) ) / (2 * d_y); % n - 1
        A_row(12) = - ( A_row( 7 ) + A_row( 8 ) + A_row( 9 ) + A_row( 10 ) + A_row( 11 ) ); % center point
    case 5
        A_row(1)  = p1;
        A_row(2)  = p2;
        A_row(3)  = p4;
        A_row(4)  = p5;
        A_row(5)  = p6;
        A_row(6)  = p0;
        A_row(7)  = 2 * 3 * Epsilon_0 * d_x * d_y / (4 * d_z(p)); % ell + 1
        A_row(8)  = Epsilon_0 * d_y * d_z(p) / (4 * d_x) + epsilon_b * d_y * d_z(p) / (4 * d_x) + Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (4 * d_x); % m - 1
        A_row(9)  = Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (2 * d_x); % m + 1
        A_row(10) = Epsilon_0 * d_x * ( d_z(p) + d_z(p) ) / (2 * d_y); % n + 1
        A_row(11) = Epsilon_0 * d_x * d_z(p) / (4 * d_y) + epsilon_b * d_x * d_z(p) / (4 * d_y) + Epsilon_0 * d_x * ( d_z (p) + d_z(p) ) / (4 * d_y);  % n - 1
        A_row(12) = - ( A_row( 7 ) + A_row( 8 ) + A_row( 9 ) + A_row( 10 ) + A_row( 11 ) ); % center point
    case 6
        A_row(1)  = p1;
        A_row(2)  = p2;
        A_row(3)  = p4;
        A_row(4)  = p5;
        A_row(5)  = p6;
        A_row(6)  = p0;
        A_row(7)  = 2 * 3 * Epsilon_0 * d_x * d_y / (4 * d_z(p)); % ell + 1
        A_row(8)  = Epsilon_0 * d_y * d_z(p) / (4 * d_x) + epsilon_b * d_y * d_z(p) / (4 * d_x) + Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (4 * d_x); % m - 1
        A_row(9)  = Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (2 * d_x); % m + 1
        A_row(10) = Epsilon_0 * d_x * d_z(p) / (4 * d_y) + epsilon_b * d_x * d_z(p) / (4 * d_y) + Epsilon_0 * d_x * ( d_z (p) + d_z(p) ) / (4 * d_y);  % n + 1
        A_row(11) = Epsilon_0 * d_x * ( d_z(p) + d_z(p) ) / (2 * d_y); % n - 1
        A_row(12) = - ( A_row( 7 ) + A_row( 8 ) + A_row( 9 ) + A_row( 10 ) + A_row( 11 ) ); % center point
    case 7
        A_row(1)  = p1;
        A_row(2)  = p2;
        A_row(3)  = p4;
        A_row(4)  = p5;
        A_row(5)  = p6;
        A_row(6)  = p0;
        A_row(7)  = 2 * 3 * Epsilon_0 * d_x * d_y / (4 * d_z(p)); % ell + 1
        A_row(8)  = Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (2 * d_x); % m - 1
        A_row(9)  = Epsilon_0 * d_y * d_z(p) / (4 * d_x) + epsilon_b * d_y * d_z(p) / (4 * d_x) + Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (4 * d_x); % m + 1
        A_row(10) = Epsilon_0 * d_x * ( d_z(p) + d_z(p) ) / (2 * d_y); % n + 1
        A_row(11) = Epsilon_0 * d_x * d_z(p) / (4 * d_y) + epsilon_b * d_x * d_z(p) / (4 * d_y) + Epsilon_0 * d_x * ( d_z (p) + d_z(p) ) / (4 * d_y);  % n - 1
        A_row(12) = - ( A_row( 7 ) + A_row( 8 ) + A_row( 9 ) + A_row( 10 ) + A_row( 11 ) ); % center point
    case 8
        A_row(1)  = p1;
        A_row(2)  = p2;
        A_row(3)  = p4;
        A_row(4)  = p5;
        A_row(5)  = p6;
        A_row(6)  = p0;
        A_row(7)  = 2 * 3 * Epsilon_0 * d_x * d_y / (4 * d_z(p)); % ell + 1
        A_row(8)  = Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (2 * d_x); % m - 1
        A_row(9)  = Epsilon_0 * d_y * d_z(p) / (4 * d_x) + epsilon_b * d_y * d_z(p) / (4 * d_x) + Epsilon_0 * d_y * ( d_z(p) + d_z(p) ) / (4 * d_x); % m + 1
        A_row(10) = Epsilon_0 * d_x * d_z(p) / (4 * d_y) + epsilon_b * d_x * d_z(p) / (4 * d_y) + Epsilon_0 * d_x * ( d_z (p) + d_z(p) ) / (4 * d_y); % n + 1
        A_row(11) = Epsilon_0 * d_x * ( d_z(p) + d_z(p) ) / (2 * d_y); % n - 1
        A_row(12) = - ( A_row( 7 ) + A_row( 8 ) + A_row( 9 ) + A_row( 10 ) + A_row( 11 ) ); % center point
    otherwise
        warning('wrong');
end

end