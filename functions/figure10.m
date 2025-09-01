addpath('./functions/'); 
addpath('./functions/figure10_user');
% addpath 'C:\Users\lry1t\Desktop\文件\CCS 2025\CCS artifact\functions\figure10_user'
repeat_times=1;

loss_function1=zeros(10,repeat_times);
computation_time_function1=zeros(10,repeat_times);
loss_function2=zeros(10,repeat_times);
computation_time_function2=zeros(10,repeat_times);
loss_function3=zeros(10,repeat_times);
computation_time_function3=zeros(10,repeat_times);
EM=zeros(10,repeat_times);
EMBR=zeros(10,repeat_times);
coarse_loss=zeros(10,repeat_times);
number_users=20:20:200;
divide_parameter=[80,90,100,110,120,125,130,140,150,160,170,180,190,200,210,220,230,240];

for id_num_user=1:10
    di_para=divide_parameter(id_num_user); % 
    for id_repeat_times=1:repeat_times
        main_user_function1_rome;
        loss_function1(id_num_user,id_repeat_times)=loss;
        computation_time_function1(id_num_user,id_repeat_times)=time_2PPO;
        EM(id_num_user,id_repeat_times)=loss_benchmarks;
        EMBR(id_num_user,id_repeat_times)=loss_Bayesian_Remapping;
    end
end
loss_function1_mean=mean(loss_function1, 2)
computation_time_function1_mean=mean(computation_time_function1,2);
EM_mean=mean(EM,2);
EMBR_mean=mean(EMBR,2);


for id_num_user=1:10
    di_para=divide_parameter(id_num_user); % 
    for id_repeat_times=1:repeat_times
        main_user_function2_rome;
        loss_function2(id_num_user,id_repeat_times)=loss;
        computation_time_function2(id_num_user,id_repeat_times)=time_2PPO;
    end
end
loss_function2_mean=mean(loss_function2, 2)
computation_time_function2_mean=mean(computation_time_function2,2);

for id_num_user=1:10
    di_para=divide_parameter(id_num_user); % 
    for id_repeat_times=1:repeat_times
        main_user_function3_rome;
        loss_function3(id_num_user,id_repeat_times)=loss;
        computation_time_function3(id_num_user,id_repeat_times)=time_2PPO;
    end
end
loss_function3_mean=mean(loss_function3, 2)
computation_time_function3_mean=mean(computation_time_function3,2);


for id_num_user=1:10
    for id_repeat_times=1:repeat_times
        coarse;
        coarse_loss(id_num_user,id_repeat_times)=loss_coarse;
    end
end 
coarse_loss_mean=mean(coarse_loss, 2)


%% figure 10

x = number_users;   % Number of users
y1 = loss_function1_mean;  % PANDA-e
y2 = loss_function2_mean;  % PANDA-p
y3 = loss_function3_mean;  % PANDA-l
y4 = EM_mean; % EM
y5 = coarse_loss_mean; % LP+CA
y6 = EMBR_mean; % EM+BR


figure;
hold on;


plot(x, y1, '-^', 'LineWidth', 1.5);   % PANDA-e
plot(x, y2, '-o', 'LineWidth', 1.5);   % PANDA-p
plot(x, y3, '-s', 'LineWidth', 1.5);   % PANDA-l
plot(x, y4, '-d', 'LineWidth', 1.5);   % EM
plot(x, y5, '-x', 'LineWidth', 1.5);   % LP+CA
plot(x, y6, '-v', 'LineWidth', 1.5);   % EM+BR

xlabel('Number of users', 'FontSize', 12);
ylabel('Utility loss (m)', 'FontSize', 12);

legend('PANDA-e','PANDA-p','PANDA-l','EM','LP+CA','EM+BR','Location','best');

grid on;
hold off;
