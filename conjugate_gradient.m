function [ X_i  ] = conjugate_gradient( A, B, tol );

% Suppose \bar{A} is square and non-singular; 
% tol = tolerance level

% B = A' * B;
% A = A' * A;

X_i = B; % B - A * X_0, with X_0 = 0
R_i = zeros(size(B));
P_i = zeros(size(B));

R_i = B - A * X_i;
if norm(R_i) < tol
    return;
end

% Initialization
P_i = R_i; % P_0 = R_0
alpha_i = R_i' * R_i / ( ( P_i' * A ) * P_i );
    
size_B_1 = size(B, 1);
for idx = 1: 1: size_B_1;
    
    X_i = X_i + alpha_i * P_i;
    prev_R_i = R_i;
    R_i = R_i - alpha_i * A * P_i;

    if norm(R_i) < tol
        idx
        return;
    end

    beta_i = R_i' * R_i / ( prev_R_i' * prev_R_i );
    P_i = R_i + beta_i * P_i;

end

warning('idx exceed size of B');

end