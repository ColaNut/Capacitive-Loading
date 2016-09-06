function [ x ] = GMRES_test( A, b, ext_itr_num, int_itr_num, tol, x_0 )

% Start from the slide and the template.pdf

b_size = size(b, 1);
x = zeros(size(b));

for j = 1: 1: ext_itr_num
    v = zeros(b_size, int_itr_num + 1);
    s = zeros(int_itr_num + 1, 1);
    h = zeros(int_itr_num + 1, int_itr_num);
    cos_i = zeros(int_itr_num, 1);
    sin_i = zeros(int_itr_num, 1);

    r = b - A * x_0;
    flag = false;
    v(:, 1) = r ./ norm(r);
    s(1) = norm(r);

    for i = 1: 1: int_itr_num
        w = A * v(:, i);
        for k = 1: 1: i
            h(k, i) = w' * v(:, k);
            w = w - h(k, i) * v(:, k);
        end
        h(i + 1, i) = norm(w);
        v(:, i + 1) = w ./ h(i + 1, i);

        % update the cos ( theta_i ) and the sin ( theta_i )

        for k_2 = 1: 1: i
            if k_2 == i
                cos_i(i) = cos_i_func( h(i, i), h(i + 1, i) );
                sin_i(i) = sin_i_func( h(i, i), h(i + 1, i) );
            end
            tmp_h_1 = h(k_2, i);
            h(k_2, i) = cos_i(k_2) * h(k_2, i) + sin_i(k_2) * h(k_2 + 1, i);
            h(k_2 + 1, i) = - sin_i(k_2) * tmp_h_1 + cos_i(k_2) * h(k_2 + 1, i);
        end
        
        tmp_s1 = s(i);
        s(i) = cos_i(i) * s(i);
        s(i + 1) = - sin_i(i) * tmp_s1 + cos_i(i) * s(i + 1);

        if abs(s(i + 1)) < tol
            % check whether s ( i + 1 ) < tol, then ( b - A * tilde_x ) < tol.
            [x, flag] = UPDATE( i, h, s, tol, v, A, b, x_0 );
            disp( ['The residual is ', num2str(s(i + 1))] );
            break;
        end
    end

    [x_0, flag] = UPDATE( int_itr_num, h, s, tol, v, A, b, x_0 );
    if flag == true
        x = x_0;
        break;
    end

    if j == ext_itr_num
        x = x_0;
    end
end

warning( ['The GMRES cannot find the solution wihthin ', num2str(ext_itr_num), ' times, where the inner iteration number is ', num2str(int_itr_num)] );
disp( ['The residual is ', num2str( norm(b - A * x_0) )] );

end