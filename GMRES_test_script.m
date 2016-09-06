% clc; clear;
% load('Preliminary_hetero_zp_10.mat');

% tol = 1e-6;
% % int_itr_num = 20;
% % ext_itr_num = 20;
% x_zero = B_10;

% ext_ini = 5;
% ext_interval = 5; 
% Max_ext = 40;
% int_ini = 5;
% int_interval = 5; 
% Max_int = 40;

% ratio_my_gmres = zeros( (Max_int - int_ini) / int_interval + 1, (Max_ext - ext_ini) / ext_interval + 1 );

% bar_x_10 = A_10 \ B_10;

% for ext_itr_num = ext_ini: ext_interval: Max_ext
%     for int_itr_num = int_ini: int_interval: Max_int
%         bar_x_my_gmres = GMRES_test( A_10, B_10, ext_itr_num, int_itr_num, tol, x_zero );
%         ratio_my_gmres(int_itr_num / 5, ext_itr_num / 5) = 100 * norm( bar_x_10 - bar_x_my_gmres ) / norm(bar_x_10);
%     end
% end

save('GMRES_test_script2.mat');

% tmp_ratio_my_gmres = zeros( (Max_int - int_ini) / int_interval + 1, (Max_ext - ext_ini) / ext_interval + 1 );
% for ext_num = 1: 1: (Max_ext - ext_ini) / ext_interval + 1
%     for int_num = 1: 1: (Max_int - int_ini) / int_interval + 1
%         tmp_ratio_my_gmres(int_num, ext_num) = ratio_my_gmres(5 * int_num, 5 * ext_num);
%     end
% end

% ratio_my_gmres = tmp_ratio_my_gmres;

ext_num = ext_ini: ext_interval: Max_ext;
for int_num = 1: 1: (Max_int - int_ini) / int_interval + 1
    Color_num = int_num * 0.08;
    semilogy( ext_num, ratio_my_gmres(int_num, :), 'Color', [Color_num, Color_num, Color_num], 'LineWidth', 2.5 );
    hold on;
end

set(gca,'fontsize',14);
axis( [ ext_ini, Max_ext, 0, 100 ] );
xlabel('${\rm Ext}_{itr}$', 'Interpreter','LaTex', 'FontSize', 18);
ylabel('$error$','Interpreter','LaTex', 'FontSize', 18);

legend_handle = legend( '${\rm Itr}_{int}$ = 5', '${\rm Itr}_{int}$ = 10', '${\rm Itr}_{int}$ = 15', '${\rm Itr}_{int}$ = 20', '${\rm Itr}_{int}$ = 25', '${\rm Itr}_{int}$ = 30', '${\rm Itr}_{int}$ = 35', '${\rm Itr}_{int}$ = 40', '${\rm Itr}_{int}$ = 45', '${\rm Itr}_{int}$ = 50', 'Location', 'eastoutside' );
set(legend_handle,'Interpreter','latex');

% % bar_x_my_gmres = GMRES_test( A_10, B_10, 25, 15, tol, x_zero );
% % Errpr_15 = 100 * norm( bar_x_10 - bar_x_my_gmres ) / norm(bar_x_10);
% % figure(2);
% % cross_section_test_gmres;

% % bar_x_my_gmres = GMRES_test( A_10, B_10, 25, 20, tol, x_zero );
% % Errpr_20 = 100 * norm( bar_x_10 - bar_x_my_gmres ) / norm(bar_x_10);
% % figure(3);
% % cross_section_test_gmres;

% % bar_x_my_gmres = GMRES_test( A_10, B_10, 25, 35, tol, x_zero );
% % Errpr_35 = 100 * norm( bar_x_10 - bar_x_my_gmres ) / norm(bar_x_10);
% % figure(4);
% % cross_section_test_gmres;
