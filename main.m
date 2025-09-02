%% Step 1: Please set the number of repeated experiment (NR_REPEAT) 
NR_REPEAT = 1; 

%% Step 2: Please first uncomment the corresponding line to select a dataset:

run_artifact_rome;                % Rome dataset (uniform vehicle location distribution)
run_artifact_nyc;                 % New York City dataset  (uniform vehicle location distribution)
% run_artifact_london;                % London dataset  (uniform vehicle location distribution)
run_artifact_real_distribution;   % Rome dataset (real vehicle location distribution)


%% Baseline     ----- These two methods can be run separately since their high computation time 
% run_LPEM
% run_LPBD