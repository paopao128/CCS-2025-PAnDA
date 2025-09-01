
LPCA_time = coarse_time_mean;
EMBR_time = computation_time_EMBR_mean;
PAnDAe_time = computation_time_function1_mean;
PAnDAp_time = computation_time_function2_mean;
PAnDAl_time = computation_time_function3_mean;


fprintf('Computation time of different algorithms\n')

method_width = 17;
col_width = 10;


print_line(length(num_rec), method_width, col_width);


fprintf('| %-*s ', method_width, 'Number of records');
for i = 1:length(num_rec)
    fprintf('| %*d ', col_width, num_rec(i));
end
fprintf('|\n');

print_line(length(num_rec), method_width, col_width);

% （ASCII）
print_row_fixed('EM', repmat({'<=0.005'}, 1, 6), method_width, col_width);
% print_row_fixed('LP', repmat({'>1800'}, 1, 6), method_width, col_width);
print_row_fixed('LP+CA', num2cell(LPCA_time), method_width, col_width);
% print_row_fixed('LP+BD', [num2cell(LPBD(1)) repmat({'>1800'}, 1, 5)], method_width, col_width);
% print_row_fixed('LP+EM', [num2cell(LPEM(1)) repmat({'>1800'}, 1, 5)], method_width, col_width);
print_row_fixed('EM+BR', num2cell(EMBR_time), method_width, col_width);
print_row_fixed('PAnDA-e', num2cell(PAnDAe_time), method_width, col_width);
print_row_fixed('PAnDA-p', num2cell(PAnDAp_time), method_width, col_width);
print_row_fixed('PAnDA-l', num2cell(PAnDAl_time), method_width, col_width);

print_line(length(num_rec), method_width, col_width);

% =====  =====
function print_row_fixed(name, vals, method_width, col_width)
    fprintf('| %-*s ', method_width, name);
    for j = 1:length(vals)
        if ischar(vals{j}) || isstring(vals{j})
            fprintf('| %*s ', col_width, vals{j});
        else
            fprintf('| %*.2f ', col_width, vals{j});
        end
    end
    fprintf('|\n');
end

function print_line(ncols, method_width, col_width)
    fprintf('+');
    fprintf(repmat('-', 1, method_width + 2));
    fprintf('+');
    for i = 1:ncols
        fprintf(repmat('-', 1, col_width + 2));
        fprintf('+');
    end
    fprintf('\n');
end