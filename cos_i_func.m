function [ cos_i ] = cos_i_func( h_1, h_2 )

% rotate by angle: - acttan(h_2 / h_1)

cos_i = h_1 / sqrt( h_1^2 + h_2^2 );

end

