clc; clear;
digits;
N = int32(9); % [ bolus, skin, muscle, lung, tumor, lung, muscle, skin, bolus ]

Mu_0        = 4 * pi * 10^(-7);
Epsilon_0   = 10^(-9) / (36 * pi);
Omega_0     = 2 * pi * 10 * 10^6; % 2 * pi * 2.45 GHz

V_0         = 126;
% thickness   = [ 2.5, 0.02, 3.53, 1.00, 2.75, 14.62, 2.91, 0.19, 2.5 ]' ./ 100; % cm -> m, total = 31 cm
thickness   = [ 2.0, 0.02, 3.5, 1.00, 2.8, 15, 3, 0.2, 2.0 ]' ./ 100; % cm -> m, total = 31 cm
thickness_10 = 5 / 100; % 15 cm
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
w_0         = 12 / 100; % 60 cm
w           = 4 / 100; % 30 cm
x_0         = ( w_0 - w ) / 2;
h_b         = thickness(1); % thickness of the bolus 
d_x         = 1 / 100; % 1cm
d_y         = 1 / 100; % 1cm
% d_z         = 1 / 100 * ones(N, 1); % 1cm 
d_z = [ 0.5, 0.01, 0.5, 0.5, 1.4, 5, 1, 0.1, 0.5 ]' ./ 100; % 0.1cm
d_z_10 = 1 ./ 100; % 5cm

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

N_p  = int32(thickness ./ d_z);
N_10 = int32(thickness_10 ./ d_z_10);
cum_thickness = cumsum(thickness);
cum_N_p = int32(cumsum(double(N_p)));
N_max = sum(N_p) + 1;

% A = zeros( M_x_max * M_y_max * N_max );
A_sparse = cell(M_x_max * M_y_max * N_max, 1);
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

% check for: 
% 1. A_row = zeros(1, 12); --> the number of elements in the initialization of each functions.
% 2. The assignment like: A_row(11) = A_row( 10 ); may be mistransplant.


% Data structure: A{ idx } == [ position_1, position_2, ..., value_1, value_2, ... ];

    if check_volume_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
        A_sparse{ idx } = Laplace_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z );
    end

    if check_G_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
        A_sparse{ idx } = G_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r );
    end

    G_line_idx = check_G_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if G_line_idx
        A_sparse{ idx } = G_line_A( G_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    G_point_idx = check_G_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if G_point_idx
        A_sparse{ idx } = G_point_A( G_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    CD_face_idx = check_CD_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if CD_face_idx
        A_sparse{ idx } = CD_A( CD_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    CD_line_idx = check_CD_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if CD_line_idx
        A_sparse{ idx } = CD_line_A( CD_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    % checked
    Bolus_face_idx = check_bolus_face_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if Bolus_face_idx
        A_sparse{ idx } = bolus_face_A( Bolus_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    % checked
    Bolus_horizental_line_idx = check_bolus_horizental_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if Bolus_horizental_line_idx
        A_sparse{ idx } = bolus_horizental_line_A( Bolus_horizental_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % checked
    bolus_point_idx = check_bolus_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if bolus_point_idx
        A_sparse{ idx } = bolus_point_A( bolus_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % checked 
    AB_face_idx = check_AB_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if AB_face_idx
        A_sparse{ idx } = AB_A( AB_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % checked
    AB_line_idx = check_AB_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if AB_line_idx
        A_sparse{ idx } = AB_line_A( AB_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % checked
    air_face_idx = check_air_face_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_face_idx
        A_sparse{ idx } = air_face_A( air_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    air_horizental_line_idx = check_air_horizental_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_horizental_line_idx
        A_sparse{ idx } = air_horizental_line_A( air_horizental_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    air_point_idx = check_air_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_point_idx
        A_sparse{ idx } = air_point_A( air_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    air_vertical_face_idx = check_air_vertical_face_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_vertical_face_idx
        A_sparse{ idx } = air_vertical_face_A( air_vertical_face_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r );
    end

    air_vertical_line_idx = check_air_vertical_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_vertical_line_idx
        A_sparse{ idx } = air_vertical_line_A( air_vertical_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    plate_idx = check_plate_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if plate_idx
        switch plate_idx
            case 1
                A_sparse{ idx } = plate_A( plate_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
                B( idx ) = V_0;
            case 2
                A_sparse{ idx } = plate_A( plate_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
            otherwise
                warning('wrong');
        end
    end

    top_down_bolus_idx = check_top_down_bolus_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_down_bolus_idx
        A_sparse{ idx } = top_down_bolus_A( top_down_bolus_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % Start from here.
    top_down_bolus_line_idx = check_top_down_bolus_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_down_bolus_line_idx
        A_sparse{ idx } = top_down_bolus_line_A( top_down_bolus_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    top_down_bolus_point_idx = check_top_down_bolus_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_down_bolus_point_idx
        A_sparse{ idx } = top_down_bolus_point_A( top_down_bolus_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    top_down_air_idx = check_top_down_air_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_down_air_idx
        A_sparse{ idx } = top_down_air_A( top_down_air_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    top_down_air_line_idx = check_top_down_air_line_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_down_air_line_idx
        A_sparse{ idx } = top_down_air_line_A( top_down_air_line_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    top_down_air_point_idx = check_top_down_air_point_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_down_air_point_idx
        A_sparse{ idx } = top_down_air_point_A( top_down_air_point_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
    end
end
toc;

% save('tmp_sparse_A.mat');
% load('tmp_sparse_A.mat');
% % r1 = rand(size(B));
% % % Test
% % tilde_b_my_ast = A_ast_b( A_sparse, r1 );
% % load('Preliminary_hetero_zp_10.mat');
% % tilde_b = A * r1;
% % diff_x = tilde_b_my_ast - tilde_b;


% A_10 = zeros( M_x_max * M_y_max * ( N_max + N_10 ) );
A_10_sparse = cell(M_x_max * M_y_max * ( N_max + N_10 ), 1);
B_10 = zeros( M_x_max * M_y_max * ( N_max + N_10 ), 1 );

A_10_sparse( 1: M_x_max * M_y_max * ( N_max - 1) ) = A_sparse( 1: M_x_max * M_y_max * ( N_max - 1) );
B_10( 1: M_x_max * M_y_max * ( N_max - 1) ) = B( 1: M_x_max * M_y_max * ( N_max - 1) );

for idx = M_x_max * M_y_max * (N_max - 1) + 1: 1: M_x_max * M_y_max * ( N_max + N_10 )
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
    
    if ell_all == N_max
        p = 9;
        ell = N_p(9) + 1;
    else
        p = 10;
        ell = ell_all - cum_N_p(p - 1);
    end
    
    p0 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % center point
    p1 = int32( ( ell_all     ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell + 1
    p2 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m - 1 ); % m - 1
    p3 = int32( ( ell_all - 2 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m ); % ell - 1
    p4 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 1 ) * M_y_max + m + 1 ); % m + 1
    p5 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n     ) * M_y_max + m ); % n + 1
    p6 = int32( ( ell_all - 1 ) * M_x_max * M_y_max + ( n - 2 ) * M_y_max + m ); % n - 1

    if check_volume_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
        A_10_sparse{ idx } = Laplace_10_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10 );
    end

    plate_10_idx = check_plate_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if plate_10_idx
        A_10_sparse{ idx } = plate_10_A( plate_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, epsilon_r, epsilon_b_r, epsilon_0_r );
        B_10( idx ) = V_0;
    end

    bolus_face_10_idx = check_bolus_face_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if bolus_face_10_idx
        A_10_sparse{ idx } = bolus_face_10_A( bolus_face_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r );
    end

    % check for the validity of bolus_horizental_line_10_A.m, I copy it directly from G_line
    bolus_horizental_line_10_idx = check_bolus_horizental_line_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if bolus_horizental_line_10_idx
        A_10_sparse{ idx } = bolus_horizental_line_10_A( bolus_horizental_line_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % check for the validity of bolus_point_10_A.m, I copy it directly from G_point
    bolus_point_10_idx = check_bolus_point_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if bolus_point_10_idx
        A_10_sparse{ idx } = bolus_point_10_A( bolus_point_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % Directly copy from air face
    air_face_10_idx = check_air_face_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_face_10_idx
        A_10_sparse{ idx } = air_face_10_A( air_face_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r );
    end

    % directly copy from air_horizental_line
    air_horizental_line_10_idx = check_air_horizental_line_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_horizental_line_10_idx
        A_10_sparse{ idx } = air_horizental_line_10_A( air_horizental_line_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % directly copy from air_point
    air_point_10_idx = check_air_point_10_valid( m, n, ell, N_p, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_point_10_idx
        A_10_sparse{ idx } = air_point_10_A( air_point_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
    end
    
    % directly originated from air_vertical_face
    air_vertical_faces_10_idx = check_air_vertical_faces_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_vertical_faces_10_idx
        A_10_sparse{ idx } = air_vertical_faces_10_A( air_vertical_faces_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
    end
    
    % directly originated from air_vertical_line
    air_vertical_line_10_idx = check_air_vertical_line_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if air_vertical_line_10_idx
        A_10_sparse{ idx } = air_vertical_line_10_A( air_vertical_line_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    % directly originated from top_down_air_A(v1_0)
    if check_top_air_face_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 )
        A_10_sparse{ idx } = top_air_face_10_A( p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

% % mind if te first valid input a redundant or lost term.

    top_air_horizental_line_10_idx = check_top_air_horizental_line_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_air_horizental_line_10_idx
        A_10_sparse{ idx } = top_air_horizental_line_10_A( top_air_horizental_line_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
    end

    top_air_point_10_idx = check_top_air_point_10_valid( m, n, ell, N_p, N_10, p, M_x, M_x1, M_x2, M_x3, M_x4, M_x5, M_y, M_y1, M_y2, M_y3, M_y4, M_y5 );
    if top_air_point_10_idx
        A_10_sparse{ idx } = top_air_point_10_A( top_air_point_10_idx, p, p0, p1, p2, p3, p4, p5, p6, M_x_max, M_y_max, N_max, N_10, d_x, d_y, d_z, d_z_10, epsilon_r, epsilon_b_r, epsilon_0_r );
    end
% Start from here, debug and check the validity.
end

% % Normalize each rows
% for idx = 1: 1: M_x_max * M_y_max * ( N_max + N_10 ) 
%     tmp_vector = A_10_sparse{ idx };
%     num = int8(size(tmp_vector, 2)) / 2;
%     MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
%     tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
%     A_10_sparse{ idx } = tmp_vector;
%     B_10( idx ) = B_10( idx ) ./ MAX_row_value;
% end

% save('tmp_sparse_A_10.mat');
load('tmp_sparse_A_10.mat');
% save('Preliminary_hetero_zp_10.mat');
% load('Preliminary_hetero_zp_10.mat');

tol = 1e-6;
ext_itr_num = 20;
int_itr_num = 20;
x_zero = B_10;
% % % M1 = diag([10:-1:1 1 1:10]);
tic;
bar_x_my_gmres = GMRES_test( A_10_sparse, B_10, ext_itr_num, int_itr_num, tol, x_zero );
toc;

cross_section_test_gmres;

% % tic;
% % x_matlab_gmres = gmres(A_10, B_10, int_itr_num, tol, ext_itr_num);
% % toc;

% % tol = 1e-10;
% % tmp_B_10 = A_10' * B_10;
% % tmp_A_10 = A_10' * A_10;
% % bar_x_cg_t = conjugate_gradient(tmp_A_10, tmp_B_10, tol);

% disp('The calculation time for inverse matrix: ');
% tic;
% bar_x_10 = A_10 \ B_10;
% toc;

% % ratio_matlab = 100 * norm( bar_x_10 - x_matlab_gmres ) / norm(bar_x_10)
% ratio_my_gmres = 100 * norm( bar_x_10 - bar_x_my_gmres ) / norm(bar_x_10)

% % disp('The saving time: ')
% % tic;
% % save('Preliminary_hetero_zp_10.mat');
% % toc;