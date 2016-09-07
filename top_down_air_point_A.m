function [ A_row ] = top_down_air_point_A( point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon, epsilon_b, Epsilon_0 )
    
    % A_row = zeros( 1, M_x_max * M_y_max * N_max );
    A_row = zeros(1, 8);

switch point_idx
    case 1
        A_row(1)  = p0;
        A_row(2)  = p2;
        A_row(3)  = p6;
        A_row(4)  = p3;
        A_row(5)  = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 + (1 / d_z(p))^2 ); % center point
        A_row(6)  = ( 2 / d_x )^2; % m - 1
        A_row(7)  = ( 2 / d_y )^2; % n - 1
        A_row(8)  = ( 2 / d_z(p) )^2; % ell - 1
    case 2
        A_row(1)  = p0;
        A_row(2)  = p2;
        A_row(3)  = p5;
        A_row(4)  = p3;
        A_row(5)  = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 + (1 / d_z(p))^2 ); % center point
        A_row(6)  = ( 2 / d_x )^2; % m - 1
        A_row(7)  = ( 2 / d_y )^2; % n + 1
        A_row(8)  = ( 2 / d_z(p) )^2; % ell - 1
    case 3
        A_row(1)  = p0;
        A_row(2)  = p4;
        A_row(3)  = p6;
        A_row(4)  = p3;
        A_row(5)  = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 + (1 / d_z(p))^2 ); % center point
        A_row(6)  = ( 2 / d_x )^2; % m + 1
        A_row(7)  = ( 2 / d_y )^2; % n - 1
        A_row(8)  = ( 2 / d_z(p) )^2; % ell - 1
    case 4
        A_row(1)  = p0;
        A_row(2)  = p4;
        A_row(3)  = p5;
        A_row(4)  = p3;
        A_row(5)  = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 + (1 / d_z(p))^2 ); % center point
        A_row(6)  = ( 2 / d_x )^2; % m + 1
        A_row(7)  = ( 2 / d_y )^2; % n + 1
        A_row(8)  = ( 2 / d_z(p) )^2; % ell - 1
    case 5
        A_row(1)  = p0;
        A_row(2)  = p1;
        A_row(3)  = p2;
        A_row(4)  = p6;
        A_row(5)  = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 + (1 / d_z(p))^2 ); % center point
        A_row(6)  = ( 2 / d_z(p) )^2; % ell + 1
        A_row(7)  = ( 2 / d_x )^2; % m - 1
        A_row(8)  = ( 2 / d_y )^2; % n - 1
    case 6
        A_row(1)  = p0;
        A_row(2)  = p1;
        A_row(3)  = p2;
        A_row(4)  = p5;
        A_row(5)  = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 + (1 / d_z(p))^2 ); % center point
        A_row(6)  = ( 2 / d_z(p) )^2; % ell + 1
        A_row(7)  = ( 2 / d_x )^2; % m - 1
        A_row(8)  = ( 2 / d_y )^2; % n - 1
    case 7
        A_row(1)  = p0;
        A_row(2)  = p1;
        A_row(3)  = p4;
        A_row(4)  = p6;
        A_row(5)  = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 + (1 / d_z(p))^2 ); % center point
        A_row(6)  = ( 2 / d_z(p) )^2; % ell + 1
        A_row(7)  = ( 2 / d_x )^2; % m - 1
        A_row(8)  = ( 2 / d_y )^2; % n - 1
    case 8
        A_row(1)  = p0;
        A_row(2)  = p1;
        A_row(3)  = p4;
        A_row(4)  = p5;
        A_row(5)  = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 + (1 / d_z(p))^2 ); % center point
        A_row(6)  = ( 2 / d_z(p) )^2; % ell + 1
        A_row(7)  = ( 2 / d_x )^2; % m - 1
        A_row(8)  = ( 2 / d_y )^2; % n - 1
    otherwise
        warning('wrong');
end

end