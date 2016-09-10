function [ p ] = get_p( ell_all, cum_N_p )

p = 0;

for idx = 1: 1: length(cum_N_p)
    if ell_all <= cum_N_p(idx) + 1
        p = idx;
        return;
    end
end
    warning('wrong p');
end

