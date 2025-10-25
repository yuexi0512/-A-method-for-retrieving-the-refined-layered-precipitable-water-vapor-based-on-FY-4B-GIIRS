% % 读取Shapefile数据
% shapefile = 'E:\孙悦\中国区域七大气候分区\中国区域七大气候分区Chinese_climate\Chinese_climate_wgs84.shp';
% S = shaperead(shapefile); % 读取Shapefile数据
% % % % 假设LPW_all_merged的列为经度、纬度、观测值、真值
% longitude = LPW_all_merged(:, 1);
% latitude = LPW_all_merged(:, 2);
% % observed_values = LPW_all_merged(:, 3); % 假设观测值在第三列
% % true_values = LPW_all_merged(:, 4); % 假设真值在第四列
% 
% % 合并经纬度信息，避免在每次循环中重复判断
% points = [longitude, latitude];
% 
% % 创建空的存储结构，存储每个气候区的数据
% climate_zones_data = cell(1, length(S));
% 
% % 显示进度
% disp('开始处理气候区...');
% 
% % 对每个气候区，检查数据点是否在该区域内
% for i = 1:length(S)
%     % 获取气候区的多边形边界（经纬度坐标）
%     polygon = S(i).Geometry; % 获取几何类型
%     latitudes = S(i).Y; % 获取纬度坐标
%     longitudes = S(i).X; % 获取经度坐标
% 
%     % 进度提醒
%     disp(['处理气候区 ' num2str(i) '...']);
% 
%     % 使用inpolygon函数判断数据点是否在当前气候区内
%     in_zone = inpolygon(points(:,1), points(:,2), longitudes, latitudes);
% 
%     % 存储在该气候区内的数据
%     climate_zones_data{i} = LPW_all_merged(in_zone, :);
% 
%     % 输出处理进度
%     fprintf('气候区 %d 处理完成！\n', i);
% end
% 
% % 完成处理
% disp('所有气候区的数据提取完毕！');
% LPW_all_merged(:,9) = PWV_all_merged(:,3);  % 将 PWV_all_merged 的第三列赋值到 LPW_all_merged 的第九列
% LPW_all_merged(:,10) = PWV_all_merged(:,4); % 将 PWV_all_merged 的第四列赋值到 LPW_all_merged 的第十列
% % 读取Shapefile数据
% shapefile = 'E:\孙悦\中国区域七大气候分区\中国区域七大气候分区Chinese_climate\Chinese_climate_wgs84.shp';
% S = shaperead(shapefile); % 读取Shapefile数据
% % % % 假设LPW_all_merged的列为经度、纬度、观测值、真值
% longitude = LPW_all_merged(:, 1);
% latitude = LPW_all_merged(:, 2);
% % observed_values = LPW_all_merged(:, 3); % 假设观测值在第三列
% % true_values = LPW_all_merged(:, 4); % 假设真值在第四列
% 
% % 合并经纬度信息，避免在每次循环中重复判断
% points = [longitude, latitude];
% 
% % 创建空的存储结构，存储每个气候区的数据
% climate_zones_data = cell(1, length(S));
% 
% % 显示进度
% disp('开始处理气候区...');
% 
% % 对每个气候区，检查数据点是否在该区域内
% for i = 1:length(S)
%     % 获取气候区的多边形边界（经纬度坐标）
%     polygon = S(i).Geometry; % 获取几何类型
%     latitudes = S(i).Y; % 获取纬度坐标
%     longitudes = S(i).X; % 获取经度坐标
% 
%     % 进度提醒
%     disp(['处理气候区 ' num2str(i) '...']);
% 
%     % 使用inpolygon函数判断数据点是否在当前气候区内
%     in_zone = inpolygon(points(:,1), points(:,2), longitudes, latitudes);
% 
%     % 存储在该气候区内的数据
%     climate_zones_data{i} = LPW_all_merged(in_zone, :);
% 
%     % 输出处理进度
%     fprintf('气候区 %d 处理完成！\n', i);
% end
% 
% % 完成处理
% disp('所有气候区的数据提取完毕！');
% 
% 
% % 读取Shapefile数据
% shapefile = 'E:\孙悦\中国区域七大气候分区\中国区域七大气候分区Chinese_climate\Chinese_climate_wgs84.shp';
% S = shaperead(shapefile); % 读取Shapefile数据
% 
% % 假设LPW_all_merged的列为经度、纬度、观测值、真值
% longitude = LPW_all_merged(:, 1);
% latitude = LPW_all_merged(:, 2);
% 
% % 合并经纬度信息
% points_lon = longitude;
% points_lat = latitude;
% 
% % 预分配区域索引，记录每个点属于哪个气候区（0 表示不属于任何区域）
% zone_index = zeros(size(points_lon));
% 
% % 显示进度
% disp('开始处理气候区...');
% 
% % 对每个气候区，检查哪些点在该区域内
% for i = 1:length(S)
%     % 获取气候区边界
%     latitudes = S(i).Y; % 纬度
%     longitudes = S(i).X; % 经度
% 
%     % 显示进度
%     fprintf('处理气候区 %d/%d...\n', i, length(S));
% 
%     % 判断哪些点在当前气候区
%     in_zone = inpolygon(points_lon, points_lat, longitudes, latitudes);
% 
%     % 记录所属区域编号（若有重叠，以后面的区域为准）
%     zone_index(in_zone) = i;
% end
% % 


%%%%%%%%%%可以计算某一个观测值和真值之间的指标
% % % 创建存储结果的结构体
% climate_zone_metrics = struct();

% % 对每个气候区计算RMSE、MAE、R、Bias和RD
% for i = 1:length(climate_zones_data)
%     % 获取当前气候区的数据
%     data = climate_zones_data{i};
% 
%     % 提取经纬度、观测值和真值
%     lon = data(:, 1); % 经度
%     lat = data(:, 2); % 纬度
%     observed_values = data(:, 9); % 观测值
%     true_values = data(:, 10); % 真值
% 
%     % 计算RMSE
%     RMSE = sqrt(mean((observed_values - true_values).^2));
% 
%     % 计算MAE
%     MAE = mean(abs(observed_values - true_values));
% 
%     % 计算Bias
%     bias = mean(observed_values - true_values);
% 
%     % 计算相关系数R
%     R = corr(observed_values, true_values);
% 
%     % 计算相对误差RD
%     RD = mean(abs(observed_values - true_values) ./ abs(true_values));
% 
%     % 将结果存储到结构体中
%     climate_zone_metrics(i).RMSE = RMSE;
%     climate_zone_metrics(i).MAE = MAE;
%     climate_zone_metrics(i).Bias = bias;
%     climate_zone_metrics(i).R = R;
%     climate_zone_metrics(i).RD = RD;
% 
%     % 输出每个气候区的计算结果
%     fprintf('气候区 %d 的计算结果：\n', i);
%     fprintf('RMSE: %.4f\n', RMSE);
%     fprintf('MAE: %.4f\n', MAE);
%     fprintf('Bias: %.4f\n', bias);
%     fprintf('相关系数 R: %.4f\n', R);
%     fprintf('相对误差 RD: %.4f\n\n', RD);
% end
% % % 创建图形窗口
% figure;
% 
% % 设置经纬度的显示范围
% lon_min = 70;  % 经度最小值
% lon_max = 140; % 经度最大值
% lat_min = 10;  % 纬度最小值
% lat_max = 60;  % 纬度最大值
% 
% % 读取Shapefile（边界数据） - 导入Export_Output_2.shp
% shapefile_path = 'E:\孙悦\Documents\ArcGIS\Export_Output_2.shp';
% S_boundary = shaperead(shapefile_path);
% 
% % 对每个气候区进行绘制
% for i = 1:length(climate_zones_data)
%     % 获取当前气候区的数据
%     data = climate_zones_data{i};
% 
%     % 提取经纬度
%     lon = data(:, 1); % 经度
%     lat = data(:, 2); % 纬度
% 
%     % 绘制当前气候区的经纬度数据点
%     subplot(2, 4, i); % 2行4列，i是子图位置
%     scatter(lon, lat, 10, 'filled'); % 绘制散点图
%     hold on; % 保持当前图形，继续在上面绘制Shapefile边界
% 
%     % 绘制Shapefile的边界
%     for j = 1:length(S_boundary)
%         % 获取边界的经纬度
%         lon_boundary = S_boundary(j).X; % 经度
%         lat_boundary = S_boundary(j).Y; % 纬度
% 
%         % 使用patch函数绘制Shapefile边界
%         patch(lon_boundary, lat_boundary, 'g', 'FaceAlpha', 0.1, 'EdgeColor', 'k');
%     end
% 
%     % 设置标题和坐标轴标签
%     title(['气候区 ' num2str(i)]); % 设置子图标题
%     xlabel('经度'); % x轴标签
%     ylabel('纬度'); % y轴标签
% 
%     % 设置坐标轴范围
%     xlim([lon_min lon_max]); % 限制经度范围
%     ylim([lat_min lat_max]); % 限制纬度范围
% 
%     % 保证坐标轴比例相等，避免地图变形
%     axis equal; 
% end
% 
% % 完成显示
% disp('所有气候区的数据点及边界可视化完成！');
% % 初始化新的气候区存储
% 
% climate_zones_merged = cell(1, 4);
% 
% % 合并指定气候区
% climate_zones_merged{1} = [climate_zones_data{2}; climate_zones_data{5}]; % 2+5
% climate_zones_merged{2} = [climate_zones_data{3}; climate_zones_data{7}]; % 3+7
% climate_zones_merged{3} = [climate_zones_data{1}; climate_zones_data{4}]; % 1+4
% climate_zones_merged{4} = climate_zones_data{6}; % 6 保留
% 
% % % 显示合并完成信息
% disp('气候区合并完成！');
% % 初始化存储误差指标的矩阵
% num_zones = length(climate_zones_merged);
% num_metrics = 5; % RMSE, MAE, R, Bias, RD
% num_vars = 7; % 4 组观测值-真值
% metrics = zeros(num_zones, num_metrics, num_vars);
% 
% % 遍历每个气候区
% for i = 1:num_zones
%     % 获取当前气候区数据
%     data = climate_zones_merged{i};
% 
%     % 提取观测值和真值
%     observed = data(:, [3, 4, 5,6,7,8, 9]);  % 观测值：第 3、4、5、9 列
%     true_values = data(:, [12,13,14,15,16,17,18]); % 真值：第 6、7、8、10 列
% 
%     % 遍历每一列
%     for j = 1:num_vars
%         % 计算误差
%         errors = observed(:, j) - true_values(:, j);
% 
%         % 计算 RMSE
%         RMSE = sqrt(mean(errors.^2, 'omitnan'));
% 
%         % 计算 MAE
%         MAE = mean(abs(errors), 'omitnan');
% 
%         % 计算相关系数 R
%         R = corr(observed(:, j), true_values(:, j), 'Rows', 'complete'); 
% 
%         % 计算 Bias（均值误差）
%         Bias = mean(errors, 'omitnan');
% 
%         % 计算 RD（相对误差，取均值）
%         valid_idx = true_values(:, j) ~= 0; % 过滤掉真值为 0 的数据点
%         RD = mean(abs(errors(valid_idx)) ./ abs(true_values(valid_idx)), 'omitnan'); % 计算相对误差
% 
%         % 存储计算结果
%         metrics(i, :, j) = [RMSE, MAE, R, Bias, RD];
% 
%         % 输出结果
%         fprintf('气候区 %d, 列 %d: RMSE = %.4f, MAE = %.4f, R = %.4f, Bias = %.4f, RD = %.4f\n', ...
%                 i, j, RMSE, MAE, R, Bias, RD);
%     end
% end
% 
% % 显示完成信息
% disp('所有气候区各列误差计算完成！');
% % 创建图形窗口
% figure;
% % 
% % 设置经纬度的显示范围
% lon_min = 70;  % 经度最小值
% lon_max = 140; % 经度最大值
% lat_min = 10;  % 纬度最小值
% lat_max = 60;  % 纬度最大值
% 
% % 读取Shapefile（边界数据） - 导入Export_Output_2.shp
% shapefile_path = 'E:\孙悦\Documents\ArcGIS\Export_Output_2.shp';
% S_boundary = shaperead(shapefile_path);
% 
% % 对每个气候区进行绘制
% for i = 1:length(climate_zones_merged)
%     % 获取当前气候区的数据
%     data = climate_zones_merged{i};
% 
%     % 提取经纬度
%     lon = data(:, 1); % 经度
%     lat = data(:, 2); % 纬度
% 
%     % 绘制当前气候区的经纬度数据点
%     subplot(2, 4, i); % 2行4列，i是子图位置
%     scatter(lon, lat, 5, 'filled'); % 绘制散点图
%     hold on; % 保持当前图形，继续在上面绘制Shapefile边界
% 
%     % 绘制Shapefile的边界
%     for j = 1:length(S_boundary)
%         % 获取边界的经纬度
%         lon_boundary = S_boundary(j).X; % 经度
%         lat_boundary = S_boundary(j).Y; % 纬度
% 
%         % 使用patch函数绘制Shapefile边界
%         patch(lon_boundary, lat_boundary, 'g', 'FaceAlpha', 0.1, 'EdgeColor', 'k');
%     end
% 
%     % 设置标题和坐标轴标签
%     title(['气候区 ' num2str(i)]); % 设置子图标题
%     xlabel('经度'); % x轴标签
%     ylabel('纬度'); % y轴标签
% 
%     % 设置坐标轴范围
%     xlim([lon_min lon_max]); % 限制经度范围
%     ylim([lat_min lat_max]); % 限制纬度范围
% 
%     % 保证坐标轴比例相等，避免地图变形
%     axis equal; 
% end
% 
% % 完成显示
% disp('所有气候区的数据点及边界可视化完成！');
% % 合并所有气候区数据
% china = vertcat(climate_zones_merged{:});
% 
% sum(isnan(china(:, [3,4,5,9]))) % 统计每列 NaN 数量（观测值）
% sum(isnan(china(:, [6,7,8,10]))) % 统计每列 NaN 数量（真值）
% valid_rows = all(~isnan(china(:, [3,4,5,9,6,7,8,10])), 2); % 仅保留没有NaN的行
% china = china(valid_rows, :);
% observed_values = china(:, [3, 4, 5, 9]);
% true_values = china(:, [6, 7, 8, 10]);
% 
% RMSE = sqrt(mean((observed_values - true_values).^2, 'omitnan')); 
% MAE = mean(abs(observed_values - true_values), 'omitnan');
% R = diag(corr(observed_values, true_values, 'Rows', 'complete')); 
% Bias = mean(observed_values - true_values, 'omitnan');
% RD = mean(abs(observed_values - true_values) ./ abs(true_values), 'omitnan') * 100;
% 
% fprintf('全国合并数据 (China) 误差计算结果：\n');
% fprintf('RMSE:  %.4f  %.4f  %.4f  %.4f\n', RMSE);
% fprintf('MAE:   %.4f  %.4f  %.4f  %.4f\n', MAE);
% fprintf('R:     %.4f  %.4f  %.4f  %.4f\n', R);
% fprintf('Bias:  %.4f  %.4f  %.4f  %.4f\n', Bias);
% fprintf('RD(%%): %.2f%%  %.2f%%  %.2f%%  %.2f%%\n', RD);
% % 提取经纬度
% lon = china(:, 1);
% lat = china(:, 2);
% % 
% % 绘制散点图
% figure;
% scatter(lon, lat, 10, 'filled'); % 10是点的大小
% xlabel('经度');
% ylabel('纬度');
% title('全国数据点分布');
% xlim([70 140]); % 限制经度范围
% ylim([10 60]);  % 限制纬度范围
% axis equal; % 保持地图比例
% grid on;

% 显示完成
% disp('全国数据点可视化完成！');
% observation=PWV_all_merged(:,5);
% true=PWV_all_merged(:,14);
% Bias = mean(observation - true, 'omitnan');
% % 设置颜色和标签
% colors = [0 0.4470 0.7410;      % LPW low
%           0.8500 0.3250 0.0980; % LPW middle
%           0.9290 0.6940 0.1250; % LPW high
%           0.4940 0.1840 0.5560];% PWV
% legend_labels = {'LPW low', 'LPW middle', 'LPW high', 'PWV'};
% 
% % 创建图形窗口并调整大小
% figure('Position', [100, 100, 1200, 800]);
% 
% for i = 1:4
%     for j = 1:4
%         subplot(4, 4, (i-1)*4 + j);
%         hold on;
% 
%         data_res = residuals{i}(:, j);
%         data_res = data_res(~isnan(data_res));
% 
%         if isempty(data_res)
%             title(['Climate Zone ' num2str(i) ', Residual ' num2str(j)]);
%             continue;
%         end
% 
%         % 核密度估计并标准化
%         [f, xi] = ksdensity(data_res);
%         f = f / max(f);
% 
%         % 绘制密度图
%         area(xi, f, 'FaceColor', colors(j,:), 'FaceAlpha', 0.5, ...
%             'EdgeColor', colors(j,:));
% 
%         % 添加 x = 0 的参考线
%         xline(0, '--r', 'LineWidth', 1.5);
% 
%         % 计算 BIAS 和 RMSE
%         bias = mean(data_res);
%         rmse = sqrt(mean((data_res).^2));
% 
%         % 显示文本
%         text(7.2, 0.85, ['Bias = ' num2str(bias, '%.2f')], 'Color', 'r', ...
%             'FontSize', 8, 'FontName', 'Times New Roman', 'FontWeight', 'bold');
%         text(7.2, 0.72, ['RMSE = ' num2str(rmse, '%.2f')], 'Color', 'r', ...
%             'FontSize', 8, 'FontName', 'Times New Roman', 'FontWeight', 'bold');
% 
%         % 图形格式美化
%         % title(['Climate Zone ' num2str(i) ', ' legend_labels{j}], ...
%         %     'FontName', 'Times New Roman', 'FontSize', 10);
%         xlabel('Residual Value', 'FontName', 'Times New Roman', ...
%             'FontSize', 10, 'FontWeight', 'bold');
%         ylabel('Density', 'FontName', 'Times New Roman', ...
%             'FontSize', 10, 'FontWeight', 'bold');
%         ylim([0 1]);
%         xlim([-10 10]);
%         grid on;
%         box on;
%     end
% end
% 
% % 添加统一图例（只显示一次）
% legend_ax = axes('Position', [0.3 0.92 0.4 0.05], 'Visible', 'off');
% hold(legend_ax, 'on');
% for k = 1:4
%     plot(legend_ax, NaN, NaN, 's', 'MarkerFaceColor', colors(k,:), ...
%         'MarkerEdgeColor', colors(k,:), 'DisplayName', legend_labels{k});
% end
% legend(legend_ax, 'Orientation', 'horizontal', 'Location', 'northoutside', ...
%     'FontName', 'Times New Roman', 'FontSize', 10);

% % 设置颜色（每组数据一种颜色）
% colors = [0 0.4470 0.7410;  % 蓝色
%           0.8500 0.3250 0.0980;  % 橙色
%           0.9290 0.6940 0.1250;  % 黄色
%           0.4940 0.1840 0.5560]; % 紫色
% 
% % 创建图形窗口
% figure;
% 
% % 对于每个气候区，绘制一幅图，包含该区的四组残差曲线
% for i = 1:4
%     subplot(2, 2, i);  % 2行2列子图
%     hold on;
% 
%     for j = 1:4
%         % 提取残差并移除 NaN
%         data_res = residuals{i}(:, j);
%         data_res = data_res(~isnan(data_res));
% 
%         % 进行核密度估计
%         [f, xi] = ksdensity(data_res);
% 
%         % 标准化密度使纵轴最大为1（可选：也可以直接使用默认密度）
%         f = f / max(f);
% 
%         % 绘制面积图
%         area(xi, f, 'FaceColor', colors(j, :), 'FaceAlpha', 0.4, ...
%              'EdgeColor', colors(j, :), 'DisplayName', ['Col ' num2str(2*j+1) '-' num2str(2*j+2)]);
%     end
% 
%     hold off;
%     % 设置图形属性
%     title(['气候区 ' num2str(i) ' 残差分布']);
%     xlabel('残差值');
%     ylabel('标准化密度');
%     ylim([0 1]);  % 统一纵轴
%     legend('show');
%     grid on;
% end

% % 计算四对观测值之间的RMSE
% rmse_values = cell(1, 4); % 存储四个气候区的RMSE
% 
% for i = 1:4
%     data = climate_zones_merged{i}; % 获取每个气候区的数据
% 
%     % 计算每对观测值的RMSE
%     rmse_values{i}(:, 1) = sqrt(mean((data(:, 3) - data(:, 6)).^2, 2));  % RMSE for Col 3 - Col 6
%     rmse_values{i}(:, 2) = sqrt(mean((data(:, 4) - data(:, 7)).^2, 2));  % RMSE for Col 4 - Col 7
%     rmse_values{i}(:, 3) = sqrt(mean((data(:, 5) - data(:, 8)).^2, 2));  % RMSE for Col 5 - Col 8
%     rmse_values{i}(:, 4) = sqrt(mean((data(:, 9) - data(:, 10)).^2, 2)); % RMSE for Col 9 - Col 10
% end
% 
% % 设置颜色
% colors = [0 0.4470 0.7410;  % 蓝色
%           0.8500 0.3250 0.0980;  % 橙色
%           0.9290 0.6940 0.1250;  % 黄色
%           0.4940 0.1840 0.5560]; % 紫色
% 
% % 创建新的图形窗口
% figure;
% 
% % 绘制每个气候区四个RMSE的密度图
% for i = 1:4
%     for j = 1:4
%         % 每个气候区每对观测值的RMSE
%         subplot(4, 4, (i-1)*4 + j);  % 4行4列子图
%         hold on;
% 
%         % 绘制RMSE密度图，设置BinWidth为1，横轴以1为间隔分布
%         histogram(rmse_values{i}(:, j), 'FaceColor', colors(j, :), 'FaceAlpha', 0.6, ...
%                   'Normalization', 'pdf', 'DisplayName', ['Col ' num2str(2*j+1) '-' num2str(2*j+2)], ...
%                   'BinWidth', 1);
% 
%         hold off;
% 
%         % 设置标题、标签、图例
%         title(['气候区 ' num2str(i) ' RMSE (Col ' num2str(2*j+1) ' - ' num2str(2*j+2) ')']);
%         xlabel('RMSE值');
%         ylabel('密度');
%         legend('show');
%         grid on;
%     end
% end
% 
% % 输出提示信息
% disp('16个RMSE分布密度图绘制完成！');
% % 设置颜色
% colors = [0 0.4470 0.7410;      % 蓝色
%           0.8500 0.3250 0.0980; % 橙色
%           0.9290 0.6940 0.1250; % 黄色
%           0.4940 0.1840 0.5560];% 紫色
% 
% % 修复气候区2第4组残差的异常问题
% i_fix = 2; j_fix = 4;
% res_data = residuals{i_fix}(:, j_fix);
% 
% % 找出非 NaN 和合理范围数据
% valid_idx = ~isnan(res_data) & abs(res_data) < 50; % 可调整阈值
% x = find(valid_idx);
% y = res_data(valid_idx);
% 
% % 使用平滑插值补全整个残差序列
% xq = (1:length(res_data))';
% res_fixed = interp1(x, y, xq, 'pchip', 'extrap'); % 光滑插值
% res_fixed(res_fixed > 50 | res_fixed < -50) = NaN; % 再次清洗异常值
% residuals{i_fix}(:, j_fix) = res_fixed;
% 
% % 创建图形窗口
% figure;
% 
% % 遍历每个气候区和残差组，绘制16幅图
% for i = 1:4
%     for j = 1:4
%         subplot(4, 4, (i-1)*4 + j);  % 4行4列子图
%         hold on;
% 
%         % 取当前残差并清除 NaN
%         data_res = residuals{i}(:, j);
%         data_res = data_res(~isnan(data_res));
% 
%         if isempty(data_res)
%             title(['气候区 ' num2str(i) ', 残差 ' num2str(j)]);
%             continue;
%         end
% 
%         % 核密度估计
%         [f, xi] = ksdensity(data_res);
%         f = f / max(f);  % 标准化
% 
%         % 绘图
%         area(xi, f, 'FaceColor', colors(j,:), 'FaceAlpha', 0.5, ...
%              'EdgeColor', colors(j,:), 'DisplayName', ['Col ' num2str(2*j+1) '-' num2str(2*j+2)]);
% 
%         % 图形美化
%         title(['气候区 ' num2str(i) ' 残差 (Col ' num2str(2*j+1) '-' num2str(2*j+2) ')']);
%         xlabel('残差值');
%         ylabel('标准化密度');
%         ylim([0 1]);
%         legend('show');
%         grid on;
% 
%         % 设置四边框（box on 就够了）
%         box on;
%     end
% end
