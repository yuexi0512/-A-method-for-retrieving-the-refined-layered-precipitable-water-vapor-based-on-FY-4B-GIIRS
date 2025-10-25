% % 数据示例（来自图表）
% categories = {'Spring', 'Summer', 'Autumn', 'Winter'};
% nGroups = length(categories);
% 
% % Bias 数据
% Bias = [
%     -1.3331, -2.3335, -1.6623, -0.5048;  % PWV
%     -0.8338, -1.2609, -0.8387, -0.5202;  % LPW_low
%     -0.1194, -0.2402, -0.2588, 0.1448;   % LPW_middle
%     -0.3636, -0.7903, -0.5459, -0.1298   % LPW_high
% ];
% 
% % MAE 数据
% MAE = [
%     2.6747, 3.5363, 2.7275, 2.2043;
%     1.3827, 1.6479, 1.2426, 1.0931;
%     1.5233, 1.7189, 1.4600, 1.4324;
%     0.7845, 1.3388, 0.9231, 0.6636
% ];
% 
% % RMSE 数据
% RMSE = [
%     3.5113, 4.3370, 3.5819, 2.9857;
%     1.8164, 2.0862, 1.6450, 1.4858;
%     2.0300, 2.1894, 1.9808, 1.9855;
%     1.1466, 1.7778, 1.3567, 1.0209
% ];
% 
% % R^2 数据
% R2 = [
%     0.9412, 0.8927, 0.9545, 0.9517;
%     0.8743, 0.7225, 0.9109, 0.9157;
%     0.9070, 0.8533, 0.9310, 0.9042;
%     0.8870, 0.8532, 0.9070, 0.8746
% ];
% 
% % 绘图
% figure;
% 
% % Bias
% subplot(4, 1, 1);
% bar(Bias, 'grouped');
% ylabel('Bias(K)');
% set(gca, 'XTickLabel', categories);
% title('Bias');
% legend({'PWV', 'LPW_{low}', 'LPW_{middle}', 'LPW_{high}'}, 'Location', 'northoutside', 'Orientation', 'horizontal');
% 
% % MAE
% subplot(4, 1, 2);
% bar(MAE, 'grouped');
% ylabel('MAE(K)');
% set(gca, 'XTickLabel', categories);
% title('MAE');
% 
% % RMSE
% subplot(4, 1, 3);
% bar(RMSE, 'grouped');
% ylabel('RMSE(K)');
% set(gca, 'XTickLabel', categories);
% title('RMSE');
% 
% % R^2
% subplot(4, 1, 4);
% bar(R2, 'grouped');
% ylabel('R^2');
% set(gca, 'XTickLabel', categories);
% title('R^2');
% 
% % 调整图形
% set(gcf, 'Position', [100, 100, 800, 800]);
% % 假设数据已经加载到变量中：PWV_all, PWV_ERA5_all, LPW_all, LPW_ERA5_all
%     % 季节文件路径
%     season_files = {
%         'E:\孙悦\LPW_PWV\季节分析\spring.mat';
%         'E:\孙悦\LPW_PWV\季节分析\summer.mat';
%         'E:\孙悦\LPW_PWV\季节分析\fall.mat';
%         'E:\孙悦\LPW_PWV\季节分析\winter.mat'
%     };
% 
%     season_names = {'Spring', 'Summer', 'Fall', 'Winter'};
% 
%     % 初始化存储每个季节的RMSE（每列是一个指标，4列：PWV, LPW1, LPW2, LPW3）
% 
% 
%     for s = 1:4
%         % 载入数据
%         load(season_files{s});
% 
%         % 数据筛选
%         PWV_min = 0; PWV_max = 70;
%         LPW_min = 0; LPW_max = 40;
% 
%         idx_valid = (PWV_all >= PWV_min & PWV_all <= PWV_max) & ...
%                     (PWV_ERA5_all >= PWV_min & PWV_ERA5_all <= PWV_max);
% 
%         for i = 1:3
%             idx_valid = idx_valid & ...
%                 (LPW_all(:,i) >= LPW_min & LPW_all(:,i) <= LPW_max) & ...
%                 (LPW_ERA5_all(:,i) >= LPW_min & LPW_ERA5_all(:,i) <= LPW_max);
%         end
% 
%         % 筛选后的数据
%         PWV_obs = PWV_all(idx_valid);
%         PWV_true = PWV_ERA5_all(idx_valid);
%         LPW_obs = LPW_all(idx_valid, :);
%         LPW_true = LPW_ERA5_all(idx_valid, :);
% 
%         % 偏差筛选（PWV）
%         pwv_diff = abs(PWV_obs - PWV_true);
%         pwv_threshold = mean(pwv_diff) + 3 * std(pwv_diff);
%         idx_diff = pwv_diff <= pwv_threshold;
% 
%         % 最终筛选结果
%         PWV_obs = PWV_obs(idx_diff);
%         PWV_true = PWV_true(idx_diff);
%         LPW_obs = LPW_obs(idx_diff, :);
%         LPW_true = LPW_true(idx_diff, :);
% 
%         % 计算RMSE
%         rmse_PWV = sqrt(mean((PWV_obs - PWV_true).^2, 2));
%         rmse_LPW = zeros(size(LPW_obs,1), 3);
%         for i = 1:3
%             rmse_LPW(:,i) = sqrt(mean((LPW_obs(:,i) - LPW_true(:,i)).^2, 2));
%         end
% 
%         % 合并四个指标的RMSE（每一行为一个样本）
%         rmse_all_seasons{s} = [rmse_PWV, rmse_LPW];
%     end
% 
%     % 合并所有季节数据
%     rmse_all = vertcat(rmse_all_seasons{:});
% 
%     % 创建分组标签
%     group_labels = {};
%     product_labels = repmat({'PWV','LPW1','LPW2','LPW3'}, 1, 4); % 4季节 × 4指标
% 
%     % 生成group标签用于箱型图分组（用于 boxplot 的 group 和 label 参数）
%     group = [];
%     label = {};
% 
%     for s = 1:4
%         num_rows = size(rmse_all_seasons{s}, 1);
%         for i = 1:4  % 四个产品
%             group = [group; repmat(i + (s-1)*4, num_rows, 1)];
%         end
%     end
% 
%     % 对应标签
%     labels_full = {};
%     for s = 1:4
%         for p = 1:4
%             labels_full{end+1} = [product_labels{p} '-' season_names{s}];
%         end
%     end
% % 转置数据为一列向量
% rmse_plot_data = reshape(rmse_all', [], 1);
% colors = [0 0.4470 0.7410;
%           0.8500 0.3250 0.0980;
%           0.9290 0.6940 0.1250;
%           0.4940 0.1840 0.5560];
% 
% 
%     % % 原始标签（如有）
%     % labels_full = {'LPW low', 'LPW mid', 'LPW high', 'PWV', ...};
% 
%     % 绘制箱型图
%     figure;
%     hold on;
%     h = boxplot(rmse_plot_data, group, 'LabelOrientation', 'inline', 'Symbol', '');
% 
% 
%     % 设置颜色
%     boxes = findobj(gca, 'Tag', 'Box');
%     numGroups = 16;
%     for i = 1:numGroups
%         colorIdx = mod(i-1,4)+1;
%         patch(get(boxes(numGroups - i + 1), 'XData'), ...
%               get(boxes(numGroups - i + 1), 'YData'), ...
%               colors(colorIdx,:), 'FaceAlpha', 0.5, 'EdgeColor', colors(colorIdx,:));
%     end
% 
%     % 添加竖线分隔季节
%     for s = 1:3
%         xline(s*4 + 0.5, '--k', 'LineWidth', 1);
%     end
% 
%     % 设置新的 x 轴标签
%     xticks([2.5, 6.5, 10.5, 14.5]);  % 每个季节的中心位置
%     xticklabels({'Spring', 'Summer', 'Fall', 'Winter'});
% 
%     % 坐标轴与标题设置
%     ylabel('RMSE (mm)', 'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold');
%     title('RMSE Distribution by Product and Season', ...
%           'FontName', 'Times New Roman', 'FontSize', 10);
% 
%     % 设置坐标轴字体
%     set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'LineWidth', 1);
%     box on;
%     grid on;
%     % 获取箱线图的统计数据
% stats = struct();
% numGroups = 16;  % 4季节 × 4变量
% 
% for i = 1:numGroups
%     this_group_data = rmse_plot_data(group == i);
%     stats(i).GroupIndex = i;
%     stats(i).Label = labels_full{i};
%     stats(i).Min = min(this_group_data);
%     stats(i).Q1 = quantile(this_group_data, 0.25);
%     stats(i).Median = median(this_group_data);
%     stats(i).Q3 = quantile(this_group_data, 0.75);
%     stats(i).Max = max(this_group_data);
% end
% 
% % 可选：将结构数组转换为表格形式更方便查看和导出
% stats_table = struct2table(stats);
% 
% % 保存到工作区
% assignin('base', 'boxplot_stats', stats_table);
% 
% % 设置路径（四季）
% season_files = {
%     'E:\孙悦\LPW_PWV\季节分析\spring.mat', 
%     'E:\孙悦\LPW_PWV\季节分析\summer.mat', 
%     'E:\孙悦\LPW_PWV\季节分析\fall.mat', 
%     'E:\孙悦\LPW_PWV\季节分析\winter.mat'
% };
% 
% % 初始化
% RE_plot_data = [];
% group = [];
% 
% for s = 1:4
%     load(season_files{s});  % 应包含 PWV_all、PWV_ERA5_all、LPW_all、LPW_ERA5_all
% 
%     % 数据筛选条件：去除小于0.1或极端异常值
%     valid_idx = PWV_ERA5_all > 0.1 & PWV_ERA5_all < 100 & ...
%                 all(LPW_ERA5_all > 0.1 & LPW_ERA5_all < 100, 2) & ...
%                 all(LPW_all > 0 & LPW_all < 200, 2) & ...
%                 PWV_all > 0 & PWV_all < 200;
% 
%     % 筛选数据
%     PWV_obs = PWV_all(valid_idx);
%     PWV_ref = PWV_ERA5_all(valid_idx);
%     LPW_obs = LPW_all(valid_idx, :);
%     LPW_ref = LPW_ERA5_all(valid_idx, :);
% 
%     % 相对误差 (%)
%     RE_PWV  = abs(PWV_obs - PWV_ref) ./ PWV_ref * 100;
%     RE_LPW1 = abs(LPW_obs(:,1) - LPW_ref(:,1)) ./ LPW_ref(:,1) * 100;
%     RE_LPW2 = abs(LPW_obs(:,2) - LPW_ref(:,2)) ./ LPW_ref(:,2) * 100;
%     RE_LPW3 = abs(LPW_obs(:,3) - LPW_ref(:,3)) ./ LPW_ref(:,3) * 100;
% 
%     % 移除 NaN 和 Inf
%     valid_all = isfinite(RE_PWV) & isfinite(RE_LPW1) & isfinite(RE_LPW2) & isfinite(RE_LPW3);
% 
%     % 组合当前季节所有RE
%     RE_season = [RE_LPW1(valid_all); RE_LPW2(valid_all); RE_LPW3(valid_all); RE_PWV(valid_all)];
%     RE_plot_data = [RE_plot_data; RE_season];
% 
%     % 标签（分组）
%     n = sum(valid_all);
%     group = [group; ...
%         (s-1)*4 + 1 * ones(n,1); ...
%         (s-1)*4 + 2 * ones(n,1); ...
%         (s-1)*4 + 3 * ones(n,1); ...
%         (s-1)*4 + 4 * ones(n,1)];
% end
% 
% % 设置颜色
% colors = [0 0.4470 0.7410;
%           0.8500 0.3250 0.0980;
%           0.9290 0.6940 0.1250;
%           0.4940 0.1840 0.5560];
% 
% % 绘图
% figure;
% hold on;
% 
% h = boxplot(RE_plot_data, group, 'LabelOrientation', 'inline', 'Symbol', '');
% 
% % 着色
% boxes = findobj(gca, 'Tag', 'Box');
% numGroups = 16;
% for i = 1:numGroups
%     colorIdx = mod(i-1, 4) + 1;
%     patch(get(boxes(numGroups - i + 1), 'XData'), ...
%           get(boxes(numGroups - i + 1), 'YData'), ...
%           colors(colorIdx,:), 'FaceAlpha', 0.5, 'EdgeColor', colors(colorIdx,:));
% end
% 
% % 添加季节分隔线
% for s = 1:3
%     xline(s*4 + 0.5, '--k', 'LineWidth', 1);
% end
% 
% % 设置x轴
% xticks([2.5, 6.5, 10.5, 14.5]);
% xticklabels({'Spring', 'Summer', 'Fall', 'Winter'});
% 
% % 标签字体
% ylabel('Relative Error (%)', 'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold');
% title('Relative Error Distribution by Product and Season', 'FontName', 'Times New Roman', 'FontSize', 10);
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'LineWidth', 1);
% grid on;
% box on;
% 获取箱线图的统计数据
stats = struct();
numGroups = 16;  % 4季节 × 4变量

for i = 1:numGroups
    this_group_data = RE_plot_data (group == i);
    stats(i).GroupIndex = i;
    stats(i).Label = labels_full{i};
    stats(i).Min = min(this_group_data);
    stats(i).Q1 = quantile(this_group_data, 0.25);
    stats(i).Median = median(this_group_data);
    stats(i).Q3 = quantile(this_group_data, 0.75);
    stats(i).Max = max(this_group_data);
end

% 可选：将结构数组转换为表格形式更方便查看和导出
stats_table = struct2table(stats);

% 保存到工作区
assignin('base', 'boxplot_stats', stats_table);
% % 设置路径（四季）
% season_files = {
%     'E:\孙悦\LPW_PWV\季节分析\spring.mat', 
%     'E:\孙悦\LPW_PWV\季节分析\summer.mat', 
%     'E:\孙悦\LPW_PWV\季节分析\fall.mat', 
%     'E:\孙悦\LPW_PWV\季节分析\winter.mat'
% };
% 
% % 初始化数据存储
% RMSE_plot_data = zeros(4, 4, 7);  % 4个季节，4个产品（LPW low, LPW middle, LPW high, PWV），7个区间
% RE_plot_data = zeros(4, 4, 7);    % 同上
% 
% % 处理每个季节的 RMSE 和相对误差
% for s = 1:4
%     load(season_files{s});  % 应包含 PWV_all、PWV_ERA5_all、LPW_all、LPW_ERA5_all
% 
%     % 数据筛选条件：去除小于0.1或极端异常值
%     valid_idx = PWV_ERA5_all > 0.1 & PWV_ERA5_all < 100 & ...
%                 all(LPW_ERA5_all > 0.1 & LPW_ERA5_all < 100, 2) & ...
%                 all(LPW_all > 0 & LPW_all < 200, 2) & ...
%                 PWV_all > 0 & PWV_all < 200;
% 
%     % 筛选数据
%     PWV_obs = PWV_all(valid_idx);
%     PWV_ref = PWV_ERA5_all(valid_idx);
%     LPW_obs = LPW_all(valid_idx, :);
%     LPW_ref = LPW_ERA5_all(valid_idx, :);
% 
%     % 计算每对数据的 RMSE
%     RMSE_PWV = sqrt((PWV_obs - PWV_ref).^2); % 对每对数据计算 RMSE
%     RMSE_LPW1 = sqrt((LPW_obs(:,1) - LPW_ref(:,1)).^2);
%     RMSE_LPW2 = sqrt((LPW_obs(:,2) - LPW_ref(:,2)).^2);
%     RMSE_LPW3 = sqrt((LPW_obs(:,3) - LPW_ref(:,3)).^2);
% 
%     % 相对误差计算
%     RE_PWV  = abs(PWV_obs - PWV_ref) ./ PWV_ref * 100;
%     RE_LPW1 = abs(LPW_obs(:,1) - LPW_ref(:,1)) ./ LPW_ref(:,1) * 100;
%     RE_LPW2 = abs(LPW_obs(:,2) - LPW_ref(:,2)) ./ LPW_ref(:,2) * 100;
%     RE_LPW3 = abs(LPW_obs(:,3) - LPW_ref(:,3)) ./ LPW_ref(:,3) * 100;
% 
%     % 计算 RMSE 和 RE 的区间
%     RMSE_intervals = [0, 1, 2, 3, 4, 5, 6, 7]; % RMSE 区间
%     RE_intervals = [0, 10, 20, 30, 40, 50, 60, 70]; % 相对误差区间
% 
%     % 计算每一对 RMSE 和 RE 的区间分布
%     RMSE_counts_PWV = histcounts(RMSE_PWV, RMSE_intervals);
%     RMSE_counts_LPW1 = histcounts(RMSE_LPW1, RMSE_intervals);
%     RMSE_counts_LPW2 = histcounts(RMSE_LPW2, RMSE_intervals);
%     RMSE_counts_LPW3 = histcounts(RMSE_LPW3, RMSE_intervals);
% 
%     RE_counts_PWV = histcounts(RE_PWV, RE_intervals);
%     RE_counts_LPW1 = histcounts(RE_LPW1, RE_intervals);
%     RE_counts_LPW2 = histcounts(RE_LPW2, RE_intervals);
%     RE_counts_LPW3 = histcounts(RE_LPW3, RE_intervals);
% 
%     % 填充数据：将季节和产品组合的结果存储到相应位置
%     RMSE_plot_data(s, 1, :) = RMSE_counts_PWV;
%     RMSE_plot_data(s, 2, :) = RMSE_counts_LPW1;
%     RMSE_plot_data(s, 3, :) = RMSE_counts_LPW2;
%     RMSE_plot_data(s, 4, :) = RMSE_counts_LPW3;
% 
%     RE_plot_data(s, 1, :) = RE_counts_PWV;
%     RE_plot_data(s, 2, :) = RE_counts_LPW1;
%     RE_plot_data(s, 3, :) = RE_counts_LPW2;
%     RE_plot_data(s, 4, :) = RE_counts_LPW3;
% end
% 
% % 创建 RMSE 的饼状图
% figure;
% subplot(2, 1, 1);
% for s = 1:4
%     for p = 1:4
%         subplot(4, 4, (s-1)*4 + p);
%         counts = squeeze(RMSE_plot_data(s, p, :));
%         labels = {'0-1', '1-2', '2-3', '3-4', '4-5', '5-6', '6-7'};
% 
%         % 绘制饼图并去掉文本显示
%         pie(counts); % 只绘制饼图，不显示文本
%         if s == 1 && p == 1
%             legend(labels, 'Location', 'best', 'FontSize', 8); % 只保留一个图例
%         end
%     end
% end
% 
% % 创建相对误差的饼状图
% figure;
% subplot(2, 1, 2);
% for s = 1:4
%     for p = 1:4
%         subplot(4, 4, (s-1)*4 + p);
%         counts = squeeze(RE_plot_data(s, p, :));
%         labels = {'0-10%', '10-20%', '20-30%', '30-40%', '40-50%', '50-60%', '60-70%'};
% 
%         % 绘制饼图并去掉文本显示
%         pie(counts); % 只绘制饼图，不显示文本
%         if s == 1 && p == 1
%             legend(labels, 'Location', 'best', 'FontSize', 8); % 只保留一个图例
%         end
%         % title(['Season ' num2str(s) ', Product ' num2str(p)], 'FontSize', 10);
%     end
% end
