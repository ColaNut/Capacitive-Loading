function [ valid ] = check_top_down_bolus_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )

valid = false;

if ( p == 9 ) & ( ell == N_p(p) + 1 )
    if ( m == M_x - M_x5 + 1 ) & ( n == M_y - M_y5 + 1 ) 
        valid = 1; % x+y+
    elseif ( m == M_x - M_x5 + 1 ) & ( n == M_y1 + 1 ) 
        valid = 2; % x+y-
    elseif ( m == M_x1 + 1 ) & ( n == M_y - M_y5 + 1 ) 
        valid = 3; % x-y+
    elseif ( m == M_x1 + 1 ) & ( n == M_y1 + 1 ) 
        valid = 4; % x-y-
    end
end

if ( p == 1 ) & ( ell == 1 )
    if ( m == M_x - M_x5 + 1 ) & ( n == M_y - M_y5 + 1 ) 
        valid = 5; % x+y+
    elseif ( m == M_x - M_x5 + 1 ) & ( n == M_y1 + 1 ) 
        valid = 6; % x+y-
    elseif ( m == M_x1 + 1 ) & ( n == M_y - M_y5 + 1 ) 
        valid = 7; % x-y+
    elseif ( m == M_x1 + 1 ) & ( n == M_y1 + 1 ) 
        valid = 8; % x-y-
    end
end

end