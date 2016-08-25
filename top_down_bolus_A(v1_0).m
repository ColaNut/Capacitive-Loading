function [ A_row ] = top_down_bolus_idx_A( face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon, epsilon_b, Epsilon_0 )
    
    A_row = zeros( 1, M_x_max * M_y_max * N_max );
    
switch face_idx
    case 1 % top bolus
        % A_row( p1 ) = 0; % ell + 1
        A_row( p2 ) = Epsilon_0 * d_y * d_z(p) / (2 * d_x) + epsilon(p) * d_y * d_z(p) / (2 * d_x); % m - 1
        A_row( p3 ) = 0; % ell - 1
        A_row( p4 ) = A_row( p2 ); % m + 1
        A_row( p5 ) = Epsilon_0 * d_x * d_z(p) / (2 * d_y) + epsilon(p) * d_x * d_z(p) / (2 * d_y);  % n + 1
        A_row( p6 ) = A_row( p5 ); % n - 1
        A_row( p0 ) = - ( A_row( p2 ) + A_row( p3 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center point
    case 2 % bottom bolus
        A_row( p1 ) = 0; % ell + 1
        A_row( p2 ) = epsilon(p) * d_y * d_z(p) / (2 * d_x) + Epsilon_0 * d_y * d_z(p) / (2 * d_x); % m - 1
        % A_row( p3 ) = 0; % ell - 1
        A_row( p4 ) = A_row( p2 ); % m + 1
        A_row( p5 ) = epsilon(p) * d_x * d_z(p) / (2 * d_y) + Epsilon_0 * d_x * d_z(p) / (2 * d_y);  % n + 1
        A_row( p6 ) = A_row( p5 ); % n - 1
        A_row( p0 ) = - ( A_row( p1 ) + A_row( p2 ) + A_row( p4 ) + A_row( p5 ) + A_row( p6 ) ); % center point
    otherwise
        disp('wrong')
end

end