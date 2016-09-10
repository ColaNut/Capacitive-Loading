% load('Preliminary_hetero_zp_da.mat');

Cross_section_da_mid = zeros( N_da + N_max + N_10, M_x_max );
Cross_section_da_m4  = zeros( N_da + N_max + N_10, M_y_max );

for idx = 1: 1: M_x_max * M_y_max * ( N_da + N_max + N_10 )
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
    
    ell_all = ( idx - m - ( n - 1 ) * M_x_max ) / ( M_x_max * M_y_max ) + 1;
    
    % p = get_p(ell_all, cum_N_p);
    % if p == 1
    %     ell = ell_all;
    % else
    %     ell = ell_all - cum_N_p(p - 1);
    % end

    if n == int32( ( 1 + M_y ) / 2 )
        Cross_section_da_mid( ell_all, m ) = bar_x_da(idx);
    end

    if m == 4
        Cross_section_da_m4( ell_all, n ) = bar_x_da(idx);
    end
end

% [ E_x, E_z ] = createVector( Cross_section_10_mid, d_x, d_z, M_x_max, M_y_max, N_max );

x_ori = 0: d_x: w_0;
z_ori = [];
z_ori = 0: d_z_da: thickness_da;
for idx = 1: 1: length(thickness)
    z_ori = [z_ori, z_ori(length(z_ori)) + d_z(idx): d_z(idx): (thickness_da + cum_thickness(idx))];
end
% the 10-th layer
z_ori = [ z_ori, (z_ori(length(z_ori)) + d_z_10): d_z_10: (thickness_da + cum_thickness(9) + thickness_10) ];

[x_mesh, z_mesh] = meshgrid(x_ori, z_ori);
figure(1);
surf(x_mesh * 100, z_mesh * 100, Cross_section_da_mid, 'EdgeColor','none'); 
colorbar;
set(gca,'fontsize',14);
axis( [ 0, w_0 * 100, 0, (thickness_da + cum_thickness(9) + thickness_10) * 100, min(min(Cross_section_da_mid)), max(max(Cross_section_da_mid)) ] );
% axis( [ (- d_x) * 100, (w_0 + d_x) * 100, (- d_z(1)) * 100, (sum(thickness) + d_z(9)) * 100, min(min(Cross_section_da_mid)), max(max(Cross_section_da_mid)) ] );
xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
zlabel('$\Phi (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 18);
view(3);

% figure(2);
% contourf(x_mesh * 100, z_mesh * 100, Cross_section_da_mid, 15);
% colorbar;
% hold on;
% quiver(x_mesh * 100, z_mesh * 100, E_x, E_z, 'k', 'LineWidth', 2.0);
% hold on;

% x_cut = x_0 - h_b: d_x: x_0 + w + h_b;
% Cross_section_da_mid_tissue_bolus = Cross_section_da_mid(:, M_x1 + 1: M_x - M_x5 + 1);
% % E_x_tissue_bolus = E_x(:, M_x1 + 1: M_x - M_x5 + 1);
% % E_z_tissue_bolus = E_z(:, M_x1 + 1: M_x - M_x5 + 1);
% [x_cut_mesh, z_cut_mesh] = meshgrid(x_cut, z_ori);
% figure(2);
% surf(x_cut_mesh * 100, z_cut_mesh * 100, Cross_section_da_mid_tissue_bolus, 'EdgeColor','none'); % m -> \mu m
% colorbar
% set(gca,'fontsize',14);
% axis( [ (x_0 - h_b) * 100, (x_0 + w + h_b) * 100, 0, (thickness_da + cum_thickness(9) + thickness_da) * 100, min(min(Cross_section_da_mid_tissue_bolus)), max(max(Cross_section_da_mid_tissue_bolus)) ] );
% xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
% zlabel('$\Phi (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 18);
% view(3);
% % contourf(x_cut_mesh * 100, z_cut_mesh * 100, Cross_section_da_mid_tissue_bolus, 15);
% % hold on;
% % quiver(x_cut_mesh * 100, z_cut_mesh * 100, E_x_tissue_bolus, E_z_tissue_bolus, 'color',[0 0 0], 'LineWidth', 2.0);
% % hold on;
% % % colormap(zeros(1,3));


% figure(3);
% surf(x_mesh * 100, z_mesh * 100, Cross_section_da_m4, 'EdgeColor','none'); 
% colorbar;
% set(gca,'fontsize',14);
% axis( [ 0, w_0 * 100, 0, (thickness_da + cum_thickness(9) + thickness_da) * 100, min(min(Cross_section_da_m4)), max(max(Cross_section_da_m4)) ] );
% % axis( [ (- d_x) * 100, (w_0 + d_x) * 100, (- d_z(1)) * 100, (sum(thickness) + d_z(9)) * 100, min(min(Cross_section_da_m4)), max(max(Cross_section_da_m4)) ] );
% xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
% zlabel('$\Phi (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 18);
% view(3);

% Cross_section_da_m4_tissue_bolus = Cross_section_da_m4(:, M_x1 + 1: M_x - M_x5 + 1);
% % E_x_tissue_bolus = E_x(:, M_x1 + 1: M_x - M_x5 + 1);
% % E_z_tissue_bolus = E_z(:, M_x1 + 1: M_x - M_x5 + 1);
% [x_cut_mesh, z_cut_mesh] = meshgrid(x_cut, z_ori);
% figure(4);
% surf(x_cut_mesh * 100, z_cut_mesh * 100, Cross_section_da_m4_tissue_bolus, 'EdgeColor','none'); % m -> \mu m
% colorbar
% set(gca,'fontsize',14);
% axis( [ (x_0 - h_b) * 100, (x_0 + w + h_b) * 100, 0, (thickness_da + cum_thickness(9) + thickness_da) * 100, min(min(Cross_section_da_m4_tissue_bolus)), max(max(Cross_section_da_m4_tissue_bolus)) ] );
% xlabel('$y$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% ylabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 18);
% zlabel('$\Phi (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 18);
% view(3);

% % % X_thickness = [ ( x_0 - h_b ), h_b, w, h_b, ( x_0 - h_b ) ];
% % % layer_num   = length(X_thickness);
% % % XAccuDepth  = cumsum(X_thickness);
% % % plotVerticalLine_capacitive_loading( figure(1), layer_num, XAccuDepth * 100, sum(thickness) * 100, 0, length(x_ori) );
% % % % plotVerticalLine_capacitive_loading( figure(2), layer_num, XAccuDepth, max(max(Cross_section_10_mid)), min(min(Cross_section_10_mid)), length(x_ori) );

% % figure(5);
% % plot( x_ori, Cross_section_10_mid(1, :), 'k--o', 'LineWidth', 2.5 );
% % set(gca,'fontsize',14);
% % axis( [ 0, w_0, min(min(Cross_section_10_mid)), max(max(Cross_section_10_mid)) ] );
% % xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 18);
% % ylabel('$\Phi (x, z)$ ($V$)','Interpreter','LaTex', 'FontSize', 18);
% % hold on;
% % plot( x_ori, Cross_section_10_mid( ceil( (1 + length(z_ori)) / 2 ), : ), 'k--', 'LineWidth', 2.5 );
% % hold on;
% % plot( x_ori, Cross_section_10_mid(length(z_ori), :), 'k', 'LineWidth', 2.5 );
% % hold on;
% % plotVerticalLine_capacitive_loading( figure(2), layer_num, XAccuDepth, max(max(Cross_section_10_mid)), min(min(Cross_section_10_mid)), length(x_ori) );

% % [ M_x1, M_x2, M_x3, M_x4, M_x5, M_x ];