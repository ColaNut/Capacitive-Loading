clc; clear;
digits;
N = 7; % [ skin, muscle, lung, muscle, skin ]

Mu_0        = 4 * pi * 10^(-7);
Epsilon_0   = 10^(-9) / (36 * pi);
Omega_0     = 2 * pi * 2.45 * 10^9; % 2 * pi * 2.45 GHz

V_0         = 126;
thickness   = [ 2.38, 0.02, 3.53, 1.00, 2.75, 14.62, 2.91, 0.19, 2.38 ]' ./ 100; % cm -> m, total = 31 cm
epsilon_r   = [ 113.0, 214.7, 113.0, 148, 60, 148, 113.0, 214.7, 113.0 ]';
sigma       = [ 0.61, 0.33, 0.61, 0.159, 0.8, 0.159, 0.61, 0.33, 0.61 ]';
AccuDepth   = zeros(size(thickness));
for idx = 2: 1: N + 2
    AccuDepth(idx:(N + 2)) = AccuDepth(idx:(N + 2)) - thickness(idx);
end

E_p = zeros(size(thickness));
E_p = - ( V_0 ./ epsilon_r ) / sum(thickness ./ epsilon_r);
b_p = zeros(size(thickness));
for idx = 1: 1: 8
    b_p(idx) = V_0 * sum( thickness(idx + 1: N + 2) ./ epsilon_r(idx + 1: N + 2) ) / sum(thickness ./ epsilon_r);
end
b_p(N + 2) = 0;

Q_sp = sigma .* ( abs(E_p).^2 );
Depth       = AccuDepth(N + 2);
Interval    = 0.01  / 100; % 0.01 cm
Height      = thickness(1);
zAxis = Depth : Interval : Height;

Phi_p = zeros( int64((Height - Depth) / Interval) + 1, 1);

now_n =9;
for z = Depth : Interval : Height
    if z <= AccuDepth(8)
        now_n = 9;
    elseif z <= AccuDepth(7)
        now_n = 8;
    elseif z <= AccuDepth(6)
        now_n = 7;
    elseif z <= AccuDepth(5)
        now_n = 6;
    elseif z <= AccuDepth(4)
        now_n = 5;
    elseif z <= AccuDepth(3)
        now_n = 4;
    elseif z <= AccuDepth(2)
        now_n = 3;
    elseif z <= AccuDepth(1) % < 0
        now_n = 2;
    else
        now_n = 1;
    end

    Phi_p( int16( ((z - Depth) / Interval) + 1 ) ) = - E_p(now_n) * (z - AccuDepth(now_n)) + b_p(now_n);
end

Q_sp_array = [Q_sp(N + 2)];
Ep_array = [E_p(N + 2)];
for idx = 1: 1: N + 2
    Ep_array = [Ep_array, repmat(E_p(N + 3 - idx), 1, int32( thickness(N + 3 - idx) / Interval) )];
    Q_sp_array = [Q_sp_array, repmat(Q_sp(N + 3 - idx), 1, int32( thickness(N + 3 - idx) / Interval) )];
end

% plot(zAxis * 100, Ep_array, 'k');
my_plot( figure(1), zAxis * 100, abs(Ep_array), [AccuDepth(N + 2) * 100, thickness(1) * 100, 0, max(abs(E_p))], '$z$ (cm)', '$| \bar{E}_p |$ (V/m)', N + 2, AccuDepth * 100 );
my_plot( figure(2), zAxis * 100, abs(Q_sp_array), [AccuDepth(N + 2) * 100, thickness(1) * 100, 0, max(abs(Q_sp))], '$z$ (cm)', '$Q_{sp}$ (watt/m$^3$)', N + 2, AccuDepth * 100 );
my_plot( figure(3), zAxis * 100, abs(Phi_p), [AccuDepth(N + 2) * 100, thickness(1) * 100, 0, max(abs(Phi_p))], '$z$ (cm)', '$\Phi_p$ (V)', N + 2, AccuDepth * 100 );

xi_m    = 8.3 * 10^(- 6);
rho_b = 1.06 * 10^3;
c_b   = 3.96 * 10^3;
rho_m = 1.02 * 10^3;
c_m   = 3.5  * 10^3;

T_m = zeros(61, 1);
for t_end = 0: 10: 600
    idx = 1 + t_end / 10;
    tau = 0: 1: t_end;
    T_m(idx) = sum(exp(- xi_m * rho_b * c_b * ( t_end - tau ) ./ c_m)) * Q_sp(3) ./ (rho_m * c_m);
end

plot(0: 10: 600, T_m, 'k');
xlabel('$t$ (s)', 'Interpreter','LaTex', 'FontSize', 20);
ylabel('$T^\prime$ (x, t) ($^\circ$C)','Interpreter','LaTex', 'FontSize', 20);