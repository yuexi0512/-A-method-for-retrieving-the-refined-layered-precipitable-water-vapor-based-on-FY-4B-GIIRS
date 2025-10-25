
% 第一组数据
Data1_A = [19.88091311, 20.82366569, 22.38473693, 27.03170443, 33.12583707, 37.39215929, 41.62401255, 43.95397499, 35.90257888, 26.64391178, 24.68145319, 23.808465];
Data1_B = [20.40475507, 20.94480965, 23.28127037, 28.62021016, 34.75152812, 39.55689041, 43.95915274, 46.4692016, 38.57936891, 28.16040938, 25.97412824, 24.654264];

% 第二组数据
% Data5_A = [2.0536, 2.1298, 2.3191, 2.7884, 3.025, 3.353, 3.5921, 3.694, 3.5074, 2.5376, 2.5174, 2.4203];
Data5_A = [2.7956, 2.9008, 3.1166, 3.6272, 3.8623, 4.1616, 4.379, 4.4895, 4.3395, 3.3826, 3.338, 3.2323];
Data5_B = [4.7685, 4.731, 4.673, 4.656, 4.7005, 4.583, 4.249, 4.3395, 4.617, 4.7965, 4.7825, 4.7605];

% 第三组数据
Data2_A = [7.8283, 8.3379, 12.6678, 10.4676, 11.9593, 12.7839, 14.6379, 14.8658, 12.6179, 9.7546, 9.3171, 9.1978];
Data2_B = [8.3183, 8.7669, 9.755, 11.4555, 12.839, 14.0273, 16.0514, 16.0328, 13.7907, 10.493, 10.0838, 9.8326];

% 第四组数据
% Data6_A = [1.0602, 1.1037, 1.2262, 1.5038, 1.4523, 1.6182, 1.7697, 1.5905, 1.4749, 1.1524, 1.212, 1.1152];
Data6_A = [1.442, 1.5007, 1.6453, 1.9571, 1.8645, 2.058, 2.2142, 2.0184, 1.8735, 1.5518, 1.6082, 1.5132];
Data6_B = [4.5735, 4.486, 4.3955, 4.245, 4.374, 3.909, 2.9065, 3.291, 4.215, 4.593, 4.5865, 4.6305];

% 第五组数据
Data3_A = [8.8, 9.4784, 7.313, 12.0394, 14.6641, 16.4372, 18.4161, 19.426, 15.9711, 11.6117, 10.7165, 10.6748];
Data3_B = [8.7195, 9.1241, 10.05, 12.2126, 14.791, 16.6237, 18.4144, 19.9019, 16.5142, 11.8391, 10.8624, 10.6641];

% 第六组数据
% Data7_A = [1.3362, 1.4537, 1.3992, 1.5821, 1.6228, 1.6634, 1.7724, 1.7398, 1.6488, 1.3879, 1.434, 1.5057];
Data7_A = [1.8677, 1.9976, 1.8919, 2.1025, 2.1222, 2.1437, 2.235, 2.2046, 2.1216, 1.9082, 1.9755, 2.0827];
Data7_B = [4.528, 4.445, 4.456, 4.465, 4.5565, 4.4155, 3.948, 4.1085, 4.5275, 4.6715, 4.6335, 4.551];

% 第七组数据
Data4_A = [3.1863, 2.9316, 2.3738, 4.4506, 6.4077, 8.048, 8.4436, 9.5175, 7.2073, 5.1962, 4.5651, 3.8569];
Data4_B = [3.2996, 2.983, 3.4064, 4.8615, 7.002, 8.747, 9.3266, 10.3382, 8.1324, 5.7304, 4.932, 4.0762];

% 第八组数据
Data8_A = [0.9104, 1.0008, 0.8927, 1.1349, 1.4327, 1.7157, 1.766, 1.8512, 1.7156, 1.2914, 1.2051, 1.1345];
Data8_B = [4.4095, 4.299, 4.2735, 4.315, 4.394, 4.3635, 4.0905, 4.2165, 4.3585, 4.593, 4.522, 4.3695];

% 数据闭合（首尾相连）
for i = 1:8
    eval(['Data' num2str(i) '_A = [Data' num2str(i) '_A, Data' num2str(i) '_A(1)];']);
    eval(['Data' num2str(i) '_B = [Data' num2str(i) '_B, Data' num2str(i) '_B(1)];']);
    maxVal = max([eval(['Data' num2str(i) '_A']), eval(['Data' num2str(i) '_B'])]);
    stepSize = ceil(maxVal / 5);  % 确保6个刻度（0开始）
    eval(['radii' num2str(i) ' = 0:stepSize:stepSize*5;']);
end

% 闭合角度（12个月 + 闭合点）
theta = linspace(0, 2*pi, 13);

% 创建可调节布局的图形窗口，调整窗口尺寸（17mm宽），并增加底部空隙
figure('Units', 'centimeters', 'Position', [2, 2, 17, 10]); % 增加高度为10cm，预留下方空间

% 更改布局为2行4列，并适当调整间距，向上移动下方子图
tiledlayout(2, 4, 'Padding', 'compact', 'TileSpacing', 'compact');

% 定义月份
months = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', ...
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};

% 绘制8个蛛网图
for i = 1:8
    nexttile;
    hold on;
    axis equal;

    % 动态刻度圈
    eval(['radii = radii' num2str(i) ';']);

    % 绘制蛛网（刻度线）
    for j = 1:length(radii)
        [x_circ, y_circ] = pol2cart(theta, radii(j) * ones(size(theta)));
        if j == length(radii)
            plot(x_circ, y_circ, 'k-', 'LineWidth', 1);
        else
            plot(x_circ, y_circ, 'k--', 'LineWidth', 0.5);
        end
    end

    % 添加刻度值到蛛网内侧（简化为整数）
    offset = max(radii) * 0.05;
    for j = 1:length(radii)
        [x_txt, y_txt] = pol2cart(0, radii(j) - offset);
        label = num2str(radii(j));
        text(x_txt, y_txt, label, 'HorizontalAlignment', 'right', ...
            'FontName', 'Times New Roman', 'FontSize', 7, 'Color', 'r');
    end

    % 绘制径向线（12个月）
    for j = 1:12
        [x_line, y_line] = pol2cart(theta(j), [0, max(radii)]);
        plot(x_line, y_line, 'k--', 'LineWidth', 0.5);
    end

    % 极坐标转笛卡尔坐标
    eval(['[x_DataA, y_DataA] = pol2cart(theta, Data' num2str(i) '_A);']);
    eval(['[x_DataB, y_DataB] = pol2cart(theta, Data' num2str(i) '_B);']);

    % 绘制两组数据的蛛网图
    patch(x_DataA, y_DataA, [0 0.4470 0.7410], 'FaceAlpha', 0.3, ...
        'EdgeColor', [0 0.4470 0.7410], 'LineWidth', 1.5);
    patch(x_DataB, y_DataB, [0.8500 0.3250 0.0980], 'FaceAlpha', 0.3, ...
        'EdgeColor', [0.8500 0.3250 0.0980], 'LineWidth', 1.5);

    % 设置月份标签（稍微外移）
    for j = 1:12
        [x_txt, y_txt] = pol2cart(theta(j), max(radii) + offset * 2.5);
        text(x_txt, y_txt, months{j}, 'HorizontalAlignment', 'center', ...
            'FontName', 'Times New Roman', 'FontSize', 8);
    end
    % 
    % % 优化图例（固定位置，避免遮挡）
    % legend({'Data A', 'Data B'}, 'Location', 'bestoutside', ...
    %        'FontName', 'Times New Roman', 'FontSize', 8);

    axis off;
end
% 
% % 在图形下方预留文本区域
% annotation('textbox', [0.1, 0.2, 0.8, 0.05], 'String', '', 'EdgeColor', 'none', ...
%            'FontName', 'Times New Roman', 'FontSize', 8, 'HorizontalAlignment', 'center');

