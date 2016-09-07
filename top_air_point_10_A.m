function [ A_row ] = top_air_point_10_A( point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon, epsilon_b, Epsilon_0 )
    
% A_row = zeros( 1, M_x_max * M_y_max * ( N_max + N_10 ) );
    A_row = zeros(1, 8);

switch point_idx
    case 1
        A_row(1)  = p0;
        A_row(2)  = p2;
        A_row(3)  = p3;
        A_row(4)  = p6;
        A_row(5)  = 1; % center point
        A_row(6)  = - 1 / 3; % m - 1
        A_row(7)  = - 1 / 3; % ell - 1
        A_row(8)  = - 1 / 3; % n - 1
    case 2
        A_row(1)  = p0;
        A_row(2)  = p2;
        A_row(3)  = p3;
        A_row(4)  = p5;
        A_row(5)  = 1; % center point
        A_row(6)  = - 1 / 3; % m - 1
        A_row(7)  = - 1 / 3; % ell - 1
        A_row(8)  = - 1 / 3; % n + 1
    case 3
        A_row(1)  = p0;
        A_row(2)  = p3;
        A_row(3)  = p4;
        A_row(4)  = p6;
        A_row(5)  = 1; % center point
        A_row(6)  = - 1 / 3; % ell - 1
        A_row(7)  = - 1 / 3; % m + 1
        A_row(8)  = - 1 / 3; % n - 1
    case 4
        A_row(1)  = p0;
        A_row(2)  = p3;
        A_row(3)  = p4;
        A_row(4)  = p5;
        A_row(5)  = 1; % center point
        A_row(6)  = - 1 / 3; % ell - 1
        A_row(7)  = - 1 / 3; % m + 1
        A_row(8)  = - 1 / 3; % n + 1
    otherwise
        warning('wrong');
end

end