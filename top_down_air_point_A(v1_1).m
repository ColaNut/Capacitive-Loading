function [ A_row ] = top_down_air_point_A( point_idx, p, p0, p1, p2, p3, p4, p5, p6, p1_up, p3_down, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon, epsilon_b, Epsilon_0 )
    
A_row = zeros( 1, M_x_max * M_y_max * N_max );
    
switch point_idx
    case 1
        % A_row( p4 ) = ( 1 / d_x )^2; % m + 1
        A_row( p2 ) = ( 2 / d_x )^2; % m - 1
        % A_row( p5 ) = ( 1 / d_y )^2; % n + 1
        A_row( p6 ) = ( 2 / d_y )^2; % n - 1
        % A_row( p1 ) = ( 1 / d_z(p) )^2; % ell + 1
        A_row( p3 ) = - ( 2 / d_z(p) )^2; % ell - 1
        A_row( p3_down ) = ( 1 / d_z(p) )^2; % ell - 1
        A_row( p0 ) = A_row( p3_down ) + ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 ); % center point
    case 2
        % A_row( p4 ) = ( 1 / d_x )^2; % m + 1
        A_row( p2 ) = ( 2 / d_x )^2; % m - 1
        A_row( p5 ) = ( 2 / d_y )^2; % n + 1
        % A_row( p6 ) = ( 1 / d_y )^2; % n - 1
        % A_row( p1 ) = ( 1 / d_z(p) )^2; % ell + 1
        A_row( p3 ) = - ( 2 / d_z(p) )^2; % ell - 1
        A_row( p3_down ) = ( 1 / d_z(p) )^2; % ell - 1
        A_row( p0 ) = A_row( p3_down ) + ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 ); % center point
    case 3
        A_row( p4 ) = ( 2 / d_x )^2; % m + 1
        % A_row( p2 ) = ( 1 / d_x )^2; % m - 1
        % A_row( p5 ) = ( 1 / d_y )^2; % n + 1
        A_row( p6 ) = ( 2 / d_y )^2; % n - 1
        % A_row( p1 ) = ( 1 / d_z(p) )^2; % ell + 1
        A_row( p3 ) = - ( 2 / d_z(p) )^2; % ell - 1
        A_row( p3_down ) = ( 1 / d_z(p) )^2; % ell - 1
        A_row( p0 ) = A_row( p3_down ) + ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 ); % center point
    case 4
        A_row( p4 ) = ( 2 / d_x )^2; % m + 1
        % A_row( p2 ) = ( 1 / d_x )^2; % m - 1
        A_row( p5 ) = ( 2 / d_y )^2; % n + 1
        % A_row( p6 ) = ( 1 / d_y )^2; % n - 1
        % A_row( p1 ) = ( 1 / d_z(p) )^2; % ell + 1
        A_row( p3 ) = - ( 2 / d_z(p) )^2; % ell - 1
        A_row( p3_down ) = ( 1 / d_z(p) )^2; % ell - 1
        A_row( p0 ) = A_row( p3_down ) + ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 ); % center point
    case 5
        % A_row( p4 ) = ( 1 / d_x )^2; % m + 1
        A_row( p2 ) = ( 2 / d_x )^2; % m - 1
        % A_row( p5 ) = ( 1 / d_y )^2; % n + 1
        A_row( p6 ) = ( 2 / d_y )^2; % n - 1
        A_row( p1 ) = - ( 2 / d_z(p) )^2;; % ell + 1
        % A_row( p3 ) = ( 1 / d_z(p) )^2; % ell - 1
        A_row( p1_up ) = ( 1 / d_z(p) )^2; % ell - 1
        A_row( p0 ) = A_row( p1_up ) + ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 ); % center point
    case 6
        % A_row( p4 ) = ( 1 / d_x )^2; % m + 1
        A_row( p2 ) = ( 2 / d_x )^2; % m - 1
        A_row( p5 ) = ( 2 / d_y )^2; % n + 1
        % A_row( p6 ) = ( 1 / d_y )^2; % n - 1
        A_row( p1 ) = - ( 2 / d_z(p) )^2;; % ell + 1
        % A_row( p3 ) = ( 1 / d_z(p) )^2; % ell - 1
        A_row( p1_up ) = ( 1 / d_z(p) )^2; % ell - 1
        A_row( p0 ) = A_row( p1_up ) + ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 ); % center point
    case 7
        A_row( p4 ) = ( 2 / d_x )^2; % m + 1
        % A_row( p2 ) = ( 1 / d_x )^2; % m - 1
        % A_row( p5 ) = ( 1 / d_y )^2; % n + 1
        A_row( p6 ) = ( 2 / d_y )^2; % n - 1
        A_row( p1 ) = - ( 2 / d_z(p) )^2;; % ell + 1
        % A_row( p3 ) = ( 1 / d_z(p) )^2; % ell - 1
        A_row( p1_up ) = ( 1 / d_z(p) )^2; % ell - 1
        A_row( p0 ) = A_row( p1_up ) + ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 ); % center point
    case 8
        A_row( p4 ) = ( 2 / d_x )^2; % m + 1
        % A_row( p2 ) = ( 1 / d_x )^2; % m - 1
        A_row( p5 ) = ( 2 / d_y )^2; % n + 1
        % A_row( p6 ) = ( 1 / d_y )^2; % n - 1
        A_row( p1 ) = - ( 2 / d_z(p) )^2;; % ell + 1
        % A_row( p3 ) = ( 1 / d_z(p) )^2; % ell - 1
        A_row( p1_up ) = ( 1 / d_z(p) )^2; % ell - 1
        A_row( p0 ) = A_row( p1_up ) + ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 ); % center point
    otherwise
        disp('wrong in top down bolus point');
        p0
end

end