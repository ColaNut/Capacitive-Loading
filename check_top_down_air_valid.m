function [ valid ] = check_top_down_air_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )

valid = false;

if ( p == 9 ) & ( ell == N_p(p) + 1 ) 
    if ( m >= 2 ) & ( m <= M_x ) & ( n >= 2 ) & ( n <= M_y )

        valid = 1; % top air
        
        if ( m >= M_x1 + 1 ) & ( m <= M_x - M_x5 + 1 ) & ( n >= M_y1 + 1 ) & ( n <= M_y - M_y5 + 1 )
            valid = false;
        end

    end
end

if ( p == 1 ) & ( ell == 1 ) 
    if ( m >= 2 ) & ( m <= M_x ) & ( n >= 2 ) & ( n <= M_y )

        valid = 2; % bottom air
        
        if ( m >= M_x1 + 1 ) & ( m <= M_x - M_x5 + 1 ) & ( n >= M_y1 + 1 ) & ( n <= M_y - M_y5 + 1 )
            valid = false;
        end

    end
end

end