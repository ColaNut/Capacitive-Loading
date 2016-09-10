function [ A_row ] = top_air_point_10_A( point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon, epsilon_b, Epsilon_0 )
    
A_row = zeros( 1, M_x_max * M_y_max * ( N_max + N_10 ) );
    
switch point_idx
    case 1
        % A_row( p4 ) = ( 1 / d_x )^2; % m + 1
        A_row( p2 ) = ( 1 / d_x )^2; % m - 1
        A_row( p3 ) = ( 1 / d_z_10 )^2; % ell - 1
        % A_row( p5 ) = ( 1 / d_y )^2; % n + 1
        A_row( p6 ) = ( 1 / d_y )^2; % n - 1
        A_row( p0 ) = - ( A_row( p2 ) + A_row( p3 ) + A_row( p6 ) ); % center point
    case 2
        % A_row( p4 ) = ( 1 / d_x )^2; % m + 1
        A_row( p2 ) = ( 1 / d_x )^2; % m - 1
        A_row( p3 ) = ( 1 / d_z_10 )^2; % ell - 1
        A_row( p5 ) = ( 1 / d_y )^2; % n + 1
        % A_row( p6 ) = ( 1 / d_y )^2; % n - 1
        A_row( p0 ) = - ( A_row( p2 ) + A_row( p3 ) + A_row( p5 ) ); % center point
    case 3
        A_row( p3 ) = ( 1 / d_z_10 )^2; % ell - 1
        A_row( p4 ) = ( 1 / d_x )^2; % m + 1
        % A_row( p2 ) = ( 1 / d_x )^2; % m - 1
        % A_row( p5 ) = ( 1 / d_y )^2; % n + 1
        A_row( p6 ) = ( 1 / d_y )^2; % n - 1
        A_row( p0 ) = - ( A_row( p3 ) + A_row( p4 ) + A_row( p6 ) ); % center point
    case 4
        A_row( p3 ) = ( 1 / d_z_10 )^2; % ell - 1
        A_row( p4 ) = ( 1 / d_x )^2; % m + 1
        % A_row( p2 ) = ( 1 / d_x )^2; % m - 1
        A_row( p5 ) = ( 1 / d_y )^2; % n + 1
        % A_row( p6 ) = ( 1 / d_y )^2; % n - 1
        A_row( p0 ) = - ( A_row( p3 ) + A_row( p4 ) + A_row( p5 ) ); % center point
    otherwise
        error('wrong in top air point 10');
end

end