%% Header
addpath('./functions/');                                                    % Functions
addpath('./Dataset/'); 
addpath('./functions/myBDToolbox');                                         % My Benders decomposition toolbox
addpath('./functions/myPlotToolbox');                                       % My plot toolbox
addpath('./functions/haversine');                                          % Read the Haversine distance package. This package is created by Created by Josiah Renfree, May 27, 2010
parameters;                                                                 % Read the parameters of the simulation
env_parameters.NR_NODE_IN_TARGET=500;
%fprintf('------------------- Environment settings --------------------- \n \n'); 

%% Read the map information

load('rome_df_nodes.mat');
load('rome_df_edges.mat');

% load('nyc_df_nodes.mat');
% load('nyc_df_edges.mat');

% load('london_df_nodes.mat');
% load('london_df_edges.mat');

col_longitude = table2array(df_nodes(:, 'x'));                              % Actual x (longitude) coordinate from the nodes data
col_latitude = table2array(df_nodes(:, 'y'));                               % Actual y (latitude) coordinate from the nodes data
freq=table2array(df_nodes(:, 'street_count'));                          
env_parameters.NR_LOC = size(col_longitude, 1); 


[G, u, v] = graph_preparation(df_nodes, df_edges);               % Given the map information, create the mobility graph




max_longitude = max(col_longitude); 
min_longitude = min(col_longitude); 
LONGITUDE_SIZE = max_longitude - min_longitude; 

max_latitude = max(col_latitude);   
min_latitude = min(col_latitude);  
LATITUDE_SIZE = max_latitude - min_latitude; 


center_longitude = min_longitude + LONGITUDE_SIZE / 2;
center_latitude = min_latitude + LATITUDE_SIZE / 2;


target_longitude_half_size = LONGITUDE_SIZE / (2 * env_parameters.REGION_SCALE);
target_latitude_half_size = LATITUDE_SIZE / (2 * env_parameters.REGION_SCALE);


TARGET_LONGITUDE_MIN = center_longitude - target_longitude_half_size;
TARGET_LONGITUDE_MAX = center_longitude + target_longitude_half_size;
TARGET_LATITUDE_MIN = center_latitude - target_latitude_half_size;
TARGET_LATITUDE_MAX = center_latitude + target_latitude_half_size;


formatSpec = ['The target region is created: \n', ...
    'South-west corner coordinate: (latitude = %f, longitude = %f) \n', ...
    'North-east corner coordinate: (latitude = %f, longitude = %f) \n'];


%fprintf(formatSpec, TARGET_LATITUDE_MIN, TARGET_LONGITUDE_MIN, TARGET_LATITUDE_MAX, TARGET_LONGITUDE_MAX);




%% Find the set of nodes in the target region

NR_LOC=length(col_latitude);
node_in_target = randperm(NR_LOC, env_parameters.NR_NODE_IN_TARGET);
freq=freq(node_in_target);
node_in_target_ori=node_in_target;


loc_x_in_target = col_longitude(node_in_target);                           
loc_y_in_target = col_latitude(node_in_target);
%fprintf('The number of nodes is %d  \n', env_parameters.NR_NODE_IN_TARGET);

%% Perturbed locations are randomly distributed over the target region
obf_loc = randperm(size(node_in_target, 2), env_parameters.NR_OBFLOC);

env_parameters.obf_loc = obf_loc;
%fprintf('The number of perturbed locations is %d  \n \n', env_parameters.NR_OBFLOC);


%% Distance matrix calculation                                                           
distance_matrix = distanceMatrix(col_longitude(node_in_target), col_latitude(node_in_target));
distance_matrix_original=distance_matrix;
adjacence_matrix = heaviside(1 - distance_matrix/env_parameters.NEIGHBOR_THRESHOLD);       % Create the adjacency matrix. 
adjacence_matrix_original=adjacence_matrix;
mDPMatrix = adjacence_matrix.*distance_matrix;                              % Create the mDP matrix. 
mDPGraph = graph(mDPMatrix);                                                % Create the mDP graph using the mDP matrix
% path_distance_matrix = distances(mDPGraph);                                 % Calculate the path distance using the mDP graph









task_loc = 2;





%% Benders

env_parameters.cost_matrix = costMatrix(node_in_target_ori, task_loc, obf_loc, G, 1:length(node_in_target_ori), [], 2);
cluster_idx = kmeans(distance_matrix_original, env_parameters.NR_AGENT);
zeros_matrix=sparse(length(distance_matrix_original),length(distance_matrix_original));
tic;
agent_benders = agentCreation(cluster_idx, node_in_target_ori, adjacence_matrix_original, distance_matrix_original, env_parameters.NR_AGENT, env_parameters.NR_NODE_IN_TARGET, env_parameters.NR_OBFLOC, env_parameters.EPSILON, zeros_matrix, zeros_matrix); 
fprintf('%d agents have been created. \n', env_parameters.NR_AGENT); 

% Create the master agent
fprintf('------------------- Create the agents ----------------------- \n'); 

% Initialize the master agent
masteragent  = masterAgentCreation(distance_matrix_original, agent_benders, adjacence_matrix_original, cluster_idx, env_parameters.NR_NODE_IN_TARGET, env_parameters.NR_OBFLOC, env_parameters.NR_AGENT, env_parameters.EPSILON, zeros_matrix, zeros_matrix); 
time2_LB=toc;


% The algorithm starts here!!
tic;
ITER = 100; 
[~, ~, lowerbound_benders, upperbound_benders, upperbound__benders, loss_benders, obf_matrix_benders] = bendersDecomposition(masteragent, agent_benders, env_parameters, ITER); 

time_benders=toc;

loss_matrix_benders=env_parameters.cost_matrix.*obf_matrix_benders;
loss_benders=sum(loss_matrix_benders(:));
