function [ tilde_x, flag ] = UPDATE( i, h, s, tol, v, A, b, x_0 )

H = zeros(i);
H = h(1: 1: i, 1: 1: i);
tilde_s = s(1: 1: i);
flag = false;

y = step(dsp.UpperTriangularSolver, H, tilde_s);

v_matrix = v( :, 1: 1: i );

tilde_x = x_0 + v_matrix * y;

if abs( norm(b - A * tilde_x) ) < tol
    flag = true;
    disp( ['The residual is ', num2str( norm(b - A * tilde_x) )] );
end

end