function [ A_row ] = plate_10_A( plate_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, epsilon, epsilon_b, Epsilon_0 )

A_row = zeros(1, 2);
% A_row = zeros( 1, M_x_max * M_y_max * ( N_max + N_10 ) );

if plate_idx
    A_row(1)  = p0;
    A_row(2)  = 1; % center point
else
    warning('wrong');
end

end