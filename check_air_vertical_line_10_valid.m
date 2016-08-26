function [ valid ] = check_air_vertical_line_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )

valid = false;

if ( p == 10 )
    if ( ell >= 2 ) & ( ell <= N_10 ) 
        if ( m == M_x + 1 ) & ( n == M_y + 1 ) 
            valid = 1; % x+y+
        elseif ( m == M_x + 1 ) & ( n == 1 ) 
            valid = 2; % x+y-
        elseif ( m == 1 ) & ( n == M_y + 1 ) 
            valid = 3; % x-y+
        elseif ( m == 1 ) & ( n == 1 ) 
            valid = 4; % x-y-
        end
    end
end

end