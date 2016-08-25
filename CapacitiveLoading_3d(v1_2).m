clc; clear;
digits;
N = int32(9); % [ skin, muscle, lung, muscle, skin ]

Mu_0        = 4 * pi * 10^(-7);
Epsilon_0   = 10^(-9) / (36 * pi);
Omega_0     = 2 * pi * 10 * 10^6; % 2 * pi * 2.45 GHz

V_0         = 126;
% thickness   = [ 2.5, 0.02, 3.53, 1.00, 2.75, 14.62, 2.91, 0.19, 2.5 ]' ./ 100; % cm -> m, total = 31 cm
thickness   = [ 2.0, 0.02, 3.5, 1.00, 2.8, 15, 3, 0.2, 2.0 ]' ./ 100; % cm -> m, total = 31 cm
% thickness   = [ 2, 2, 4, 2, 3, 15, 3, 2, 2 ]' ./ 100; % cm -> m, total = 31 cm
epsilon_r   = [ 113.0, 303.1, 184, 264.9, 402, 264.9, 184, 303.1, 113.0 ]';
epsilon_b_r = epsilon_r(1);
epsilon_0_r = 1;
epsilon     = epsilon_r * Epsilon_0;
epsilon_b   = epsilon(1);
sigma       = [ 0.61, 0.33, 0.685, 0.42, 0.68, 0.42, 0.685, 0.33, 0.61 ]';
AccuDepth   = zeros(size(thickness));
AccuDepth   = cumsum(thickness);

% Length definitions
w_0         = 16 / 100; % 60 cm
w           = 4 / 100; % 30 cm
x_0         = ( w_0 - w ) / 2;
h_b         = thickness(1); % thickness of the bolus 
d_x         = 1 / 100; % 1cm
d_y         = 1 / 100; % 1cm
% d_z         = 1 / 100 * ones(N, 1); % 1cm 
d_z = [ 0.5, 0.01, 0.5, 0.5, 1.4, 5, 1, 0.1, 0.5 ]' ./ 100; % 0.1cm

% M_xs, M_ys and N_p
M_x1        = int32( ( x_0 - h_b ) / d_x );
M_x2        = int32( h_b / d_x );
M_x3        = int32( w / d_x );
M_x4        = M_x2;
M_x5        = M_x1;
M_x         = M_x1 + M_x2 + M_x3 + M_x4 + M_x5; 
M_x_max     = M_x + 1;

M_y1        = M_x1;
M_y2        = M_x2;
M_y3        = M_x3;
M_y4        = M_x4;
M_y5        = M_x5;
M_y         = M_y1 + M_y2 + M_y3 + M_y4 + M_y5;
M_y_max     = M_y + 1;

N_p = int32(thickness ./ d_z);
cum_thickness = cumsum(thickness);
cum_N_p = int32(cumsum(double(N_p)));
N_max = sum(N_p) + 1;

A = zeros( M_x_max * M_y_max * N_max );
B = zeros( M_x_max * M_y_max * N_max, 1 );

disp('The fill up time: ')
tic;
% disp('AB line: ');
% If one error occurrs then the check of the following codes are needed.
for idx = 1: 1: M_x_max * M_y_max * N_max
    % idx = ( ell - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_x_max + m;
    tmp_m = mod( idx, M_x_max );
    if tmp_m == 0
        m = M_x_max;
    else
        m = tmp_m;
    end

    if mod( idx, M_x_max * M_y_max ) == 0
        n = M_y_max;
    else
        n = ( mod( idx, M_x_max * M_y_max ) - m ) / M_x_max + 1;
    end
    
    ell_all = int32(( idx - m - ( n - 1 ) * M_x_max ) / ( M_x_max * M_y_max ) + 1);
    
    p = get_p(ell_all, cum_N_p);
    if p == 1
        ell = ell_all;
    else
        ell = ell_all - cum_N_p(p - 1);
    end
    
    p0 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % center point
    p1 = int32( ( ell_all     ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell + 1
    p2 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m - 1 ); % m - 1
    p3 = int32( ( ell_all - 2 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell - 1
    p4 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m + 1 ); % m + 1
    p5 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n     ) * M_y_max + m ); % n + 1
    p6 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 2 ) * M_y_max + m ); % n - 1

    p1_up   = int32( ( ell_all + 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell + 2
    p3_down = int32( ( ell_all - 3 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell - 1

    if (p == 9)
        ;
    end

    if check_volume_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
        A( idx, : ) = Laplace_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z );
    end

    if check_G_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
        A( idx, : ) = G_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r );
    end

    G_line_idx = check_G_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if G_line_idx
        A( idx, : ) = G_line_A( G_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    G_point_idx = check_G_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if G_point_idx
        A( idx, : ) = G_point_A( G_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    CD_face_idx = check_CD_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if CD_face_idx
        A( idx, : ) = CD_A( CD_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    CD_line_idx = check_CD_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if CD_line_idx
        A( idx, : ) = CD_line_A( CD_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    % checked
    Bolus_face_idx = check_bolus_face_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if Bolus_face_idx
        A( idx, : ) = bolus_face_A( Bolus_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    % checked
    Bolus_horizental_line_idx = check_bolus_horizental_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if Bolus_horizental_line_idx
        A( idx, : ) = bolus_horizental_line_A( Bolus_horizental_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % checked
    bolus_point_idx = check_bolus_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if bolus_point_idx
        A( idx, : ) = bolus_point_A( bolus_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % checked 
    AB_face_idx = check_AB_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if AB_face_idx
        A( idx, : ) = AB_A( AB_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % checked
    AB_line_idx = check_AB_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if AB_line_idx
        A( idx, : ) = AB_line_A( AB_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % checked
    air_face_idx = check_air_face_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_face_idx
        A( idx, : ) = air_face_A( air_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    air_horizental_line_idx = check_air_horizental_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_horizental_line_idx
        A( idx, : ) = air_horizental_line_A( air_horizental_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    air_point_idx = check_air_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_point_idx
        A( idx, : ) = air_point_A( air_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    air_vertical_face_idx = check_air_vertical_face_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_vertical_face_idx
        A( idx, : ) = air_vertical_face_A( air_vertical_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    air_vertical_line_idx = check_air_vertical_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_vertical_line_idx
        A( idx, : ) = air_vertical_line_A( air_vertical_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    plate_idx = check_plate_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if plate_idx
        switch plate_idx
            case 1
                A( idx, : ) = plate_A( plate_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
                B( idx ) = V_0;
            case 2
                A( idx, : ) = plate_A( plate_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
            otherwise
                disp('wrong')
        end
    end

    top_down_bolus_idx = check_top_down_bolus_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_down_bolus_idx
        A( idx, : ) = top_down_bolus_A( top_down_bolus_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % Start from here.
    top_down_bolus_line_idx = check_top_down_bolus_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_down_bolus_line_idx
        A( idx, : ) = top_down_bolus_line_A( top_down_bolus_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    top_down_bolus_point_idx = check_top_down_bolus_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_down_bolus_point_idx
        A( idx, : ) = top_down_bolus_point_A( top_down_bolus_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    top_down_air_idx = check_top_down_air_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_down_air_idx
        A( idx, : ) = top_down_air_A( top_down_air_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    top_down_air_line_idx = check_top_down_air_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_down_air_line_idx
        A( idx, : ) = top_down_air_line_A( top_down_air_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    top_down_air_point_idx = check_top_down_air_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_down_air_point_idx
        A( idx, : ) = top_down_air_point_A( top_down_air_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end
end
toc;

% % Check for empty rows in A
% for idx = 1: 1: M_x_max * M_y_max * N_max
%     tmp_m = mod( idx, M_x_max );
%     if tmp_m == 0
%         m = M_x_max;
%     else
%         m = tmp_m;
%     end

%     if mod( idx, M_x_max * M_y_max ) == 0
%         n = M_y_max;
%     else
%         n = ( mod( idx, M_x_max * M_y_max ) - m ) / M_x_max + 1;
%     end
    
%     ell_all = ( idx - m - ( n - 1 ) * M_x_max ) / ( M_x_max * M_y_max ) + 1;
    
%     p = get_p(ell_all, cum_N_p);
%     if p == 1
%         ell = ell_all;
%     else
%         ell = ell_all - cum_N_p(p - 1);
%     end

%     if A(idx, :) == zeros( 1, M_x_max * M_y_max * N_max);
%         disp( [' Error in [ ', num2str(m), ', ', num2str(n), ', ', num2str(ell), '] in layer', num2str(p)] );
%     end
% end

% % disp('The calculation time for inverse matrix using conjugate gradient: ')
% % tic;
% % [bar_x_cgs, flag, relres] = cgs(A, B, 10^(-6), 20);
% % toc;

disp('The calculation time for inverse matrix: ');
tic;
bar_x = A \ B;
toc;

disp('The saving time: ')
tic;
save('Preliminary_hetero_zp.mat');
toc;

% % Write another script for the following code.

% Cross_section = zeros( N_max, M_x_max );

% for idx = 1: 1: M_x_max * M_y_max * N_max
%     tmp_m = mod( idx, M_x_max );
%     if tmp_m == 0
%         m = M_x_max;
%     else
%         m = tmp_m;
%     end

%     if mod( idx, M_x_max * M_y_max ) == 0
%         n = M_y_max;
%     else
%         n = ( mod( idx, M_x_max * M_y_max ) - m ) / M_x_max + 1;
%     end
    
%     ell_all = ( idx - m - ( n - 1 ) * M_x_max ) / ( M_x_max * M_y_max ) + 1;
    
%     p = get_p(ell_all, cum_N_p);
%     if p == 1
%         ell = ell_all;
%     else
%         ell = ell_all - cum_N_p(p - 1);
%     end

%     if n == int32( ( 1 + M_y ) / 2 )
%     % if m == 4
%         Cross_section( ell_all, m ) = bar_x(idx);
%     end
% end

% % [ E_x, E_z ] = cr0eateVector( Cross_section, d_x, d_z, M_x_max, M_y_max, N_max );

% x_ori = 0: d_x: w_0;
% z_ori = [];
% for idx = 1: 1: length(thickness)
%     if idx == 1
%         z_ori = 0: d_z(idx): thickness(idx);
%     else
%         z_ori = [z_ori, z_ori(length(z_ori)) + d_z(idx): d_z(idx): cum_thickness(idx)];
%     end
% end
% [x_mesh, z_mesh] = meshgrid(x_ori, z_ori);
% figure(1);
% % contourf(x_mesh * 100, z_mesh * 100, Cross_section, 15);
% % hold on;
% % quiver(x_mesh * 100, z_mesh * 100, E_x, E_z, 'color',[0 0 0], 'LineWidth', 2.0);
% % hold on;
% surf(x_mesh * 100, z_mesh * 100, Cross_section, 'EdgeColor','none'); 
% colorbar;
% set(gca,'fontsize',14);
% axis( [ 0, w_0 * 100, 0, sum(thickness) * 100, min(min(Cross_section)), max(max(Cross_section)) ] );
% % axis( [ (- d_x) * 100, (w_0 + d_x) * 100, (- d_z(1)) * 100, (sum(thickness) + d_z(9)) * 100, min(min(Cross_section)), max(max(Cross_section)) ] );
% xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
% zlabel('$\Phi (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 18);
% view(2);

% % x_cut = x_0 - h_b + d_x: d_x: x_0 + w + h_b - d_x;
% % Cross_section_tissue_bolus = Cross_section(:, M_x1 + 2: M_x - M_x5);
% % E_x_tissue_bolus = E_x(:, M_x1 + 2: M_x - M_x5);
% % E_z_tissue_bolus = E_z(:, M_x1 + 2: M_x - M_x5);
% % [x_cut_mesh, z_cut_mesh] = meshgrid(x_cut, z_ori);
% % figure(2);
% % contourf(x_cut_mesh * 100, z_cut_mesh * 100, Cross_section_tissue_bolus, 15);
% % hold on;
% % quiver(x_cut_mesh * 100, z_cut_mesh * 100, E_x_tissue_bolus, E_z_tissue_bolus, 'color',[0 0 0], 'LineWidth', 2.0);
% % hold on;
% % % colormap(zeros(1,3));
% % % surf(x_mesh, z_mesh, Cross_section, 'EdgeColor','none'); % m -> \mu m
% % colorbar
% % set(gca,'fontsize',14);
% % % axis( [ 0, w_0, 0, sum(thickness), min(min(Cross_section)), max(max(Cross_section)) ] );
% % xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% % ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
% % zlabel('$\Phi (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 18);
% % view(2);

% % X_thickness = [ ( x_0 - h_b ), h_b, w, h_b, ( x_0 - h_b ) ];
% % layer_num   = length(X_thickness);
% % XAccuDepth  = cumsum(X_thickness);
% % plotVerticalLine_capacitive_loading( figure(1), layer_num, XAccuDepth * 100, sum(thickness) * 100, 0, length(x_ori) );
% % % plotVerticalLine_capacitive_loading( figure(2), layer_num, XAccuDepth, max(max(Cross_section)), min(min(Cross_section)), length(x_ori) );

% % figure(2);
% % plot( x_ori, Cross_section(1, :), 'k--o', 'LineWidth', 2.5 );
% % set(gca,'fontsize',14);
% % axis( [ 0, w_0, min(min(Cross_section)), max(max(Cross_section)) ] );
% % xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% % ylabel('$\Phi (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 18);
% % hold on;
% % plot( x_ori, Cross_section( ceil( (1 + length(z_ori)) / 2 ), : ), 'k--', 'LineWidth', 2.5 );
% % hold on;
% % plot( x_ori, Cross_section(length(z_ori), :), 'k', 'LineWidth', 2.5 );
% % hold on;
% % plotVerticalLine_capacitive_loading( figure(2), layer_num, XAccuDepth, max(max(Cross_section)), min(min(Cross_section)), length(x_ori) );

% % [ M_x1, M_x2, M_x3, M_x4, M_x5, M_x ];