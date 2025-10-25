% % 数据集与对应标签
% datasets = {result, result1, result2, result3};
% labels = {'PWV', 'LPW low', 'LPW middle', 'LPW high'};
% colors = {'c', 'm', 'b', 'r'}; % 颜色
% markers = {'o', 's', 'd', '^'}; % 标记
% 
% % 设置纬度范围和对应的标签
% latRange = 10:5:50;  % 纬度范围，每5度一个区间
% latLabels = strcat(string(latRange(1:end-1)), '-', string(latRange(2:end)), '°'); % 生成区间标签
% 
% % 创建绘图窗口
% figure;
% 
% % 绘制 RMSE
% subplot(3, 1, 1); hold on;
% for i = 1:length(datasets)
%     data = datasets{i};
%     latitude = data(:, 1); % 第一列为纬度
%     rmse = data(:, 4);     % 第四列为 RMSE
%     % 绘制折线和散点
%     plot(latitude, rmse, 'Color', colors{i}, 'Marker', markers{i}, ...
%          'LineStyle', '-', 'LineWidth', 1.2, 'MarkerSize', 6, 'DisplayName', labels{i});
% end
% ylabel('RMSE (mm)', 'FontName', 'Times New Roman', 'FontSize', 10);
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'Box', 'on', 'LineWidth', 1); % 设置封闭框，线宽为 1
% grid on;
% legend('show', 'Location', 'northwest', 'FontName', 'Times New Roman', 'FontSize', 10);
% xticks(latRange(1:end-1) + 2.5); % 设置刻度位置为区间中点
% xticklabels([]); % 在第一个子图中隐藏刻度标签
% 
% % 绘制 Bias
% subplot(3, 1, 2); hold on;
% for i = 1:length(datasets)
%     data = datasets{i};
%     latitude = data(:, 1); % 第一列为纬度
%     bias = data(:, 2);     % 第二列为 Bias
%     % 绘制折线和散点
%     plot(latitude, bias, 'Color', colors{i}, 'Marker', markers{i}, ...
%          'LineStyle', '-', 'LineWidth', 1.2, 'MarkerSize', 6, 'DisplayName', labels{i});
% end
% ylabel('Bias (mm)', 'FontName', 'Times New Roman', 'FontSize', 10);
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'Box', 'on', 'LineWidth', 1); % 设置封闭框，线宽为 1
% grid on;
% xticks(latRange(1:end-1) + 2.5); % 设置刻度位置为区间中点
% xticklabels([]); % 在第二个子图中隐藏刻度标签
% 
% % 绘制 R
% subplot(3, 1, 3); hold on;
% for i = 1:length(datasets)
%     data = datasets{i};
%     latitude = data(:, 1); % 第一列为纬度
%     r_value = data(:, 5);  % 第五列为 R
%     % 绘制折线和散点
%     plot(latitude, r_value, 'Color', colors{i}, 'Marker', markers{i}, ...
%          'LineStyle', '-', 'LineWidth', 1.2, 'MarkerSize', 6, 'DisplayName', labels{i});
% end
% ylabel('R', 'FontName', 'Times New Roman', 'FontSize', 10);
% xlabel('Latitude (°N)', 'FontName', 'Times New Roman', 'FontSize', 10);
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'Box', 'on', 'LineWidth', 1); % 设置封闭框，线宽为 1
% grid on;
% xticks(latRange(1:end-1) ); % 设置刻度位置为区间中点
% xticklabels(latLabels); % 设置区间刻度标签
% % 数据集与对应标签
% datasets = {result, result1, result2, result3};
% labels = {'PWV', 'LPW low', 'LPW middle', 'LPW high'};
% 
% % 设置新配色方案
% colors = {'#1f77b4', '#ff7f0e', '#2ca02c', '#d62728'}; % 蓝色, 橙色, 绿色, 红色
% 
% % 标记
% markers = {'o', 's', 'd', '^'}; % 标记
% 
% % 设置纬度范围和对应的标签
% latRange = 10:5:50;  % 纬度范围，每5度一个区间
% latLabels = strcat(string(latRange(1:end-1)), '-', string(latRange(2:end)), '°'); % 生成区间标签
% 
% % 创建绘图窗口
% figure;
% 
% % 绘制 RMSE
% subplot(3, 1, 1); hold on;
% for i = 1:length(datasets)
%     data = datasets{i};
%     latitude = data(:, 1); % 第一列为纬度
%     rmse = data(:, 5);     % 第四列为 RMSE
% 
%     % 归一化 RMSE 到合理的气泡大小范围
%     sizeFactor = (rmse - min(rmse)) / (max(rmse) - min(rmse)) * 100 + 10; % 范围 10-110
%     scatter(latitude, rmse, sizeFactor, 'MarkerFaceColor', colors{i}, ...
%             'MarkerEdgeColor', colors{i}, 'Marker', markers{i}, 'DisplayName', labels{i});
% end
% ylabel('RMSE (mm)', 'FontName', 'Times New Roman', 'FontSize', 10);
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'Box', 'on', 'LineWidth', 1); % 设置封闭框，线宽为 1
% grid on;
% legend('show', 'Location', 'northwest', 'FontName', 'Times New Roman', 'FontSize', 10);
% xticks(latRange(1:end-1) + 2.5); % 设置刻度位置为区间中点
% xticklabels([]); % 在第一个子图中隐藏刻度标签
% 
% % 绘制 Bias
% subplot(3, 1, 2); hold on;
% for i = 1:length(datasets)
%     data = datasets{i};
%     latitude = data(:, 1); % 第一列为纬度
%     bias = data(:, 2);     % 第二列为 Bias
% 
%     % 归一化 Bias 到合理的气泡大小范围
%     sizeFactor = (abs(bias) - min(abs(bias))) / (max(abs(bias)) - min(abs(bias))) * 100 + 10; % 范围 10-110
%     scatter(latitude, bias, sizeFactor, 'MarkerFaceColor', colors{i}, ...
%             'MarkerEdgeColor', colors{i}, 'Marker', markers{i}, 'DisplayName', labels{i});
% end
% ylabel('Bias (mm)', 'FontName', 'Times New Roman', 'FontSize', 10);
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'Box', 'on', 'LineWidth', 1); % 设置封闭框，线宽为 1
% grid on;
% xticks(latRange(1:end-1) + 2.5); % 设置刻度位置为区间中点
% xticklabels([]); % 在第二个子图中隐藏刻度标签
% 
% % 绘制 R
% subplot(3, 1, 3); hold on;
% for i = 1:length(datasets)
%     data = datasets{i};
%     latitude = data(:, 1); % 第一列为纬度
%     r_value = data(:, 4);  % 第五列为 R
% 
%     % 归一化 R 到合理的气泡大小范围
%     sizeFactor = (r_value - min(r_value)) / (max(r_value) - min(r_value)) * 100 + 10; % 范围 10-110
%     scatter(latitude, r_value, sizeFactor, 'MarkerFaceColor', colors{i}, ...
%             'MarkerEdgeColor', colors{i}, 'Marker', markers{i}, 'DisplayName', labels{i});
% end
% ylabel('R', 'FontName', 'Times New Roman', 'FontSize', 10);
% xlabel('Latitude (°N)', 'FontName', 'Times New Roman', 'FontSize', 10);
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'Box', 'on', 'LineWidth', 1); % 设置封闭框，线宽为 1
% grid on;
% xticks(latRange(1:end-1)); % 设置刻度位置为区间中点
% xticklabels(latLabels); % 设置区间刻度标签
% 数据集与对应标签
datasets = {result, result1, result2, result3};
labels = {'PWV', 'LPW low', 'LPW middle', 'LPW high'};

% 设置新配色方案
colors = {'#1f77b4', '#ff7f0e', '#2ca02c', '#d62728'}; % 蓝色, 橙色, 绿色, 红色

% 设置纬度范围和对应的标签
latRange = 10:5:50;  % 纬度范围，每5度一个区间
latLabels = strcat(string(latRange(1:end-1)), '-', string(latRange(2:end)), '°'); % 生成区间标签

% 创建绘图窗口
figure;

% 绘制 RMSE
subplot(3, 1, 1); hold on;
for i = 1:length(datasets)
    data = datasets{i};
    latitude = data(:, 1); % 第一列为纬度
    rmse = data(:, 5);     % 第五列为 RMSE
    
    % 绘制平滑的曲线
    plot(rmse, latitude, 'LineWidth', 2, 'Color', colors{i}, 'DisplayName', labels{i});
end
xlabel('RMSE (mm)', 'FontName', 'Times New Roman', 'FontSize', 10);
ylabel('Latitude (°N)', 'FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'Box', 'on', 'LineWidth', 1); % 设置封闭框，线宽为 1
grid on;
legend('show', 'Location', 'northwest', 'FontName', 'Times New Roman', 'FontSize', 10);
% xticks(linspace(min(rmse), max(rmse), 5)); % 设置 RMSE 的刻度
yticks(latRange); % 设置纬度刻度位置为10, 20, 30, 40, 50
yticklabels(latRange); % 设置纵轴刻度标签

% 绘制 Bias
subplot(3, 1, 2); hold on;
for i = 1:length(datasets)
    data = datasets{i};
    latitude = data(:, 1); % 第一列为纬度
    bias = data(:, 2);     % 第二列为 Bias
    
    % 绘制平滑的曲线，保持原始的 Bias 值（不使用 abs）
    plot(bias, latitude, 'LineWidth', 2, 'Color', colors{i}, 'DisplayName', labels{i});
end
xlabel('Bias (mm)', 'FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'Box', 'on', 'LineWidth', 1); % 设置封闭框，线宽为 1
grid on;
% xticks(linspace(min(bias), max(bias), 5)); % 设置 Bias 的刻度
yticks(latRange); % 设置纬度刻度位置为10, 20, 30, 40, 50
yticklabels(latRange); % 设置纵轴刻度标签


% 绘制 R
subplot(3, 1, 3); hold on;
for i = 1:length(datasets)
    data = datasets{i};
    latitude = data(:, 1); % 第一列为纬度
    r_value = data(:, 4);  % 第四列为 R
    
    % 绘制平滑的曲线
    plot(r_value, latitude, 'LineWidth', 2, 'Color', colors{i}, 'DisplayName', labels{i});
end
xlabel('R', 'FontName', 'Times New Roman', 'FontSize', 10);
ylabel('Latitude (°N)', 'FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'Box', 'on', 'LineWidth', 1); % 设置封闭框，线宽为 1
grid on;
% xticks(linspace(min(r_value), max(r_value), 5)); % 设置 R 的刻度
yticks(latRange); % 设置纬度刻度位置为10, 20, 30, 40, 50
yticklabels(latRange); % 设置纵轴刻度标签
