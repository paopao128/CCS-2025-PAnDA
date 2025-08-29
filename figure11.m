figure11_function1;
figure11_function2;
figure11_function3;
figure11_coarse;

%% figure 11
x = 1.5:0.5:15;   %
y1 = loss_epsilon_1;  % PANDA-e
y2 = loss_epsilon_2;  % PANDA-p
y3 = loss_epsilon_3;  % PANDA-l
y4 = EM; % EM
y5 = LPCA; % LP+CA
y6 = EMBR; % EM+BR


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