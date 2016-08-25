function [ valid ] = check_AB_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )

valid = false;

if ~ ( ( p >= 1 ) & ( p <= 9 ) )
    disp('The p are not valid in A_p and B_p region.')
end

if ( ell >= 2 ) & ( ell <= N_p(p) )
    if ( m == M_x - M_x5 + 1 ) & ( n >= M_y1 + 2 ) & ( n <=  M_y - M_y5 ) 
        valid = 1; % right
    elseif ( m == M_x1 + 1 ) & ( n >= M_y1 + 2 ) & ( n <=  M_y - M_y5 ) 
        valid = 2; % left
    elseif ( n == M_y - M_y5 + 1 ) & ( m >= M_x1 + 2 ) & ( m <=  M_x - M_x5 ) 
        valid = 3; % forward
    elseif ( n == M_y1 + 1 ) & ( m >= M_x1 + 2 ) & ( m <=  M_x - M_x5 ) 
        valid = 4; % backward
    end
end

end