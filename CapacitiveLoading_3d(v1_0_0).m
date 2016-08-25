clc; clear;
digits;
N = 9; % [ skin, muscle, lung, muscle, skin ]

Mu_0        = 4 * pi * 10^(-7);
Epsilon_0   = 10^(-9) / (36 * pi);
Omega_0     = 2 * pi * 10 * 10^6; % 2 * pi * 2.45 GHz

V_0         = 126;
% thickness   = [ 2.5, 0.02, 3.53, 1.00, 2.75, 14.62, 2.91, 0.19, 2.5 ]' ./ 100; % cm -> m, total = 31 cm
% thickness   = [ 2.5, 0.1, 3.5, 1.00, 2.8, 14.6, 2.9, 0.2, 2.5 ]' ./ 100; % cm -> m, total = 31 cm
thickness   = [ 2, 2, 4, 2, 3, 15, 3, 2, 2 ]' ./ 100; % cm -> m, total = 31 cm
epsilon_r   = [ 113.0, 303.1, 184, 264.9, 402, 264.9, 184, 303.1, 113.0 ]';
epsilon_layer = epsilon_r * Epsilon_0;
sigma       = [ 0.61, 0.33, 0.685, 0.42, 0.68, 0.42, 0.685, 0.33, 0.61 ]';
% AccuDepth   = zeros(size(thickness));
% for idx = 2: 1: N
%     AccuDepth(idx:(N)) = AccuDepth(idx:(N)) - thickness(idx);
% end

% Length definitions
w_0         = 10 / 100; % 60 cm
w           = 5 / 100; % 30 cm
x_0         = ( w_0 - w ) / 2;
h_b         = thickness(1); % thickness of the bolus 
d_x         = 1 / 100; % 1cm
d_y         = 1 / 100; % 1cm
d_z         = 1 / 100 * ones(N, 1); % 0.1cm

% M_xs, M_ys and N_p
M_x1        = ( x_0 - h_b ) / d_x;
M_x2        = h_b / d_x;
M_x3        = w / d_x;
M_x4        = M_x2;
M_x5        = M_x1;
M_x = M_x1 + M_x2 + M_x3 + M_x4 + M_x5; 
M_x_max = M_x + 1;

M_y1        = M_x1;
M_y2        = M_x2;
M_y3        = M_x3;
M_y4        = M_x4;
M_y5        = M_x5;
M_y = M_y1 + M_y2 + M_y3 + M_y4 + M_y5;
M_y_max = M_y + 1;

N_p = thickness ./ d_z;
cum_N_p = cumsum(N_p);
N_max = sum(N_p) + 1;

A = zeros( M_x_max * M_y_max * N_max );
% volume Laplace equation

% Test on the 
for idx = ( M_x_max * M_y_max * N_p(1) ) + 1: 1: ( M_x_max * M_y_max * ( sum(N_p) - N_p(N) ) )
    % idx = ( ell - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m;
    m = mod( idx, M_x_max );
    n = ( mod( idx, M_x_max * M_y_max ) - m ) / M_x_max + 1;
    ell_all = ( idx - m - ( n - 1 ) * M_x_max ) / ( M_x_max * M_y_max ) + 1;
    p = get_p(ell_all, N_p);
    % if p == 1
    %     ell = ell_all;
    % else
    %     ell = ell_all - cum_N_p(p - 1);
    % end
    
    if check_volume_valid( m, n, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
        A( idx, : ) = Laplace_A( m, n, ell_all, M_x_max, M_y_max, N_max, N_p, d_x, d_y, d_z(p) );
    end
    if check_G_valid( m, n, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
        A( idx, : ) = G_A( m, n, ell_all, M_x_max, M_y_max, N_max, N_p, d_x, d_y, d_z(p) ); 
    end
end


% E_p = zeros(size(thickness));
% E_p = - ( V_0 ./ epsilon_r ) / sum(thickness ./ epsilon_r);
% b_p = zeros(size(thickness));
% for idx = 1: 1: 8
%     b_p(idx) = V_0 * sum( thickness(idx + 1: N + 2) ./ epsilon_r(idx + 1: N + 2) ) / sum(thickness ./ epsilon_r);
% end
% b_p(N + 2) = 0;

% Q_sp = sigma .* ( abs(E_p).^2 );
% Depth       = AccuDepth(N + 2);
% Interval    = 0.01  / 100; % 0.01 cm
% Height      = thickness(1);
% zAxis = Depth : Interval : Height;

% Phi_p = zeros( int64((Height - Depth) / Interval) + 1, 1);

% now_n =9;
% for z = Depth : Interval : Height
%     if z <= AccuDepth(8)
%         now_n = 9;
%     elseif z <= AccuDepth(7)
%         now_n = 8;
%     elseif z <= AccuDepth(6)
%         now_n = 7;
%     elseif z <= AccuDepth(5)
%         now_n = 6;
%     elseif z <= AccuDepth(4)
%         now_n = 5;
%     elseif z <= AccuDepth(3)
%         now_n = 4;
%     elseif z <= AccuDepth(2)
%         now_n = 3;
%     elseif z <= AccuDepth(1) % < 0
%         now_n = 2;
%     else
%         now_n = 1;
%     end

%     Phi_p( int16( ((z - Depth) / Interval) + 1 ) ) = - E_p(now_n) * (z - AccuDepth(now_n)) + b_p(now_n);
% end

% Q_sp_array = [Q_sp(N + 2)];
% Ep_array = [E_p(N + 2)];
% for idx = 1: 1: N + 2
%     Ep_array = [Ep_array, repmat(E_p(N + 3 - idx), 1, int32( thickness(N + 3 - idx) / Interval) )];
%     Q_sp_array = [Q_sp_array, repmat(Q_sp(N + 3 - idx), 1, int32( thickness(N + 3 - idx) / Interval) )];
% end

% % plot(zAxis * 100, Ep_array, 'k');
% my_plot( figure(1), zAxis * 100, abs(Ep_array), [AccuDepth(N + 2) * 100, thickness(1) * 100, 0, max(abs(E_p))], '$z$ (cm)', '$| \bar{E}_p |$ (V/m)', N + 2, AccuDepth * 100 );
% my_plot( figure(2), zAxis * 100, abs(Q_sp_array), [AccuDepth(N + 2) * 100, thickness(1) * 100, 0, max(abs(Q_sp))], '$z$ (cm)', '$Q_{sp}$ (watt/m$^3$)', N + 2, AccuDepth * 100 );
% my_plot( figure(3), zAxis * 100, abs(Phi_p), [AccuDepth(N + 2) * 100, thickness(1) * 100, 0, max(abs(Phi_p))], '$z$ (cm)', '$\Phi_p$ (V)', N + 2, AccuDepth * 100 );

% xi   = [ 0, 1.67, 8.3, 2.38, 1.92, 2.38, 8.3, 1.67, 0 ]' ./ 10^6;
% rho  = [ 1020, 1125, 1020, 1050, 1040, 1050, 1020, 1125, 1020 ]';
% cap  = [ 4200, 3300, 3500, 3886, 3795, 3886, 3500, 3300, 4200 ]';

% rho_b   = 1060;
% c_b     = 3960;

% time_Int = 10; % 10 second
% Int_num  = 120;
% t_end = time_Int * Int_num;
% T = zeros(Int_num + 1, N);

% for layer_idx = 1: 1: N
%     for t_now = 0: time_Int: t_end
%         idx = 1 + t_now / 10;
%         tau = 0: 1: t_now;
%         T(idx, layer_idx) = sum( exp(- xi(layer_idx + 1) * rho_b * c_b * ( t_now - tau ) ./ cap(layer_idx + 1) ) ) ...
%                                 * Q_sp(layer_idx + 1) ./ (rho(layer_idx + 1) * cap(layer_idx + 1));
%     end
% end

% T_array = [T(:, N)];
% for idx = 1: 1: N
%     p   = N + 1 - idx;
%     T_array = [T_array, repmat( T(:, idx), 1, int32( thickness(p + 1) / Interval) )];
% end

% z = AccuDepth(8) : Interval : AccuDepth(1);
% t = 0: time_Int: t_end;
% [z_mesh, t_mesh] = meshgrid(z, t);

% figure(4);
% surf(z_mesh * 100, t_mesh / 60, T_array, 'EdgeColor','none'); % m -> \mu m
% hold on;
% colorbar
% set(gca,'fontsize',14);
% axis( [ AccuDepth(8) * 100, AccuDepth(1) * 100, 0, t_end / 60, min(min(T)), max(max(T)) ] );
% xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% ylabel('$t$ (min)','Interpreter','LaTex', 'FontSize', 18);
% zlabel('$T^\prime (x, t)$ ($^\circ$C)','Interpreter','LaTex', 'FontSize', 18);
% view(2);

% figure(5);
% plot(t / 60, T(:, 4), 'k', 'LineWidth', 1.5 );
% box on;
% set(gca,'LineWidth', 2.0);
% xlabel('$t$ (min)', 'Interpreter','LaTex', 'FontSize', 20);
% ylabel('$T^\prime$ (x, t) ($^\circ$C)','Interpreter','LaTex', 'FontSize', 20);
