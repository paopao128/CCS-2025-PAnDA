%% Header
addpath('./functions/');                                                    % Functions
addpath('./Dataset/'); 
addpath('./functions/myBDToolbox');                                         % My Benders decomposition toolbox
addpath('./functions/myPlotToolbox');                                       % My plot toolbox
addpath('./functions/haversine');                                          % Read the Haversine distance package. This package is created by Created by Josiah Renfree, May 27, 2010
parameters;                                                                 % Read the parameters of the simulation
env_parameters.NR_NODE_IN_TARGET=500;
%fprintf('------------------- Environment settings --------------------- \n \n'); 

% rng(0); 

%% Read the map information
%fprintf("Loading the map information ... \n")

load('rome_df_nodes.mat');
load('rome_df_edges.mat');

load('nyc_df_nodes.mat');
load('nyc_df_edges.mat');

load('london_df_nodes.mat');
load('london_df_edges.mat');
col_longitude = table2array(df_nodes(:, 'x'));                              % Actual x (longitude) coordinate from the nodes data
col_latitude = table2array(df_nodes(:, 'y'));                               % Actual y (latitude) coordinate from the nodes data
col_osmid = table2array(df_nodes(:, 'osmid'));                              % Actual unique osmid from the nodes data
env_parameters.NR_LOC = size(col_longitude, 1); 

%fprintf("The map information has been loaded. \n")
[G, u, v] = graph_preparation(df_nodes, df_edges);               % Given the map information, create the mobility graph

%fprintf("The mobility graph has been created. \n \n")


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

NR_LOC=length(col_osmid);
%node_in_target = randperm(NR_LOC, env_parameters.NR_NODE_IN_TARGET);

node_in_target = rand_sample(col_longitude,col_latitude,env_parameters);
%node_in_target = node_in_target_record{i_positionnn};
node_in_target_ori=node_in_target;


loc_x_in_target = col_longitude(node_in_target);                           
loc_y_in_target = col_latitude(node_in_target);
%fprintf('The number of nodes is %d  \n', env_parameters.NR_NODE_IN_TARGET);

%% Perturbed locations are randomly distributed over the target region
obf_loc = randperm(size(node_in_target, 2), env_parameters.NR_OBFLOC);
% data_read = load('.\Dataset\rome\intermediate\obf_loc.mat');
env_parameters.obf_loc = obf_loc;
%fprintf('The number of perturbed locations is %d  \n \n', env_parameters.NR_OBFLOC);


%% Distance matrix calculation                                                           
distance_matrix = distanceMatrix(col_longitude(node_in_target), col_latitude(node_in_target));
n = 100;
%D = rand(n); D = (D + D') / 2; D(1:n+1:end) = 0;
D = distance_matrix;
epsilon = 5;
lambda = 100;
r = 38;

%[H, M, loss] = compute_copt(D, epsilon, lambda, r, length(obf_loc));

task_loc = 2;
all_target=1:1:length(distance_matrix);
cost_matrix = costMatrix(node_in_target, task_loc, obf_loc, G, all_target, [], 2); 


D_rp=distance_matrix(:,obf_loc);
D_rr= distance_matrix;
% [H, M, expected_loss] = compute_copt3(D_rp, D_rr, cost_matrix, epsilon, lambda, r);
tic;
[H, M, expected_loss] = compute_copt3(D_rp, D_rr, cost_matrix, epsilon, r);
time_copt=toc;

loss=cost_matrix.*H;
loss=sum(loss(:));
disp("Expected max utility loss: ");
disp(loss);