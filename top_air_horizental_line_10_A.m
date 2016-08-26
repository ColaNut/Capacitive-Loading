function [ A_row ] = top_air_horizental_line_10_A( line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon, epsilon_b, Epsilon_0 )
    
    A_row = zeros( 1, M_x_max * M_y_max * ( N_max + N_10 ) );
    
switch line_idx
    case 1
        A_row( p0 ) = ( -2 ) * ( (1 / d_y)^2 ); % center point
        % A_row( p4 ) = ( 1 / d_x )^2; % m + 1
        % A_row( p2 ) = ( 2 / d_x )^2; % m - 1
        A_row( p5 ) = ( 1 / d_y )^2; % n + 1
        A_row( p6 ) = ( 1 / d_y )^2; % n - 1
    case 2
        A_row( p0 ) = ( -2 ) * ( (1 / d_y)^2 ); % center point
        % A_row( p4 ) = ( 2 / d_x )^2; % m + 1
        % A_row( p2 ) = ( 1 / d_x )^2; % m - 1
        A_row( p5 ) = ( 1 / d_y )^2; % n + 1
        A_row( p6 ) = ( 1 / d_y )^2; % n - 1
    case 3
        A_row( p0 ) = ( -2 ) * ( (1 / d_x)^2 ); % center point
        A_row( p4 ) = ( 1 / d_x )^2; % m + 1
        A_row( p2 ) = ( 1 / d_x )^2; % m - 1
        % A_row( p5 ) = ( 1 / d_y )^2; % n + 1
        % A_row( p6 ) = ( 2 / d_y )^2; % n - 1
    case 4
        A_row( p0 ) = ( -2 ) * ( (1 / d_x)^2 ); % center point
        A_row( p4 ) = ( 1 / d_x )^2; % m + 1
        A_row( p2 ) = ( 1 / d_x )^2; % m - 1
        % A_row( p5 ) = ( 2 / d_y )^2; % n + 1
        % A_row( p6 ) = ( 1 / d_y )^2; % n - 1
    otherwise
        disp('wrong')
end

end