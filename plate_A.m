function [ A_row ] = plate_A( plate_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon, epsilon_b, Epsilon_0 )
    
A_row = zeros( 1, M_x_max * M_y_max * N_max );
    
switch plate_idx
    case 1
        A_row( p0 ) = 1; % center point
    case 2
        A_row( p0 ) = 1; % center point
    otherwise
        disp('wrong')
end

end