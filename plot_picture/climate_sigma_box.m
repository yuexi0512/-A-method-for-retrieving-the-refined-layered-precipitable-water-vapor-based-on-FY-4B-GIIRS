% 
% % 自定义颜色
% colors = lines(9);  % 美观的调色板
% sigma_labels = 0.9:-0.1:0.1;  % 降序排列，从 0.9 到 0.1
% 
% for zone_idx = 1:4
%     data = climate_zones_merged{zone_idx};
%     truth = data(:, 12:20);
%     observed = data(:, 3:11);
%     residuals = observed - truth;  % N×9
% 
%     figure;
%     boxplot(residuals, 'Colors', 'k', 'Symbol', '');  % 不显示异常值
%     title(['Climate Zone ' num2str(zone_idx) ' Residual Boxplot'], ...
%           'FontName', 'Times New Roman', 'FontSize', 10);
%     ylabel('Residual (mm)', 'FontName', 'Times New Roman', 'FontSize', 10);
%     set(gca, 'FontSize', 10, 'FontName', 'Times New Roman');
% 
%     % 设置 x 轴标签为 sigma 对应的值
%     set(gca, 'XTick', 1:9, 'XTickLabel', arrayfun(@(x) sprintf('%.1f', x), sigma_labels, 'UniformOutput', false));
%     xlabel('sigma', 'FontName', 'Times New Roman', 'FontSize', 10, 'Interpreter', 'tex');
% 
%     % 设置颜色（填充 box）
%     h = findobj(gca, 'Tag', 'Box');
%     for j = 1:length(h)
%         patch(get(h(j), 'XData'), get(h(j), 'YData'), ...
%               colors(length(h)-j+1,:), 'FaceAlpha', 0.5, 'EdgeColor', 'k');
%     end
% 
%     % 计算 Bias 和 RMSE
%     bias_all = zeros(1,9);
%     rmse_all = zeros(1,9);
%     for j = 1:9
%         res_j = residuals(:, j);
%         bias_all(j) = mean(res_j, 'omitnan');
%         rmse_all(j) = sqrt(mean(res_j.^2, 'omitnan'));
%     end
% 
%     % 统一标注高度（位于图上方偏上一些）
%     ylim_vals = ylim;
%     y_text = ylim_vals(2) + 0.05 * range(ylim_vals);
% 
%     % 标注 bias 和 rmse（红色，同一水平线，分两行）
%     for j = 1:9
%         text(j, y_text, ...
%             sprintf('Bias = %.2f\nRMSE = %.2f', bias_all(j), rmse_all(j)), ...
%             'HorizontalAlignment', 'center', ...
%             'FontSize', 8, 'Color', 'r', 'FontWeight', 'bold', ...
%             'FontName', 'Times New Roman');
%     end
% 
%     % 扩大 y 轴范围，留出标注空间
%     ylim([ylim_vals(1), y_text + 0.15 * range(ylim_vals)]);
% end
% % 自定义颜色
% colors = lines(9);  % 美观的调色板
% sigma_labels = 0.9:-0.1:0.1;  % x轴标签从 0.9 到 0.1
% 
% metric_value = struct();  % 用于存储所有区域的 Bias 和 RMSE
% 
% for zone_idx = 1:4
%     data = climate_zones_merged{zone_idx};
%     truth = data(:, 12:20);
%     observed = data(:, 3:11);
%     residuals = observed - truth;  % N×9
% 
%     figure;
%     boxplot(residuals, 'Colors', 'k', 'Symbol', '');
%     title(['Climate Zone ' num2str(zone_idx) ' Residual Boxplot'], ...
%           'FontName', 'Times New Roman', 'FontSize', 10);
%     ylabel('Residual (mm)', 'FontName', 'Times New Roman', 'FontSize', 10);
%     set(gca, 'FontSize', 10, 'FontName', 'Times New Roman');
%     set(gca, 'XTick', 1:9, ...
%              'XTickLabel', arrayfun(@(x) sprintf('%.1f', x), sigma_labels, 'UniformOutput', false));
%     xlabel('sigma', 'FontName', 'Times New Roman', 'FontSize', 10, 'Interpreter', 'tex');
% 
%     h = findobj(gca, 'Tag', 'Box');
%     for j = 1:length(h)
%         patch(get(h(j), 'XData'), get(h(j), 'YData'), ...
%               colors(length(h)-j+1,:), 'FaceAlpha', 0.5, 'EdgeColor', 'k');
%     end
% 
%     % 计算 Bias 和 RMSE
%     bias_all = zeros(1,9);
%     rmse_all = zeros(1,9);
%     for j = 1:9
%         res_j = residuals(:, j);
%         bias_all(j) = mean(res_j, 'omitnan');
%         rmse_all(j) = sqrt(mean(res_j.^2, 'omitnan'));
%     end
% 
%     % 保存当前区域的 Bias 和 RMSE
%     metric_value(zone_idx).zone = zone_idx;
%     metric_value(zone_idx).sigma = sigma_labels;
%     metric_value(zone_idx).bias = bias_all;
%     metric_value(zone_idx).rmse = rmse_all;
% 
%     % 标注图上的 Bias 和 RMSE
%     ylim_vals = ylim;
%     y_text = ylim_vals(2) + 0.05 * range(ylim_vals);
%      % 标注 bias 和 rmse（红色，同一水平线，分两行）
%     for j = 1:9
%         text(j, y_text, ...
%             sprintf('Bias = %.2f\nRMSE = %.2f', bias_all(j), rmse_all(j)), ...
%             'HorizontalAlignment', 'center', ...
%             'FontSize', 8, 'Color', 'r', 'FontWeight', 'bold', ...
%             'FontName', 'Times New Roman');
%     end
% % 
%     ylim([ylim_vals(1), y_text + 0.15 * range(ylim_vals)]);
% end

% figure;
% tiledlayout(9, 4, 'Padding', 'compact', 'TileSpacing', 'compact');
% 
% for var_idx = 1:9           % 变量编号：Val1 ~ Val9
%     for zone_idx = 1:4      % 气候区编号：Zone1 ~ Zone4
%         data = climate_zones_merged{zone_idx};
%          truth = data(:, 3:11);    
%        observed = data(:, 12:20);      
%         residuals = observed - truth;
% 
%         % 子图位置计算：每行是一个变量，每列是一个气候区
%         tile_num = (var_idx - 1) * 4 + zone_idx;
%         nexttile(tile_num);
% 
%         % 绘制残差分布直方图
%         histogram(residuals(:, var_idx), 'Normalization', 'pdf', ...
%             'FaceColor', [0.2 0.6 0.8], 'EdgeColor', 'k');
% 
%         % 添加 0 轴线
%         xline(0, '--r', 'LineWidth', 1);
% 
%         % 设置标题
%         title(['Val' num2str(var_idx) ', Zone' num2str(zone_idx)], 'FontSize', 7);
% 
%         % 坐标轴标签缩小
%         set(gca, 'FontSize', 6);
%         xlabel('Residual', 'FontSize', 6);
%         ylabel('PDF', 'FontSize', 6);
%     end
% end
% 
% % sgtitle('Residual Distributions for 9 Values across 4 Climate Zones', 'FontSize', 12);
% % % 合并 PWV 类数据
% PWV_all = [ PWV01; PWV02; PWV03; PWV04; PWV05; PWV06; PWV07; PWV08; PWV09; PWV10; PWV11; PWV12];
% 
% % 合并 LPW 类数据
% LPW_all = [LPW01; LPW02; LPW03; LPW04; LPW05; LPW06; LPW07; LPW08; LPW09; LPW10; LPW11; LPW12];
% 
% % 合并 PWV_sigma 类数据
% PWV_sigma_all = [PWV_sigma01; PWV_sigma02; PWV_sigma03; PWV_sigma04; PWV_sigma05;
%                  PWV_sigma06; PWV_sigma07; PWV_sigma08; PWV_sigma09; PWV_sigma10;
%                  PWV_sigma11; PWV_sigma12];
