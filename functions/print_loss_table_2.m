function print_loss_table_2(num_rec, EM_mean, coarse_loss_mean, EMBR_mean, LPBD_first, LPEM_first, L_e, L_p, L_l)

    headers = [{'Number of records'}, arrayfun(@(x) sprintf('%g', x), num_rec, 'UniformOutput', false)];

    % Create LP+BD row: first column has value, rest are '-'
    LPBD_row = cell(1, numel(num_rec));
    LPBD_row{1} = sprintf('%.2f', LPBD_first);
    LPBD_row(2:end) = {'-'};
    
    % Create LP+EM row: first column has value, rest are '-'
    LPEM_row = cell(1, numel(num_rec));
    LPEM_row{1} = sprintf('%.2f', LPEM_first);
    LPEM_row(2:end) = {'-'};

    rows = {
        'EM',         arrayfun(@(x) sprintf('%.2f', x), EM_mean,          'UniformOutput', false);
        'LP+CA',      arrayfun(@(x) sprintf('%.2f', x), coarse_loss_mean, 'UniformOutput', false);
        'LP+BD',      LPBD_row;
        'LP+EM',      LPEM_row;
        'EM+BR',      arrayfun(@(x) sprintf('%.2f', x), EMBR_mean,        'UniformOutput', false);
        'loss(PAnDA-e)', arrayfun(@(x) sprintf('%.2f', x), L_e,           'UniformOutput', false);
        'loss(PAnDA-p)', arrayfun(@(x) sprintf('%.2f', x), L_p,           'UniformOutput', false);
        'loss(PAnDA-l)', arrayfun(@(x) sprintf('%.2f', x), L_l,           'UniformOutput', false);
    };


    table_cells = cell(size(rows,1)+1, numel(num_rec)+1);
    table_cells(1,1) = {headers{1}};
    table_cells(1,2:end) = headers(2:end);
    for r = 1:size(rows,1)
        table_cells(r+1,1) = rows(r,1);
        table_cells(r+1,2:end) = rows{r,2};
    end


    nCols = size(table_cells,2);
    colw = zeros(1,nCols);
    for c = 1:nCols
        colw(c) = max(cellfun(@(s) strlength(string(s)), table_cells(:,c)));
    end


    function print_sep()
        fprintf('+');
        for c = 1:nCols
            fprintf('%s+', repmat('-', 1, colw(c)+2));
        end
        fprintf('\n');
    end


   
    print_sep();
    for r = 1:size(table_cells,1)
        fprintf('|');
        for c = 1:nCols

            cellstr = char(string(table_cells{r,c}));
            fprintf([' %-' num2str(colw(c)) 's |'], cellstr);
        end
        fprintf('\n');
        if r==1 || r==size(table_cells,1)
            print_sep();
        end
    end
end