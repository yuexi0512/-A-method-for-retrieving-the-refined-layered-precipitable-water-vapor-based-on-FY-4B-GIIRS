
% % 春季：3月、4月、5月
% PWV_spring = [PWV_sigma03; PWV_sigma04; PWV_sigma05];
% 
% % 夏季：6月、7月、8月
% PWV_summer = [PWV_sigma06; PWV_sigma07; PWV_sigma08];
% 
% % 秋季：9月、10月、11月
% PWV_autumn = [PWV_sigma09; PWV_sigma10; PWV_sigma11];
% 
% % 冬季：12月、1月、2月
% PWV_winter = [PWV_sigma12; PWV_sigma01; PWV_sigma02];
% 气压层（从底到顶）
pressure = [0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1]';

% 季节数据和标签
season_data = {PWV_spring, PWV_summer, PWV_autumn, PWV_winter};
season_names = {'Spring', 'Summer', 'Autumn', 'Winter'};
season_labels = {'(a)', '(b)', '(c)', '(d)'};

figure;

for i = 1:4
    data = season_data{i};

    obs = data(:, 3:11);     % 9层观测值
    truth = data(:, 12:20);  % 9层真值

    % 相对误差（%）
    rel_error = 100 * (obs - truth) ./ (truth + eps);

    % 计算分位数
    q25 = prctile(rel_error, 25, 1)';
    q50 = prctile(rel_error, 50, 1)';
    q75 = prctile(rel_error, 75, 1)';

    % 构建误差填充区域
    fill_x = [q75; flipud(q25)];
    fill_y = [pressure; flipud(pressure)];

    % 绘图
    subplot(1, 4, i);
    hold on;
    box on;
    fill(fill_x, fill_y, [0, 1, 1]*0.6, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    plot(q50, pressure, '-^', 'Color', [0, 0.6, 0.6], ...
        'LineWidth', 1.5, 'MarkerSize', 5, 'MarkerFaceColor', [0, 0.6, 0.6]);
    xline(0, '--k', 'LineWidth', 1);

    % 设置坐标轴
    set(gca, 'YDir', 'reverse');
    xlim([-75, 75]);  % 修改x轴范围
    ylim([0.1, 0.9]);
    grid on;
    set(gca, 'XTick', -50:25:50, 'YTick', 0.1:0.1:0.9);  % 去掉-75和75刻度

    % 字体与标签设置
    set(gca, 'FontName', 'Arial', 'FontSize', 9, 'LineWidth', 1);
    xlabel('Relative Bias (%)', 'FontName', 'Arial', 'FontSize', 9);
    if i == 1
        ylabel('Sigma', 'FontName', 'Arial', 'FontSize', 9);
    else
        set(gca, 'YTickLabel', []);
    end

    % 标题
    title([season_labels{i} ' ' season_names{i}], ...
        'FontSize', 9, 'FontName', 'Arial');

    hold off;
end

% 气压层（从底到顶）
pressure = [0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1]';

% 季节数据和标签
season_data = {PWV_spring, PWV_summer, PWV_autumn, PWV_winter};
season_names = {'Spring', 'Summer', 'Autumn', 'Winter'};
season_labels = {'(a)', '(b)', '(c)', '(d)'};

figure;

for i = 1:4
    data = season_data{i};

    truth = data(:, 3:11);     % 9层真值
    obs = data(:, 12:20);      % 9层观测值

    % 清除NaN值
    valid_mask = ~any(isnan([obs, truth]), 2);
    obs = obs(valid_mask, :);
    truth = truth(valid_mask, :);

    % 计算每层的相对RMSE
    rel_rmse_all = zeros(size(obs));

    for j = 1:size(obs, 2)
        for k = 1:length(obs)
            rel_rmse_all(k, j) = 100 * sqrt((obs(k, j) - truth(k, j))^2) / (truth(k, j) + eps);
        end
    end

    % 计算分位数
    q25 = prctile(rel_rmse_all, 25, 1)';
    q50 = prctile(rel_rmse_all, 50, 1)';
    q75 = prctile(rel_rmse_all, 75, 1)';

    % 构建RMSE填充区域
    fill_x = [q75; flipud(q25)];
    fill_y = [pressure; flipud(pressure)];

    % 绘图
    subplot(1, 4, i);
    hold on;
    box on;
    fill(fill_x, fill_y, [0, 1, 1]*0.6, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    plot(q50, pressure, '-^', 'Color', [0, 0.6, 0.6], ...
        'LineWidth', 1.5, 'MarkerSize', 5, 'MarkerFaceColor', [0, 0.6, 0.6]);
    xline(0, '--k', 'LineWidth', 1);

    % 设置坐标轴
    set(gca, 'YDir', 'reverse');
    xlim([0, 100]);
    ylim([0.1, 0.9]);
    grid on;
    set(gca, 'XTick', 0:25:100, 'YTick', 0.1:0.1:0.9);

    % 字体与标签设置
    set(gca, 'FontName', 'Arial', 'FontSize', 9, 'LineWidth', 1);
    xlabel('Relative RMSE (%)', 'FontName', 'Arial', 'FontSize', 9);
    if i == 1
        ylabel('Sigma', 'FontName', 'Arial', 'FontSize', 9);
    else
        set(gca, 'YTickLabel', []);
    end

    % 标题
    title([season_labels{i} ' ' season_names{i}], ...
        'FontSize', 9, 'FontName', 'Arial');

    hold off;
end

% 
% % 气压层（从底到顶）
% pressure = [0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1]';
% 
% % 季节数据和标签
% season_data = {PWV_spring, PWV_summer, PWV_autumn, PWV_winter};
% season_names = {'Spring', 'Summer', 'Autumn', 'Winter'};
% season_labels = {'(a)', '(b)', '(c)', '(d)'};
% 
% figure;
% 
% for i = 1:4
%     data = season_data{i};
% 
%     obs = data(:, 3:11);     % 9层观测值
%     truth = data(:, 12:20);  % 9层真值
% 
%     % 清除NaN值
%     valid_mask = ~any(isnan([obs, truth]), 2);  % 去除含NaN的行
%     obs = obs(valid_mask, :);
%     truth = truth(valid_mask, :);
% 
%     % 计算每层的相对RMSE
%     rel_rmse_all = zeros(size(obs));  % 初始化矩阵来存储每对数据的相对RMSE
% 
%     for j = 1:size(obs, 2)  % 遍历每一列（每一层）
%         % 计算每一对数据的相对RMSE
%         for k = 1:length(obs)
%             rel_rmse_all(k, j) = 100 * sqrt((obs(k, j) - truth(k, j))^2) / (truth(k, j) + eps);  % 相对RMSE
%         end
%     end
% 
%     % 计算分位数
%     q25 = prctile(rel_rmse_all, 10, 1)';  % 每列的25%分位数
%     q50 = prctile(rel_rmse_all, 50, 1)';  % 每列的50%分位数
%     q75 = prctile(rel_rmse_all, 90, 1)';  % 每列的75%分位数
% 
%     % 计算均值
%     mean_rmse = mean(rel_rmse_all, 1)';  % 计算每列的均值
% 
%     % 构建RMSE填充区域
%     fill_x = [q75; flipud(q25)];
%     fill_y = [pressure; flipud(pressure)];
% 
%     % 绘图
%     subplot(1, 4, i);
%     hold on;
%     box on;  % 添加封闭边框
%     fill(fill_x, fill_y, [0, 1, 1]*0.6, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
%     plot(q50, pressure, '-^', 'Color', [0, 0.6, 0.6], ...
%         'LineWidth', 1.5, 'MarkerSize', 5, 'MarkerFaceColor', [0, 0.6, 0.6]);
%     plot(mean_rmse, pressure, '--o', 'Color', [0.6, 0, 0], 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', [0.6, 0, 0]);
%     xline(0, '--k', 'LineWidth', 1);
% 
%     % 设置坐标轴
%     set(gca, 'YDir', 'reverse');  % 从底到顶
%     xlim([0, 100]);  % 修改x轴范围为0到100
%     ylim([0.1, 0.9]);
%     grid on;
%     set(gca, 'XTick', 0:25:100, 'YTick', 0.1:0.1:0.9);
% 
%     % 字体与标签设置
%     set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'LineWidth', 1);
%     xlabel('Relative RMSE (%)', 'FontWeight', 'bold', 'FontName', 'Times New Roman');
%     if i == 1
%         ylabel('Pressure (p/p0)', 'FontWeight', 'bold', 'FontName', 'Times New Roman');
%     else
%         set(gca, 'YTickLabel', []);
%     end
% 
%     % 标题
%     title([season_labels{i} ' ' season_names{i}], ...
%         'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
% 
%     hold off;
% end


% %%%%%%%%%垂直剖面图
% % 生成示例数据
% pressure = (100:50:600)';  % 代表气压（hPa），从100到600
% x_mean = [-2, -1.5, -1, 0, 0.5, 1, 1.2, 1.5, 1.3, 1.0, 0.5]';  % 数据曲线
% x_std = [1, 1.2, 1.0, 0.8, 0.7, 0.9, 1.1, 1.2, 1.0, 0.8, 0.6]';  % 误差范围
% 
% % 计算阴影区域边界
% fill_x = [x_mean + x_std; flipud(x_mean - x_std)];  % 误差范围左右边界
% fill_y = [pressure; flipud(pressure)];  % 保持Y坐标顺序一致
% 
% % 反向Y轴
% figure;
% hold on;
% 
% % 绘制阴影区域（误差范围）
% fill(fill_x, fill_y, [0, 1, 1] * 0.6, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
% 
% % 绘制数据曲线
% plot(x_mean, pressure, '-^', 'Color', [0, 0.6, 0.6], 'LineWidth', 1.5, ...
%     'MarkerSize', 5, 'MarkerFaceColor', [0, 0.6, 0.6]);
% 
% % 添加虚线（参考线）
% xline(0, '--k', 'LineWidth', 1);
% 
% % 反向Y轴
% set(gca, 'YDir', 'reverse');
% 
% % 设置轴范围
% xlim([-6, 6]);
% ylim([100, 600]);
% 
% % 添加网格线
% grid on;
% ax = gca;
% ax.XTick = -6:2:6;
% ax.YTick = 100:50:600;
% 
% % 添加标题
% text(-5.5, 120, '(b) Spring', 'FontSize', 14, 'FontWeight', 'bold');
% 
% % 设置标签
% xlabel('');
% ylabel('');
% set(gca, 'FontSize', 12, 'LineWidth', 1);
% hold off;
% % 计算相对误差
% relative_error = abs(PWV_all - PWV_ERA5_all) ./ PWV_ERA5_all;
% 
% % 筛选非零项，避免除零错误
% valid_idx = PWV_ERA5_all ~= 0;
% valid_errors = relative_error(valid_idx);
% 
% % 计算 IQR（四分位距）
% Q1 = quantile(valid_errors, 0.25);
% Q3 = quantile(valid_errors, 0.75);
% IQR_val = Q3 - Q1;
% 
% % 设定正常范围 (Q1 - 1.5*IQR, Q3 + 1.5*IQR)
% lower_bound = Q1 - 1.5 * IQR_val;
% upper_bound = Q3 + 1.5 * IQR_val;
% 
% % 过滤掉异常值
% filtered_errors = valid_errors(valid_errors >= lower_bound & valid_errors <= upper_bound);
% 
% % 计算统计量
% mean_error = mean(filtered_errors, 'omitnan');  
% max_error = max(filtered_errors, [], 'omitnan');  
% min_error = min(filtered_errors, [], 'omitnan');  
% 
% % 输出结果
% fprintf('PWV 相对误差均值: %.4f\n', mean_error);
% fprintf('PWV 相对误差最大值: %.4f\n', max_error);
% fprintf('PWV 相对误差最小值: %.4f\n', min_error);
% 
% % 计算相对误差
% relative_error = abs(LPW_all - LPW_ERA5_all) ./ LPW_ERA5_all;
% 
% % 预分配结果矩阵
% mean_error = NaN(1,3);
% max_error = NaN(1,3);
% min_error = NaN(1,3);
% 
% for i = 1:1
%     % 筛选非零项，避免除零错误
%     valid_idx = LPW_ERA5_all(:, i) ~= 0;
%     valid_errors = relative_error(valid_idx, i);
% 
%     % 计算 IQR（四分位距）来筛除异常值
%     Q1 = quantile(valid_errors, 0.25);
%     Q3 = quantile(valid_errors, 0.75);
%     IQR_val = Q3 - Q1;
% 
%     % 设定正常范围 (Q1 - 1.5*IQR, Q3 + 1.5*IQR)
%     lower_bound = Q1 - 1.5 * IQR_val;
%     upper_bound = Q3 + 1.5 * IQR_val;
% 
%     % 过滤掉异常值
%     filtered_errors = valid_errors(valid_errors >= lower_bound & valid_errors <= upper_bound);
% 
%     % 计算统计量
%     mean_error(i) = mean(filtered_errors, 'omitnan');  
%     max_error(i) = max(filtered_errors, [], 'omitnan');  
%     min_error(i) = min(filtered_errors, [], 'omitnan');  
% end
% 
% % 输出结果
% for i = 1:1
%     fprintf('第 %d 列相对误差均值: %.4f\n', i, mean_error(i));
%     fprintf('第 %d 列相对误差最大值: %.4f\n', i, max_error(i));
%     fprintf('第 %d 列相对误差最小值: %.4f\n', i, min_error(i));
% end
% % 计算 RMSE
% rmse_all = (LPW_all - LPW_ERA5_all) .^ 2;
% 
% % 预分配结果矩阵
% mean_rmse = NaN(1,3);
% max_rmse = NaN(1,3);
% min_rmse = NaN(1,3);
% 
% for i = 1:1
%     % 筛选非零项，避免无意义计算
%     valid_idx = LPW_ERA5_all(:, i) ~= 0;
%     valid_rmse = rmse_all(valid_idx, i);
% 
%     % 计算 IQR（四分位距）来筛除异常值
%     Q1 = quantile(valid_rmse, 0.25);
%     Q3 = quantile(valid_rmse, 0.75);
%     IQR_val = Q3 - Q1;
% 
%     % 设定正常范围 (Q1 - 1.5*IQR, Q3 + 1.5*IQR)
%     lower_bound = Q1 - 1.5 * IQR_val;
%     upper_bound = Q3 + 1.5 * IQR_val;
% 
%     % 过滤掉异常值
%     filtered_rmse = valid_rmse(valid_rmse >= lower_bound & valid_rmse <= upper_bound);
% 
%     % 计算 RMSE 统计量
%     mean_rmse(i) = sqrt(mean(filtered_rmse, 'omitnan'));  
%     max_rmse(i) = sqrt(max(filtered_rmse, [], 'omitnan'));  
%     min_rmse(i) = sqrt(min(filtered_rmse, [], 'omitnan'));  
% end
% 
% % 输出结果
% for i = 1:1
%     fprintf('第 %d 列 RMSE 均值: %.4f\n', i, mean_rmse(i));
%     fprintf('第 %d 列 RMSE 最大值: %.4f\n', i, max_rmse(i));
%     fprintf('第 %d 列 RMSE 最小值: %.4f\n', i, min_rmse(i));
% end
