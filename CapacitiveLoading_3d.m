% clc; clear;
% digits;
% N = int32(9); % [ bolus, skin, muscle, lung, tumor, lung, muscle, skin, bolus ]

% Mu_0        = 4 * pi * 10^(-7);
% Epsilon_0   = 10^(-9) / (36 * pi);
% Omega_0     = 2 * pi * 10 * 10^6; % 2 * pi * 2.45 GHz

% V_0         = 126;
% % thickness   = [ 2.5, 0.02, 3.53, 1.00, 2.75, 14.62, 2.91, 0.19, 2.5 ]' ./ 100; % cm -> m, total = 31 cm
% thickness_da = 5 / 100; % 20 cm (down air)
% thickness   = [ 2.0, 0.02, 3.5, 1.00, 2.8, 15, 3, 0.2, 2.0 ]' ./ 100; % cm -> m, total = 31 cm
% thickness_10 = 5 / 100; % 15 cm
% % thickness   = [ 2, 2, 4, 2, 3, 15, 3, 2, 2 ]' ./ 100; % cm -> m, total = 31 cm
% epsilon_r   = [ 113.0, 303.1, 184, 264.9, 402, 264.9, 184, 303.1, 113.0 ]';
% epsilon_b_r = epsilon_r(1);
% epsilon_0_r = 1;
% epsilon     = epsilon_r * Epsilon_0;
% epsilon_b   = epsilon(1);
% sigma       = [ 0.61, 0.33, 0.685, 0.42, 0.68, 0.42, 0.685, 0.33, 0.61 ]';
% AccuDepth   = zeros(size(thickness));
% AccuDepth   = cumsum(thickness);

% % Length definitions
% w_0         = 16 / 100; % 60 cm
% w           = 4 / 100; % 30 cm
% x_0         = ( w_0 - w ) / 2;
% h_b         = 2 * thickness(1); % thickness of the bolus 
% d_x         = 1 / 100; % 1cm
% d_y         = 1 / 100; % 1cm
% % d_z         = 1 / 100 * ones(N, 1); % 1cm 
% d_z_da = 1 ./ 100;
% d_z = [ 0.5, 0.01, 0.5, 0.5, 1.4, 5, 1, 0.1, 0.5 ]' ./ 100; % 0.1cm
% d_z_10 = 1 ./ 100; % 5cm

% % M_xs, M_ys and N_p
% M_x1        = int32( ( x_0 - h_b ) / d_x );
% M_x2        = int32( h_b / d_x );
% M_x3        = int32( w / d_x );
% M_x4        = M_x2;
% M_x5        = M_x1;
% M_x         = M_x1 + M_x2 + M_x3 + M_x4 + M_x5; 
% M_x_max     = M_x + 1;

% M_y1        = M_x1;
% M_y2        = M_x2;
% M_y3        = M_x3;
% M_y4        = M_x4;
% M_y5        = M_x5;
% M_y         = M_y1 + M_y2 + M_y3 + M_y4 + M_y5;
% M_y_max     = M_y + 1;

% N_da = int32(thickness_da ./ d_z_da);
% N_p  = int32(thickness ./ d_z);
% N_10 = int32(thickness_10 ./ d_z_10);
% cum_thickness = cumsum(thickness);
% cum_N_p = int32(cumsum(double(N_p)));
% N_max = sum(N_p) + 1;

% A = zeros( M_x_max * M_y_max * N_max );
% B = zeros( M_x_max * M_y_max * N_max, 1 );

% % d_x     = d_x * 100; % 1cm
% % d_y     = d_y * 100; % 1cm
% % d_z_da  = d_z_da * 100;
% % d_z     = d_z * 100; 
% % d_z_10  = d_z_10 * 100; % 5cm

% disp('The fill up time A: ');
% tic;
% for idx = 1: 1: M_x_max * M_y_max * N_max 
%     % idx = ( ell - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_x_max + m;
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
    
%     ell_all = int32(( idx - m - ( n - 1 ) * M_x_max ) / ( M_x_max * M_y_max ) + 1);
    
%     p = get_p(ell_all, cum_N_p);
%     if p == 1
%         ell = ell_all;
%     else
%         ell = ell_all - cum_N_p(p - 1);
%     end
    
%     p0 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % center point
%     p1 = int32( ( ell_all     ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell + 1
%     p2 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m - 1 ); % m - 1
%     p3 = int32( ( ell_all - 2 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell - 1
%     p4 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m + 1 ); % m + 1
%     p5 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n     ) * M_y_max + m ); % n + 1
%     p6 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 2 ) * M_y_max + m ); % n - 1

%     p1_up   = int32( ( ell_all + 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell + 2
%     p3_down = int32( ( ell_all - 3 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell - 1

%     if (p == 9)
%         ;
%     end

%     if check_volume_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
%         A( idx, : ) = Laplace_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z );
%     end

%     if check_G_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
%         A( idx, : ) = G_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r );
%     end

%     G_line_idx = check_G_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if G_line_idx
%         A( idx, : ) = G_line_A( G_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
%     end

%     G_point_idx = check_G_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if G_point_idx
%         A( idx, : ) = G_point_A( G_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
%     end

%     CD_face_idx = check_CD_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if CD_face_idx
%         A( idx, : ) = CD_A( CD_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
%     end

%     CD_line_idx = check_CD_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if CD_line_idx
%         A( idx, : ) = CD_line_A( CD_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
%     end

%     % checked
%     Bolus_face_idx = check_bolus_face_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if Bolus_face_idx
%         A( idx, : ) = bolus_face_A( Bolus_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
%     end

%     % checked
%     Bolus_horizental_line_idx = check_bolus_horizental_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if Bolus_horizental_line_idx
%         A( idx, : ) = bolus_horizental_line_A( Bolus_horizental_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     % checked
%     bolus_point_idx = check_bolus_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if bolus_point_idx
%         A( idx, : ) = bolus_point_A( bolus_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     % checked 
%     AB_face_idx = check_AB_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if AB_face_idx
%         A( idx, : ) = AB_A( AB_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     % checked
%     AB_line_idx = check_AB_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if AB_line_idx
%         A( idx, : ) = AB_line_A( AB_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     % checked
%     air_face_idx = check_air_face_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_face_idx
%         A( idx, : ) = air_face_A( air_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
%     end

%     air_horizental_line_idx = check_air_horizental_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_horizental_line_idx
%         A( idx, : ) = air_horizental_line_A( air_horizental_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     air_point_idx = check_air_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_point_idx
%         A( idx, : ) = air_point_A( air_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     air_vertical_face_idx = check_air_vertical_face_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_vertical_face_idx
%         A( idx, : ) = air_vertical_face_A( air_vertical_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
%     end

%     air_vertical_line_idx = check_air_vertical_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_vertical_line_idx
%         A( idx, : ) = air_vertical_line_A( air_vertical_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     plate_idx = check_plate_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if plate_idx
%         switch plate_idx
%             case 1
%                 A( idx, : ) = plate_A( plate_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%                 B( idx ) = V_0;
%             case 2
%                 A( idx, : ) = plate_A( plate_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%             otherwise
%                 error('wrong');
%         end
%     end

%     top_down_bolus_idx = check_top_down_bolus_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if top_down_bolus_idx
%         A( idx, : ) = top_down_bolus_A( top_down_bolus_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     % Start from here.
%     top_down_bolus_line_idx = check_top_down_bolus_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if top_down_bolus_line_idx
%         A( idx, : ) = top_down_bolus_line_A( top_down_bolus_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     top_down_bolus_point_idx = check_top_down_bolus_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if top_down_bolus_point_idx
%         A( idx, : ) = top_down_bolus_point_A( top_down_bolus_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     top_down_air_idx = check_top_down_air_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if top_down_air_idx
%         A( idx, : ) = top_down_air_A( top_down_air_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     top_down_air_line_idx = check_top_down_air_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if top_down_air_line_idx
%         A( idx, : ) = top_down_air_line_A( top_down_air_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     top_down_air_point_idx = check_top_down_air_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if top_down_air_point_idx
%         A( idx, : ) = top_down_air_point_A( top_down_air_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end
% end
% toc;

% A_10 = zeros( M_x_max * M_y_max * ( N_max + N_10 ) );
% B_10 = zeros( M_x_max * M_y_max * ( N_max + N_10 ), 1 );

% A_10( 1: M_x_max * M_y_max * ( N_max - 1), 1: M_x_max * M_y_max * N_max ) = A( 1: M_x_max * M_y_max * ( N_max - 1), : );
% B_10( 1: M_x_max * M_y_max * ( N_max - 1) ) = B( 1: M_x_max * M_y_max * ( N_max - 1) );

% clearvars A B;

% disp('The fill up time A_10: ');
% tic;
% for idx = M_x_max * M_y_max * (N_max - 1) + 1: 1: M_x_max * M_y_max * ( N_max + N_10 )
%     % idx = ( ell - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_x_max + m;
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
    
%     ell_all = int32(( idx - m - ( n - 1 ) * M_x_max ) / ( M_x_max * M_y_max ) + 1);
    
%     if ell_all == N_max
%         p = 9;
%         ell = N_p(9) + 1;
%     else
%         p = 10;
%         ell = ell_all - cum_N_p(p - 1);
%     end
    
%     p0 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % center point
%     p1 = int32( ( ell_all     ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell + 1
%     p2 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m - 1 ); % m - 1
%     p3 = int32( ( ell_all - 2 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell - 1
%     p4 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m + 1 ); % m + 1
%     p5 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n     ) * M_y_max + m ); % n + 1
%     p6 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 2 ) * M_y_max + m ); % n - 1

%     if check_volume_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
%         A_10( idx, : ) = Laplace_10_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10 );
%     end

%     plate_10_idx = check_plate_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if plate_10_idx
%         A_10( idx, : ) = plate_10_A( plate_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%         B_10( idx ) = V_0;
%     end

%     bolus_face_10_idx = check_bolus_face_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if bolus_face_10_idx
%         A_10( idx, : ) = bolus_face_10_A( bolus_face_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     % check for the validity of bolus_horizental_line_10_A.m, I copy it directly from G_line
%     bolus_horizental_line_10_idx = check_bolus_horizental_line_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if bolus_horizental_line_10_idx
%         A_10( idx, : ) = bolus_horizental_line_10_A( bolus_horizental_line_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

% % check the validy function of the following cases
% % check whether N_10 was fed as input or not.

%     % check for the validity of bolus_point_10_A.m, I copy it directly from G_point
%     bolus_point_10_idx = check_bolus_point_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if bolus_point_10_idx
%         A_10( idx, : ) = bolus_point_10_A( bolus_point_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     % Directly copy from air face
%     air_face_10_idx = check_air_face_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_face_10_idx
%         A_10( idx, : ) = air_face_10_A( air_face_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r );
%     end

%     % directly copy from air_horizental_line
%     air_horizental_line_10_idx = check_air_horizental_line_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_horizental_line_10_idx
%         A_10( idx, : ) = air_horizental_line_10_A( air_horizental_line_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     % directly copy from air_point
%     air_point_10_idx = check_air_point_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_point_10_idx
%         A_10( idx, : ) = air_point_10_A( air_point_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end
    
%     % directly originated from air_vertical_face
%     air_vertical_faces_10_idx = check_air_vertical_faces_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_vertical_faces_10_idx
%         A_10( idx, : ) = air_vertical_faces_10_A( air_vertical_faces_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end
    
%     % directly originated from air_vertical_line
%     air_vertical_line_10_idx = check_air_vertical_line_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_vertical_line_10_idx
%         A_10( idx, : ) = air_vertical_line_10_A( air_vertical_line_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     % directly originated from top_down_air_A(v1_0)
%     if check_top_air_face_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
%         A_10( idx, : ) = top_air_face_10_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

% % mind if te first valid input a redundant or lost term.

%     top_air_horizental_line_10_idx = check_top_air_horizental_line_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if top_air_horizental_line_10_idx
%         A_10( idx, : ) = top_air_horizental_line_10_A( top_air_horizental_line_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     top_air_point_10_idx = check_top_air_point_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if top_air_point_10_idx
%         A_10( idx, : ) = top_air_point_10_A( top_air_point_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end
% % Start from here, debug and check the validity.
% % Plot the figure.
% end
% toc;

% A_da = zeros( M_x_max * M_y_max * ( N_da + N_max + N_10 ) );
% B_da = zeros( M_x_max * M_y_max * ( N_da + N_max + N_10 ), 1 );

% A_da( M_x_max * M_y_max * ( N_da + 1) + 1: M_x_max * M_y_max * ( N_da + N_max + N_10 )...
%         , M_x_max * M_y_max * N_da + 1: M_x_max * M_y_max * ( N_da + N_max + N_10 ) ) ...
%     = A_10( M_x_max * M_y_max + 1: M_x_max * M_y_max * ( N_max + N_10 ), : );
% B_da( M_x_max * M_y_max * ( N_da + 1 ) + 1: M_x_max * M_y_max * ( N_da + N_max + N_10 ) ) ...
%     = B_10( M_x_max * M_y_max + 1: M_x_max * M_y_max * ( N_max + N_10 ) );

% clearvars A_10 B_10;

% % The zero layer
% disp('The fill up time A_da: ');
% tic;
% p = 0;
% for idx = 1: 1: M_x_max * M_y_max * ( N_da + 1 )
%     % idx = ( ell - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_x_max + m;
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
    
%     ell_all = int32(( idx - m - ( n - 1 ) * M_x_max ) / ( M_x_max * M_y_max ) + 1);
%     ell = ell_all;
    
%     p0 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % center point
%     p1 = int32( ( ell_all     ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell + 1
%     p2 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m - 1 ); % m - 1
%     p3 = int32( ( ell_all - 2 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell - 1
%     p4 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m + 1 ); % m + 1
%     p5 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n     ) * M_y_max + m ); % n + 1
%     p6 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 2 ) * M_y_max + m ); % n - 1

% % Check whether the d_z_10 was replaced by d_z_da by accident during the pass in paremeter
% % check whether N_10 and N_da was feed as input in right order
% % Check the number of input parameters was correct or not: epsilon_r, epsilon_b_r, epsilon_0_r
% % If the following code are fixed, the according origin code shoulde be modified also.
% % check whether N_da was fed as input or not.

%     if check_volume_da_valid( m, n, ell, N_p, N_da, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
%         A_da( idx, : ) = Laplace_da_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da );
%     end

%     plate_da_idx = check_plate_da_valid( m, n, ell, N_p, N_da, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if plate_da_idx
%         A_da( idx, : ) = plate_da_A( plate_da_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     bolus_face_da_idx = check_bolus_face_da_valid( m, n, ell, N_p, N_da, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if bolus_face_da_idx
%         A_da( idx, : ) = bolus_face_da_A( bolus_face_da_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

% % the bolus_point.m has problem in d_z(p) v.s. d_z (p)  [spacing or not]
%     bolus_horizental_line_da_idx = check_bolus_horizental_line_da_valid( m, n, ell, N_p, N_da, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if bolus_horizental_line_da_idx
%         A_da( idx, : ) = bolus_horizental_line_da_A( bolus_horizental_line_da_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

% % the bolus_point.m has problem in d_z(p) v.s. d_z (p)  [spacing or not]
%     bolus_point_da_idx = check_bolus_point_da_valid( m, n, ell, N_p, N_da, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if bolus_point_da_idx
%         A_da( idx, : ) = bolus_point_da_A( bolus_point_da_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

% % check the validity of the following functions:
% % Check the number of input parameters are in accord with the number of number of input of each function.

%     air_face_da_idx = check_air_face_da_valid( m, n, ell, N_p, N_da, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_face_da_idx
%         A_da( idx, : ) = air_face_da_A( air_face_da_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da, epsilon_r, epsilon_b_r );
%     end

%     air_horizental_line_da_idx = check_air_horizental_line_da_valid( m, n, ell, N_p, N_da, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_horizental_line_da_idx
%         A_da( idx, : ) = air_horizental_line_da_A( air_horizental_line_da_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     air_point_da_idx = check_air_point_da_valid( m, n, ell, N_p, N_da, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_point_da_idx
%         A_da( idx, : ) = air_point_da_A( air_point_da_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     air_vertical_faces_da_idx = check_air_vertical_faces_da_valid( m, n, ell, N_p, N_da, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_vertical_faces_da_idx
%         A_da( idx, : ) = air_vertical_faces_da_A( air_vertical_faces_da_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     air_vertical_line_da_idx = check_air_vertical_line_da_valid( m, n, ell, N_p, N_da, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if air_vertical_line_da_idx
%         A_da( idx, : ) = air_vertical_line_da_A( air_vertical_line_da_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     if check_bottom_air_face_da_valid( m, n, ell, N_p, N_da, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
%         A_da( idx, : ) = bottom_air_face_da_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     bottom_air_horizental_line_da_idx = check_bottom_air_horizental_line_da_valid( m, n, ell, N_p, N_da, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if bottom_air_horizental_line_da_idx
%         A_da( idx, : ) = bottom_air_horizental_line_da_A( bottom_air_horizental_line_da_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end

%     bottom_air_point_da_idx = check_bottom_air_point_da_valid( m, n, ell, N_p, N_da, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
%     if bottom_air_point_da_idx
%         A_da( idx, : ) = bottom_air_point_da_A( bottom_air_point_da_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, N_da, d_x, d_y, d_z, d_z_da, epsilon_r, epsilon_b_r, epsilon_0_r );
%     end
% end
% toc;

% Recover the original value

% d_x     = d_x / 100; % 1cm
% d_y     = d_y / 100; % 1cm
% d_z_da  = d_z_da / 100;
% d_z     = d_z / 100; 
% d_z_10  = d_z_10 / 100; % 5cm

% Normalized each row

% % load('Preliminary_hetero_zp_da.mat');
% for idx = 1: 1: M_x_max * M_y_max * ( N_da + N_max + N_10 ) 
%     A_da( idx, : ) = A_da( idx, : ) ./ max( abs(A_da( idx, : )) );
%     B_da( idx ) = B_da( idx ) ./ max( abs(A_da( idx, : )) ); 

%     % idx = ( ell - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_x_max + m;
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
    
%     ell_all = int32(( idx - m - ( n - 1 ) * M_x_max ) / ( M_x_max * M_y_max ) + 1);

%     tmp_A_da_idx = find(A_da( idx, : ) ~= 0);
%     for idx_2 = 1: 1: length(tmp_A_da_idx)
%         if( abs( A_da( idx, tmp_A_da_idx(idx_2) ) ) < 0.001 )
%             [m, n, ell_all]
%             [ idx, tmp_A_da_idx(idx_2) ]
%         end
%     end
% end

% % Check for empty rows in A_10 - part 1
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

%     if A_10(idx, :) == zeros( 1, M_x_max * M_y_max * ( N_max + N_10 ) );
%         disp( [' Error in [ ', num2str(m), ', ', num2str(n), ', ', num2str(ell), '] in layer', num2str(p)] );
%     end
% end

% % Check for empty rows in A_10 - part 2
% for idx = M_x_max * M_y_max * (N_max - 1) + 1: 1: M_x_max * M_y_max * ( N_max + N_10 )
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
    
%     ell = ell_all - cum_N_p(9);
%     % p = get_p(ell_all, cum_N_p);
%     % if p == 1
%     %     ell = ell_all;
%     % else
%     %     ell = ell_all - cum_N_p(p - 1);
%     % end

%     if A_10(idx, :) == zeros( 1, M_x_max * M_y_max * ( N_max + N_10 ) );
%         disp( [' Error in [ ', num2str(m), ', ', num2str(n), ', ', num2str(ell), '] in layer 10'] );
%     end
% end

% % Check for empty rows in A_da - part 3
% for idx = 1: 1: M_x_max * M_y_max * ( N_da + 1 )
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
    
%     ell = ell_all;
%     % p = get_p(ell_all, cum_N_p);
%     % if p == 1
%     %     ell = ell_all;
%     % else
%     %     ell = ell_all - cum_N_p(p - 1);
%     % end

%     if A_da( idx, : ) == zeros( 1, M_x_max * M_y_max * ( N_da + N_max + N_10 ) );
%         disp( [' Error in [ ', num2str(m), ', ', num2str(n), ', ', num2str(ell), '] in layer 0'] );
%     end
% end

% load('Preliminary_hetero_zp_10.mat');
tol = 1e-10;
disp('The calculation time for conjugate method: ');
tic;
bar_x_cg_10 = conjugate_gradient( A_10, B_10, tol );
toc;


% disp('The calculation time for inverse matrix using conjugate gradient: ')
% tic;
% [bar_x_cgs, flag, relres] = cgs(A, B, 10^(-6), 20);
% toc;

% Start from here, a preonditioned matrix was needed to scale A_da.
% First, find which dimension was needed to be pre-conditioned by comparing the scaling level using two for loops.

% disp('The calculation time for inverse matrix: ');
% tic;
% bar_x_da = A_da \ B_da;
% toc;

% save('Preliminary_hetero_zp_da.mat');

% disp('The saving time: ')
% tic;
% save('Preliminary_hetero_zp_da.mat');
% toc;


% [ M_x1, M_x2, M_x3, M_x4, M_x5, M_x ];