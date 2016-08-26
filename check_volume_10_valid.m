function [ valid ] = check_volume_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )

valid = false;

if p == 10
    if ( ell >= 2 ) & ( ell <= N_10 ) 
        if ( m >= 2 ) & ( m <= M_x ) & ( n >= 2 ) & ( n <= M_y )
            valid = true;
        end
    end
end

end