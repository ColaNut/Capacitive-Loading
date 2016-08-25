function [ valid ] = check_CD_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )

valid = false;

if ( ell >= 2 ) & ( ell <= N_p(p) ) & ( p >= 2 ) & ( p <= 8 )
    if ( m == M_x - M_x5 - M_x4 + 1 ) & ( n ==  M_y - M_y5 - M_y4 + 1 ) 
        valid = 1; % x+y+
    elseif ( m == M_x - M_x5 - M_x4 + 1 ) & ( n ==  M_y1 + M_y2 + 1 ) 
        valid = 2; % x+y-
    elseif ( m == M_x1 + M_x2 + 1 ) & ( n ==  M_y - M_y5 - M_y4 + 1 ) 
        valid = 3; % x-y+
    elseif ( m == M_x1 + M_x2 + 1 ) & ( n ==  M_y1 + M_y2 + 1 ) 
        valid = 4; % x-y-
    end
end

end