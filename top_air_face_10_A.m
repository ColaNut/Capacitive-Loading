function [ A_row ] = top_air_face_10_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon, epsilon_b, Epsilon_0 )
    
    % A_row = zeros( 1, M_x_max * M_y_max * ( N_max + N_10 ) );
    A_row = zeros(1, 10);

    A_row(1)  = p0;
    A_row(2)  = p4;
    A_row(3)  = p2;
    A_row(4)  = p5;
    A_row(5)  = p6;
    A_row(6)  = ( -2 ) * ( (1 / d_x)^2 + (1 / d_y)^2 ); % center point
    A_row(7)  = ( 1 / d_x )^2; % m + 1
    A_row(8)  = ( 1 / d_x )^2; % m - 1
    A_row(9)  = ( 1 / d_y )^2; % n + 1
    A_row(10) = ( 1 / d_y )^2; % n - 1

end