function [ A_row ] = top_down_air_A( face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon, epsilon_b, Epsilon_0 )
    
    A_row = zeros( 1, M_x_max * M_y_max * N_max );
    
switch face_idx
    case 1 % top air
        A_row( p0 ) = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 + (1 / d_z(p))^2 ); % center point
        A_row( p4 ) = ( 1 / d_x )^2; % m + 1
        A_row( p2 ) = ( 1 / d_x )^2; % m - 1
        A_row( p5 ) = ( 1 / d_y )^2; % n + 1
        A_row( p6 ) = ( 1 / d_y )^2; % n - 1
        % A_row( p1 ) = ( 1 / d_z(p) )^2; % ell + 1
        A_row( p3 ) = ( 2 / d_z(p) )^2; % ell - 1
    case 2 % bottom air
        A_row( p0 ) = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 + (1 / d_z(p))^2 ); % center point
        A_row( p4 ) = ( 1 / d_x )^2; % m + 1
        A_row( p2 ) = ( 1 / d_x )^2; % m - 1
        A_row( p5 ) = ( 1 / d_y )^2; % n + 1
        A_row( p6 ) = ( 1 / d_y )^2; % n - 1
        A_row( p1 ) = ( 2 / d_z(p) )^2; % ell + 1
        % A_row( p3 ) = ( 1 / d_z(p) )^2; % ell - 1
    otherwise
        disp('wrong in top down air');
end

end