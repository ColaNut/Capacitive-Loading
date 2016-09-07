function [ A_row ] = air_point_A( point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon, epsilon_b, Epsilon_0 )
    
    % A_row = zeros( 1, M_x_max * M_y_max * N_max );
    A_row = zeros(1, 6);

switch point_idx
    case 1
        A_row(1)  = p0;
        A_row(2)  = p1;
        A_row(3)  = p3;
        A_row(4)  = ( -2 ) * ( 1 / ( d_z(p) * d_z(p + 1) ) ); % center point
        A_row(5)  = 1 / ( d_z(p + 1) * ( d_z(p) + d_z(p + 1) ) / 2 ); % ell + 1
        A_row(6)  = 1 / ( d_z(p) * ( d_z(p) + d_z(p + 1) ) / 2 ); % ell - 1
    case 2
        A_row(1)  = p0;
        A_row(2)  = p1;
        A_row(3)  = p3;
        A_row(4)  = ( -2 ) * ( 1 / ( d_z(p) * d_z(p + 1) ) ); % center point
        A_row(5)  = 1 / ( d_z(p + 1) * ( d_z(p) + d_z(p + 1) ) / 2 ); % ell + 1
        A_row(6)  = 1 / ( d_z(p) * ( d_z(p) + d_z(p + 1) ) / 2 ); % ell - 1
    case 3
        A_row(1)  = p0;
        A_row(2)  = p1;
        A_row(3)  = p3;
        A_row(4)  = ( -2 ) * ( 1 / ( d_z(p) * d_z(p + 1) ) ); % center point
        A_row(5)  = 1 / ( d_z(p + 1) * ( d_z(p) + d_z(p + 1) ) / 2 ); % ell + 1
        A_row(6)  = 1 / ( d_z(p) * ( d_z(p) + d_z(p + 1) ) / 2 ); % ell - 1
    case 4
        A_row(1)  = p0;
        A_row(2)  = p1;
        A_row(3)  = p3;
        A_row(4)  = ( -2 ) * ( 1 / ( d_z(p) * d_z(p + 1) ) ); % center point
        A_row(5)  = 1 / ( d_z(p + 1) * ( d_z(p) + d_z(p + 1) ) / 2 ); % ell + 1
        A_row(6)  = 1 / ( d_z(p) * ( d_z(p) + d_z(p + 1) ) / 2 ); % ell - 1
    otherwise
        warning('wrong');
end

end