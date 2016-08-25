function [ valid ] = check_volume_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )

valid = false;

if ( ell >= 2 ) & ( ell <= N_p(p) ) & ( m >= 2 ) & ( m <= M_x ) & ( n >= 2 ) & ( n <= M_y )

valid = true;

    if ( m == M_x1 + 1 ) | ( m == M_x - M_x5 + 1 ) % B_p
        if ( n >= M_y1 + 2 ) & ( n <= M_y - M_y5 ) 
            valid = false;
        end
    elseif ( m >= M_x1 + 1 ) & ( m <= M_x - M_x5 + 1 ) % A_p
        if ( n == M_y1 + 1 ) | ( n == M_y - M_y5 + 1 )
            valid = false;
        end
    end

    if ( p >= 2 ) & ( p <= 8 )
        if ( m == M_x1 + M_x2 + 1 ) | ( m == M_x - M_x5 - M_x4 + 1 ) % D_p
            if ( n >= M_y1 + M_y2 + 2 ) & ( n <=  M_y - M_y5 - M_y4 ) 
                valid = false;
            end
        elseif ( m >= M_x1 + M_x2 + 1 ) & ( m <= M_x - M_x5 - M_x4 + 1 ) % C_p
            if ( n == M_y1 + M_y2 + 1 ) | ( n == M_y - M_y5 - M_y4 + 1 )
                valid = false;
            end
        end
    end
end

end

