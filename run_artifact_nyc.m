addpath('./functions/'); 
num_rec=[500,1000,2000,3000,4000,5000];
% num_rec=[500,600,700,800,900,1000]/2;
repeat_times=NR_REPEAT;
real=2;
fprintf('nyc function1: \n');
main_func1_10times_nyc;
fprintf('nyc function2: \n');
main_func2_10times_nyc;
fprintf('nyc function3: \n');
main_func3_10times_nyc;
coarse_loss=zeros(length(num_rec),repeat_times);
coarse_time=zeros(length(num_rec),repeat_times);
coarse_vio=zeros(length(num_rec),repeat_times);
fprintf('nyc LPCA: \n');
for id_num_rec=1:6
    for id_repeat_times=1:repeat_times
        coarse_figure12_nyc;
        coarse_loss(id_num_rec,id_repeat_times)=loss_coarse;
        coarse_vio(id_num_rec,id_repeat_times)=vio_ratio_lpca;
        coarse_time(id_num_rec,id_repeat_times)=time_coarse;
    end
end 
coarse_loss_mean=mean(coarse_loss, 2);
coarse_vio_mean=mean(coarse_vio,2);
coarse_time_mean=mean(coarse_time,2);
%% print loss table
print_loss_table(num_rec, EM_mean, coarse_loss_mean, EMBR_mean, loss_function1_mean, loss_function2_mean, loss_function3_mean);
%% print computation time
% fprintf('Dataset: nyc\n');
print_time;
%% figure 13
Y = [
    phase1_budget_function1_mean  phase1_budget_function2_mean  phase1_budget_function3_mean;   % Phase I
    safety_margin_function1_mean  safety_margin_function2_mean  safety_margin_function3_mean;   % Safety margin ξ
    env_parameters.EPSILON-phase1_budget_function1_mean-safety_margin_function1_mean  env_parameters.EPSILON-phase1_budget_function2_mean-safety_margin_function2_mean  env_parameters.EPSILON-phase1_budget_function3_mean-safety_margin_function3_mean
];


figure;
b = bar(Y','stacked','BarWidth',0.5);

b(1).FaceColor = [0 114 189]/255;  % Phase I 
b(2).FaceColor = [217 83 25]/255;  % Safety margin ξ 
b(3).FaceColor = [237 177 32]/255; % Perturbed record 

xticklabels({'PANDA-e','PANDA-I','PANDA-p'});
ylabel('Max privacy cost (km^{-1})');

legend({'Phase I','Safety margin \xi','Perturbed record'}, 'Location','northeast');

%% figure 12
x = num_rec;   % 
y1 = PANDAe_vio;  % PANDA-e
y2 = PANDAp_vio;  % PANDA-p
y3 = PANDAl_vio;  % PANDA-l
y4 = zeros(length(x)); % EM
y5 = coarse_vio_mean; % LP+CA
y6 = zeros(length(x)); % EM+BR


figure;
hold on;


plot(x, y1, '-^', 'LineWidth', 1.5);   % PANDA-e
plot(x, y2, '-o', 'LineWidth', 1.5);   % PANDA-p
plot(x, y3, '-s', 'LineWidth', 1.5);   % PANDA-l
plot(x, y4, '-d', 'LineWidth', 1.5);   % EM
plot(x, y5, '-x', 'LineWidth', 1.5);   % LP+CA
plot(x, y6, '-v', 'LineWidth', 1.5);   % EM+BR

xlabel('Secret data domain size', 'FontSize', 12);
ylabel('mDP violation rate', 'FontSize', 12);

legend('PANDA-e','PANDA-p','PANDA-l','EM','LP+CA','EM+BR','Location','best');

grid on;
hold off;