function [H, M, expected_loss] = compute_copt3(D_rp, D_rr, loss_matrix, epsilon, r)
    [n, m] = size(D_rp);       % n real locations, m perturbed locations
    N = n * m;
    Y_start = N + 1;
    Y_end = Y_start + m - 1;
    total_vars = Y_end;

    %% Build r-nearest neighbors I(v)
    I = cell(m, 1);
    for v = 1:m
        [~, idx] = sort(D_rp(:, v));
        I{v} = idx(1:r);
    end

    %% LP inequality constraints: mDP within I(v)
    rows = []; cols = []; vals = []; b = [];
    row_count = 0;

    for w = 1:m
        Iw = I{w};
        for i = 1:length(Iw)
            u = Iw(i);
            for j = 1:length(Iw)
                v = Iw(j);
                if u ~= v
                    row_count = row_count + 1;
                    idx_uw = sub2ind([n, m], u, w);
                    idx_vw = sub2ind([n, m], v, w);
                    rows(end+1) = row_count; cols(end+1) = idx_uw; vals(end+1) = 1;
                    rows(end+1) = row_count; cols(end+1) = idx_vw; vals(end+1) = -min(exp(epsilon * D_rr(u, v)), 1e10);
                    b(end+1, 1) = 0;
                end
            end
        end
    end

    %% Equality constraints: row stochasticity
    Aeq_rows = []; Aeq_cols = []; Aeq_vals = []; beq = [];
    row_eq = 0;

    for u = 1:n
        row_eq = row_eq + 1;
        for v = 1:m
            idx_uv = sub2ind([n, m], u, v);
            if ismember(u, I{v})
                Aeq_rows(end+1) = row_eq;
                Aeq_cols(end+1) = idx_uv;
                Aeq_vals(end+1) = 1;
            else
                y_idx = Y_start + v - 1;
                decay = exp(-min(epsilon * D_rp(u, v), 10));
                Aeq_rows(end+1) = row_eq;
                Aeq_cols(end+1) = y_idx;
                Aeq_vals(end+1) = decay;
            end
        end
        beq(end+1, 1) = 1;
    end

    %% Equality constraints: M(u,v) = Y(v) * decay for u ∉ I(v)
    for v = 1:m
        u_not_in_I = setdiff(1:n, I{v});
        for u = u_not_in_I
            row_eq = row_eq + 1;
            idx_uv = sub2ind([n, m], u, v);
            y_idx = Y_start + v - 1;
            decay = exp(-min(epsilon * D_rp(u, v), 10));

            Aeq_rows(end+1) = row_eq; Aeq_cols(end+1) = idx_uv; Aeq_vals(end+1) = 1;
            Aeq_rows(end+1) = row_eq; Aeq_cols(end+1) = y_idx; Aeq_vals(end+1) = -decay;
            beq(end+1, 1) = 0;
        end
    end

    %% Objective: expected utility loss
    f = zeros(total_vars, 1);
    for u = 1:n
        for v = 1:m
            idx_uv = sub2ind([n, m], u, v);
            f(idx_uv) = loss_matrix(u, v);
        end
    end

    %% Solve LP
    A = sparse(rows, cols, vals, row_count, total_vars);
    Aeq = sparse(Aeq_rows, Aeq_cols, Aeq_vals, row_eq, total_vars);
    lb = zeros(total_vars, 1);

    options = optimoptions('linprog', 'Display', 'none', 'Algorithm', 'dual-simplex');
    [x, ~, exitflag] = linprog(f, A, b, Aeq, beq, lb, [], options);

    if exitflag ~= 1
        error('LP did not converge.');
    end

    %% Reconstruct M and H
    M_opt = reshape(x(1:N), n, m);
    Y = x(Y_start:Y_end);

    M = zeros(n, m);
    for u = 1:n
        for v = 1:m
            if ismember(u, I{v})
                M(u, v) = M_opt(u, v);
            else
                M(u, v) = Y(v) * exp(-epsilon * D_rp(u, v));
            end
        end
    end

    H = zeros(n, m);
    for u = 1:n
        row_sum = sum(M(u, :));
        if row_sum > 0
            H(u, :) = M(u, :) / row_sum;
        else
            H(u, :) = ones(1, m) / m;
        end
    end

    %% Compute expected loss
    expected_loss = sum(sum(H .* loss_matrix));
end
