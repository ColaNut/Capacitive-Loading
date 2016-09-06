function [ H_1, H_2 ] = Test_func( h_1, h_2 )

% rotate by angle: - acttan(h_2 / h_1)

H_1 = h_1 * h_2;
H_2 = h_1 - h_2;

end