
% 观测值（PWV_all_merged的12-20列）
observations = arrayfun(@(i) PWV_sigma_all(:, i), 3:11, 'UniformOutput', false);

% 真值（PWV_all_merged的3-11列）
simulations = arrayfun(@(i) PWV_sigma_all(:, i),12:20 , 'UniformOutput', false);

% 生成标签（sigma 从 0.9 递减至 0.1）
sigma_values = 0.9:-0.1:0.1;
labels_obs = arrayfun(@(s) sprintf('FY-4B sigma %.1f', s), sigma_values, 'UniformOutput', false);
labels_sim = arrayfun(@(s) sprintf('ERA5 sigma %.1f', s), sigma_values, 'UniformOutput', false);

dataNums = 2e6; % 下采样目标点数

%% 计算统一坐标范围
all_obs = [];
all_sim = [];
for idx = 1:9
    obs = observations{idx};
    sim = simulations{idx};

    interval = max(floor(length(obs) / dataNums), 1);
    obs = obs(1:interval:end);
    sim = sim(1:interval:end);

    valid_idx = ~isnan(obs) & ~isinf(obs) & ~isnan(sim) & ~isinf(sim);
    all_obs = [all_obs; obs(valid_idx)];
    all_sim = [all_sim; sim(valid_idx)];
end

global_min = floor(min([all_obs; all_sim]));
global_max = ceil(max([all_obs; all_sim]));

%% 设置窗口大小（宽度 18cm，高度 18cm）
figure('Units', 'centimeters', 'Position', [2, 2, 18, 18]);

for idx = 1:9
    obs = observations{idx};
    sim = simulations{idx};

    interval = max(floor(length(obs) / dataNums), 1);
    obs = obs(1:interval:end);
    sim = sim(1:interval:end);

    valid_idx = ~isnan(obs) & ~isinf(obs) & ~isnan(sim) & ~isinf(sim);
    obs_clean = obs(valid_idx);
    sim_clean = sim(valid_idx);

    % 二维直方图计算密度
    numBins = 100;
    [counts, edgesX, edgesY] = histcounts2(obs_clean, sim_clean, numBins);
    centersX = edgesX(1:end-1) + diff(edgesX) / 2;
    centersY = edgesY(1:end-1) + diff(edgesY) / 2;
    density = interp2(centersX, centersY, counts', obs_clean, sim_clean, 'linear', 0);

    % 创建 3×3 子图
    subplot(3,3,idx);

    % 绘制散点图（按密度着色）
    scatter(obs_clean, sim_clean, 10, log10(density + 1), 'filled');
    hold on; box on;

    % 拟合直线（改为统一坐标范围内）
pcoef = polyfit(obs_clean, sim_clean, 1);  
x_fit = linspace(global_min, global_max, 100);
y_fit = polyval(pcoef, x_fit);
plot(x_fit, y_fit, 'r-', 'LineWidth', 2);


    % 绘制 1:1 参考线
    plot([global_min, global_max], [global_min, global_max], 'k--', 'LineWidth', 1.5);

    % 统一坐标范围
    xlim([global_min, global_max]);
    ylim([global_min, global_max]);

    % 颜色设置
    colormap(jet);
    caxis([0, 4]);

    % 计算 R² 和 RMSE
    mdl = fitlm(obs_clean, sim_clean);
    R2 = mdl.Rsquared.Ordinary;
    RMSE = sqrt(mean((obs_clean - sim_clean).^2));

    % 拟合公式显示
    a = sprintf('%.3f', pcoef(1));
    b = sprintf('%.3f', pcoef(2));
    labtxt = ['y = ', a, 'x + ', b, newline, ...
              'R^2 = ', sprintf('%.3f', R2), newline, ...
              'RMSE = ', sprintf('%.3f', RMSE)];
    text(global_min + 0.05 * (global_max - global_min), ...
         global_max - 0.2 * (global_max - global_min), ...
         labtxt, 'FontSize', 8, 'FontWeight', 'bold', 'Color', 'r');

    % 坐标轴和标签
    xlabel(labels_obs{idx}, 'FontSize', 12, 'FontWeight', 'bold');
    ylabel(labels_sim{idx}, 'FontSize', 12, 'FontWeight', 'bold');

    % 坐标轴样式
    set(gca, 'LineWidth', 1, 'FontName', 'Times New Roman', 'FontSize', 10, ...
             'XGrid', 'on', 'YGrid', 'on', 'TickDir', 'in', ...
             'TickLength', [0.01 0.01], 'XMinorTick', 'off', 'YMinorTick', 'off');

    axis square;
end

% 添加 colorbar（放置在右侧）
h = colorbar('Position', [0.92, 0.1, 0.02, 0.8]);
ylabel(h, 'Log_{10}(Density + 1)', 'FontSize', 12, 'FontWeight', 'bold');
set(h, 'Ticks', [0, 2, 4], 'TickLabels', {'0', '0.5', '1'});

% observations = {PWV_all_merged, LPW_all_merged(:,1), LPW_all_merged(:,2), LPW_all_merged(:,3)};
% simulations  = {PWV_ERA5_all_merged, LPW_ERA5_all_merged(:,1), LPW_ERA5_all_merged(:,2), LPW_ERA5_all_merged(:,3)};
% labels_obs = {'FY-4B PWV', 'FY-4B LPW low', 'FY-4B LPW middle', 'FY-4B LPW high'};
% labels_sim = {'ERA5 PWV', 'ERA5 LPW low', 'ERA5 LPW middle', 'ERA5 LPW high'};
% 
% dataNums = 2e6;  % 下采样目标点数
% 
% % 设置图像窗口大小
% figure('Units', 'centimeters', 'Position', [2, 2, 14, 14]);
% 
% % 子图布局设置
% gap = 0.08;
% width = 0.38;
% height = 0.38;
% positions = [
%     gap, gap + height + gap, width, height;
%     gap + width + gap, gap + height + gap, width, height;
%     gap, gap, width, height;
%     gap + width + gap, gap, width, height;
% ];
% 
% % ===== 第一步：预先统计 LPW 子图中的统一坐标范围 =====
% LPW_min = inf;
% LPW_max = -inf;
% for idx = 2:4
%     obs = observations{idx};
%     sim = simulations{idx};
% 
%     % 下采样并清洗
%     interval = max(floor(length(obs) / dataNums), 1);
%     obs = obs(1:interval:end);
%     sim = sim(1:interval:end);
%     valid_idx = ~isnan(obs) & ~isinf(obs) & ~isnan(sim) & ~isinf(sim);
%     obs_clean = obs(valid_idx);
%     sim_clean = sim(valid_idx);
% 
%     min_val = min([obs_clean; sim_clean]);
%     max_val = max([obs_clean; sim_clean]);
% 
%     LPW_min = min(LPW_min, min_val);
%     LPW_max = max(LPW_max, max_val);
% end
% 
% % 第二步：绘图主循环
% for idx = 1:4
%     obs = observations{idx};
%     sim = simulations{idx};
% 
%     % 下采样并清洗
%     interval = max(floor(length(obs) / dataNums), 1);
%     obs = obs(1:interval:end);
%     sim = sim(1:interval:end);
%     valid_idx = ~isnan(obs) & ~isinf(obs) & ~isnan(sim) & ~isinf(sim);
%     obs_clean = obs(valid_idx);
%     sim_clean = sim(valid_idx);
% 
%     % 绘图区域
%     axes('Position', positions(idx, :));
% 
%     % 二维密度
%     numBins = 100;
%     [counts, edgesX, edgesY] = histcounts2(obs_clean, sim_clean, numBins);
%     centersX = edgesX(1:end-1) + diff(edgesX)/2;
%     centersY = edgesY(1:end-1) + diff(edgesY)/2;
%     density = interp2(centersX, centersY, counts', obs_clean, sim_clean, 'linear', 0);
% 
%     % 散点图密度着色
%     scatter(obs_clean, sim_clean, 10, log10(density + 1), 'filled');
%     hold on; box on;
% 
%     % 统一坐标范围
%     if idx == 1
%         min_val = min([obs_clean; sim_clean]);
%         max_val = max([obs_clean; sim_clean]);
%     else
%         min_val = LPW_min;
%         max_val = LPW_max;
%     end
%     xlim([min_val, max_val]);
%     ylim([min_val, max_val]);
% 
%     % 拟合直线（在统一横坐标范围内拟合）
%     pcoef = polyfit(obs_clean, sim_clean, 1);
%     x_fit = linspace(min_val, max_val, 100);
%     y_fit = polyval(pcoef, x_fit);
%     plot(x_fit, y_fit, 'r-', 'LineWidth', 2);
% 
%     % 1:1 参考线
%     plot([min_val, max_val], [min_val, max_val], 'k--', 'LineWidth', 1.5);
% 
%     % 线性拟合评估
%     mdl = fitlm(obs_clean, sim_clean);
%     R2 = mdl.Rsquared.Ordinary;
%     RMSE = sqrt(mean((obs_clean - sim_clean).^2));
%     a = sprintf('%.3f', pcoef(1));
%     b = sprintf('%.3f', pcoef(2));
%     labtxt = ['y = ', a, 'x + ', b, newline, ...
%               'R^2 = ', sprintf('%.3f', R2), newline, ...
%               'RMSE = ', sprintf('%.3f', RMSE)];
%     text(min_val + 0.05*(max_val - min_val), max_val - 0.2*(max_val - min_val), ...
%          labtxt, 'FontSize', 8, 'FontWeight', 'bold', 'Color', 'r');
% 
%     % 标签设置
%     xlabel(labels_obs{idx}, 'FontSize', 12, 'FontWeight', 'bold');
%     ylabel(labels_sim{idx}, 'FontSize', 12, 'FontWeight', 'bold');
% 
%     % 样式统一
%     set(gca, 'LineWidth', 1, 'FontName', 'Times New Roman', 'FontSize', 10, ...
%              'XGrid', 'on', 'YGrid', 'on', 'TickDir', 'in', ...
%              'TickLength', [0.01 0.01], 'XMinorTick', 'off', 'YMinorTick', 'off');
%     axis square;
% end
% 
% % colorbar（右侧统一添加）
% h = colorbar('Position', [0.88, 0.1, 0.02, 0.8]);
% ylabel(h, 'Log_{10}(Density + 1)', 'FontSize', 12, 'FontWeight', 'bold');
% set(h, 'Ticks', [0, 2, 4], 'TickLabels', {'0', '0.5', '1'});
% 
% % 设置背景为白色
% set(gcf, 'Color', [1 1 1]);
% 
