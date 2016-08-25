function [ valid ] = check_air_vertical_face_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )

valid = false;

if ~ ( ( p >= 1 ) & ( p <= 9 ) )
    disp('The p are not valid in air vertical face region.')
end

if ( ell >= 2 ) & ( ell <= N_p(p) )
    if ( m == M_x + 1 ) & ( n >= 2 ) & ( n <= M_y ) 
        valid = 1; % right
    elseif ( m == 1 ) & ( n >= 2 ) & ( n <= M_y ) 
        valid = 2; % left
    elseif ( n == M_y + 1 ) & ( m >= 2 ) & ( m <= M_x ) 
        valid = 3; % forward
    elseif ( n == 1 ) & ( m >= 2 ) & ( m <= M_x ) 
        valid = 4; % backward
    end
end

end