function [ E_x, E_z ] = createVector( Cross_section, d_x, d_z, M_x_max, M_y_max, N_max )

E_x_tmp = zeros(size(Cross_section));
E_z_tmp = zeros(size(Cross_section));

d_z_uni = d_z(1);

for idx = 1: 1: M_x_max * N_max
    % ( ell - 1 ) * M_x_max + m 
    tmp_m = mod( idx, M_x_max );
    if tmp_m == 0
        m = M_x_max;
    else
        m = tmp_m;
    end

    ell = ( idx - m ) / ( M_x_max ) + 1;
    
    if ( m >= 2 ) & ( m <= M_x_max - 1 )
        if ( ell >= 2 ) & ( ell <= N_max - 1 )
            E_x_tmp(ell, m) = ( Cross_section(ell, m + 1) - Cross_section(ell, m - 1) ) / ( 2 * d_x );
            E_z_tmp(ell, m) = ( Cross_section(ell + 1, m) - Cross_section(ell - 1, m) ) / ( 2 * d_z_uni );
        end
    end

    % right border line
    if ( m == M_x_max )
        if ( ell >= 2 ) & ( ell <= N_max - 1 )
            E_x_tmp(ell, m) = ( Cross_section(ell    , m) - Cross_section(ell, m - 1) ) / d_x;
            E_z_tmp(ell, m) = ( Cross_section(ell + 1, m) - Cross_section(ell - 1, m) ) / ( 2 * d_z_uni );
        end
    end
    
    % left border line
    if ( m == 1 )
        if ( ell >= 2 ) & ( ell <= N_max - 1 )
            E_x_tmp(ell, m) = ( Cross_section(ell, m + 1) - Cross_section(ell    , m) ) / d_x;
            E_z_tmp(ell, m) = ( Cross_section(ell + 1, m) - Cross_section(ell - 1, m) ) / ( 2 * d_z_uni );
        end
    end

    % upper border line
    if ( ell == N_max )
        if ( m >= 2 ) & ( m <= M_x_max - 1 )
            E_x_tmp(ell, m) = ( Cross_section(ell, m + 1) - Cross_section(ell, m - 1) ) / ( 2 * d_x );
            E_z_tmp(ell, m) = ( Cross_section(ell, m    ) - Cross_section(ell - 1, m) ) / d_z_uni;
        end
    end

    % lower border line
    if ( ell == 1 )
        if ( m >= 2 ) & ( m <= M_x_max - 1 )
            E_x_tmp(ell, m) = ( Cross_section(ell, m + 1) - Cross_section(ell, m - 1) ) / ( 2 * d_x );
            E_z_tmp(ell, m) = ( Cross_section(ell + 1, m    ) - Cross_section(ell, m) ) / d_z_uni;
        end
    end

    % right-upper border point
    if ( m == M_x_max )
        if ( ell == N_max )
            E_x_tmp(ell, m) = ( Cross_section(ell, m) - Cross_section(ell, m - 1) ) / d_x;
            E_z_tmp(ell, m) = ( Cross_section(ell, m) - Cross_section(ell - 1, m) ) / d_z_uni;
        end
    end
    
    % right-lower border point
    if ( m == M_x_max )
        if ( ell == 1 )
            E_x_tmp(ell, m) = ( Cross_section(ell    , m) - Cross_section(ell, m - 1) ) / d_x;
            E_z_tmp(ell, m) = ( Cross_section(ell + 1, m) - Cross_section(ell, m    ) ) / d_z_uni;
        end
    end

    % left-upper border point
    if ( m == 1 )
        if ( ell == N_max )
            E_x_tmp(ell, m) = ( Cross_section(ell, m + 1) - Cross_section(ell, m) ) / d_x;
            E_z_tmp(ell, m) = ( Cross_section(ell, m    ) - Cross_section(ell - 1, m) ) / d_z_uni;
        end
    end

    % left-lower border point
    if ( m == 1 )
        if ( ell == 1 )
            E_x_tmp(ell, m) = ( Cross_section(ell    , m + 1) - Cross_section(ell, m) ) / d_x;
            E_z_tmp(ell, m) = ( Cross_section(ell + 1, m    ) - Cross_section(ell, m) ) / d_z_uni;
        end
    end
end

E_x = - E_x_tmp;
E_z = - E_z_tmp;

end