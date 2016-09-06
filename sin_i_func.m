function [ sin_i ] = sin_i_func( h_1, h_2 )

% rotate by angle: - acttan(h_2 / h_1)

sin_i = h_2 / sqrt( h_1^2 + h_2^2 );

end

