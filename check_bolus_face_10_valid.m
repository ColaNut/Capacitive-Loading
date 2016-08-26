function [ valid ] = check_bolus_face_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )

valid = false;

if ( p == 9 )
    if ( ell == N_p(p) + 1 ) & ( m >= M_x1 + 2 ) & ( m <= M_x - M_x5 ) & ( n >= M_y1 + 2 ) & ( n <= M_y - M_y5 )

    valid = true;

    if ( m >= M_x1 + M_x2 + 1 ) & ( m <= M_x - M_x5 - M_x4 + 1 ) 
        if ( n >= M_y1 + M_y2 + 1 ) & ( n <=  M_y - M_y5 - M_y4 + 1) 
            valid = false;
        end
    end

    end
end

end