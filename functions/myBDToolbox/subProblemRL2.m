function [agent, agentAward] = subProblemRL2(agent, cost_matrix, NR_OBFLOC, Z, agentAward) 
    NR_NODE = size(agent.node, 2); 
    NR_NODE_INTRASET = size(agent.node_intraset, 2); 
    NR_NODE_INTERSET = size(agent.node_interset, 2)*size(agent.node_interset, 1); 


    extreme_idx = 0; 
    % agent.isunbounded = 0; 
    agent.isupdated = 0; 
    agent.decision = []; 
    y = Z(agent.node_interset',:); 
    y = reshape(y', NR_NODE_INTERSET*NR_OBFLOC, 1);

    c = cost_matrix(agent.node_intraset', :);
    c = reshape(c', NR_NODE_INTRASET*NR_OBFLOC, 1); 
    d = cost_matrix(agent.node_interset', :); 
    d = reshape(d', NR_NODE_INTERSET*NR_OBFLOC, 1);


    A_dp = agent.GeoI(:, 1:NR_NODE_INTRASET*NR_OBFLOC);
    B_dp = agent.GeoI(:, NR_NODE_INTRASET*NR_OBFLOC+1:(NR_NODE_INTRASET+NR_NODE_INTERSET)*NR_OBFLOC);

    A_um = sparse(NR_NODE_INTRASET, NR_NODE_INTRASET*NR_OBFLOC); 

    for k = 1:1:NR_NODE_INTRASET
        for l = 1:1:NR_OBFLOC
            A_um(k, (k-1)*NR_OBFLOC + l) = 1;
        end
    end   
    A_I = -eye(NR_NODE_INTRASET*NR_OBFLOC, NR_NODE_INTRASET*NR_OBFLOC);

    zero_s = zeros(size(agent.GeoI, 1), 1); 
    zero_y = sparse(NR_NODE_INTRASET, NR_NODE_INTERSET*NR_OBFLOC);
    zero_I = sparse(NR_NODE_INTRASET*NR_OBFLOC, NR_NODE_INTERSET*NR_OBFLOC);

    ones_x = ones(NR_NODE_INTRASET, 1);

    b_I = -ones(NR_NODE_INTRASET*NR_OBFLOC, 1)*0.0001;

	lb = zeros(NR_NODE_INTRASET*NR_OBFLOC, 1);
    ub = [];

    
    A = [-A_dp; -A_um; A_um];
    B = [-B_dp; zero_y; zero_y]; 
    b = [zero_s; -ones_x; ones_x];
    

    %% Primal problem
    % options = optimoptions('linprog','Algorithm','dual-simplex', 'Display', 'off');
    % options = optimoptions('linprog','Algorithm','dual-simplex');
    % options.MaxIterations = 10000; 
    % % cost_vector = abs(normrnd(3,10,[2500,1])); 
    % [z, pfval, exitflag] = linprog(c, -A, -(b-B*y), [], [], lb, ub, options);
    % if exitflag == 1
    %     agent.decision = reshape(z, NR_OBFLOC, NR_NODE_INTRASET); 
    %     agent.decision = agent.decision';
    % end

    %% Dual problem
    
    % I_x = sparse(NR_NODE_INTRASET, NR_NODE_INTRASET*NR_OBFLOC); 
    % for k = 1:1:NR_NODE_INTRASET
    %     for l = 1:1:NR_OBFLOC
    %         I_x(k, (k-1)*NR_OBFLOC + l) = 1;
    %     end
    % end  
    % 
    % zero_x = sparse(NR_NODE_INTERSET, NR_NODE_INTRASET*NR_OBFLOC); 
    % I_y = sparse(NR_NODE_INTERSET, NR_NODE_INTERSET*NR_OBFLOC); 
    % for k = 1:1:NR_NODE_INTERSET
    %     for l = 1:1:NR_OBFLOC
    %         I_y(k, (k-1)*NR_OBFLOC + l) = 1;
    %     end
    % end  

    
    % f_dual = [[zero_s; -ones_x; ones_x] - [-B; zero_y; zero_y]*y]'; 
    % f_dual = [zero_s + B*y; -ones_x*1.001; ones_x*0.999]'; 
    % cost_matrix_dual = [-A; -I_x; I_x]'; 
    lb = zeros(size(A, 1), 1);
    ub = [];

    options = optimoptions('linprog', 'Algorithm', 'dual-simplex');
    options.MaxIterations = 10000; 
    [u, fval, exitflag, ~, ~] = linprog(-(b-B*y), A', c, [], [], lb, ub, options); 

    if exitflag == -3
        agent.isunbounded = 1; 
        agent.upperbound = 9999;
        agent.idx
        size(agent.extremerays)
        result_instant = (b-B*y)'*agent.extremerays; 
        result_instant_ = find(result_instant>0); 
        if size(result_instant_, 2) > 0 
            [~, extreme_idx] = max(agentAward.reward(result_instant_)); 
            u = agent.extremerays(:, result_instant_(1, extreme_idx));
            agent.extremerays(:, result_instant_(1, extreme_idx)) = agent.extremerays(:, result_instant_(1, extreme_idx))*0;
        else
            options = optimoptions('linprog', 'Algorithm', 'dual-simplex');
            options.MaxIterations = 10000; 
            [u, ~, ~, ~, ~] = linprog([], A', zeros(size(c)), (b-B*y)', 1, lb, ub, options);
            u = u/sqrt(sum(u.^2));
        end
        
        agent.new_cut_A_unbounded = -u'*B; 
        agent.new_cut_b_unbounded = -u'*b; 
        agent.new_cut_A_bounded = []; 
        agent.new_cut_b_bounded = [];
    else 

        % if pfval ~= fval
        %     a = 0; 
        % end
        agent.upperbound = -fval+d'*y;
        % agent.upperbound = pfval+d'*y;
        agent.isunbounded = 0;    
        % if -fval + d'*y > agent.z
        if -fval + d'*y > agent.z
            agent.isupdated = 1;
            agent.new_cut_A_bounded = d'-u'*B;
            agent.new_cut_b_bounded =  - u'*b;
        else
            agent.isupdated = 0;
            agent.new_cut_A_bounded = [];
            agent.new_cut_b_bounded = [];
        end
        
        agent.new_cut_A_unbounded = [];
        agent.new_cut_b_unbounded = [];
    end
     
end