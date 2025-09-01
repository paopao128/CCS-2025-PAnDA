function [agent, violation, nr_violation]= agentLP(agent, distance_matrix, cost_matrix, NR_OBFLOC, Z, EPSILON, ALPHA)
    
    NR_LOC_IN_AGENT = size(agent.node, 2);
    %% Formulate the linear programming problem

    cost_matrix_ = cost_matrix(agent.node', :); 
    cost_vector = reshape(cost_matrix_', 1, NR_LOC_IN_AGENT*NR_OBFLOC); 

    A = full(agent.GeoI); 
    b = zeros(size(A, 1), 1); 

    Aeq = sparse(NR_LOC_IN_AGENT, NR_LOC_IN_AGENT*NR_OBFLOC); 
    beq = ones(NR_LOC_IN_AGENT, 1); 
    
    for k = 1:1:NR_LOC_IN_AGENT
        for l = 1:1:NR_OBFLOC
            Aeq(k, (k-1)*NR_OBFLOC + l) = 1;
        end
    end   
	lb = ones(NR_LOC_IN_AGENT*NR_OBFLOC, 1)*0.0000;
    ub = ones(NR_LOC_IN_AGENT*NR_OBFLOC, 1);

    violation = 0; 
    nr_violation = 0; 
    cost_vector_adjust = zeros(1, NR_LOC_IN_AGENT*NR_OBFLOC); 
    for i = 1:1:size(agent.interset, 1)
        for k = 1:1:NR_OBFLOC
            node_i = find(agent.node == agent.interset(i,1)); 
            if Z(agent.interset(i,1), k) < exp(-EPSILON*distance_matrix(agent.interset(i,1), agent.interset(i,2)))*Z(agent.interset(i,2), k)
                cost_vector_adjust((node_i-1)*NR_OBFLOC+k) = cost_vector_adjust((node_i-1)*NR_OBFLOC+k)...
                    + ALPHA*(Z(agent.interset(i,1), k) - exp(-EPSILON*distance_matrix(agent.interset(i,1), agent.interset(i,2)))*Z(agent.interset(i,2), k));
                violation = violation + abs(Z(agent.interset(i,1), k) - exp(-EPSILON*distance_matrix(agent.interset(i,1), agent.interset(i,2)))*Z(agent.interset(i,2), k)); 
                nr_violation = nr_violation+1; 
            end
            if Z(agent.interset(i,1), k) > exp(EPSILON*distance_matrix(agent.interset(i,1), agent.interset(i,2)))*Z(agent.interset(i,2), k)
                cost_vector_adjust((node_i-1)*NR_OBFLOC+k) = cost_vector_adjust((node_i-1)*NR_OBFLOC+k)...
                    + ALPHA*(Z(agent.interset(i,1), k) - exp(EPSILON*distance_matrix(agent.interset(i,1), agent.interset(i,2)))*Z(agent.interset(i,2), k));
                violation = violation + abs(Z(agent.interset(i,1), k) - exp(-EPSILON*distance_matrix(agent.interset(i,1), agent.interset(i,2)))*Z(agent.interset(i,2), k)); 
                nr_violation = nr_violation+1; 
            end
        end
    end
    agent.cost_vector = max(agent.cost_vector + cost_vector_adjust, zeros(1, NR_LOC_IN_AGENT*NR_OBFLOC));

    options = optimoptions('linprog','Algorithm','dual-simplex');
    % cost_vector = abs(normrnd(3,10,[2500,1])); 
    z = linprog(agent.cost_vector, A, b, full(Aeq), beq, lb, ub, options);
    agent.decision = reshape(z, NR_OBFLOC, NR_LOC_IN_AGENT); 
end