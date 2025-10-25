 % 创建一个新的图形窗口
% figure;
% 
% % 第一个子图：LPWhigh Bias 和 LPWhigh RMSE
% subplot(4, 1, 1);  % 4行1列中的第1个位置
% bar(time_doy, LPWhigh_bias, 'FaceColor', [1, 0.647, 0], 'EdgeColor', 'none');
% hold on;
% bar(time_doy, LPWhigh_RMSE, 'FaceColor', [0.301, 0.745, 1], 'EdgeColor', 'none');
% xlabel('时间 (DOY)', 'FontSize', 10, 'FontName', 'Times New Roman');
% ylabel('精度指标 (mm)', 'FontSize', 10, 'FontName', 'Times New Roman');
% legend({'LPWhigh Bias', 'LPWhigh RMSE'}, 'Location', 'Best', 'FontSize', 10, 'FontName', 'Times New Roman');
% grid on;
% 
% % 第二个子图：LPWlow Bias 和 LPWlow RMSE
% subplot(4, 1, 2);  % 4行1列中的第2个位置
% bar(time_doy, LPWlow_bias, 'FaceColor', [1, 0.647, 0], 'EdgeColor', 'none');
% hold on;
% bar(time_doy, LPWlow_RMSE, 'FaceColor', [0.301, 0.745, 1], 'EdgeColor', 'none');
% xlabel('时间 (DOY)', 'FontSize', 10, 'FontName', 'Times New Roman');
% ylabel('精度指标 (mm)', 'FontSize', 10, 'FontName', 'Times New Roman');
% legend({'LPWlow Bias', 'LPWlow RMSE'}, 'Location', 'Best', 'FontSize', 10, 'FontName', 'Times New Roman');
% grid on;
% 
% % 第三个子图：LPWmid Bias 和 LPWmid RMSE
% subplot(4, 1, 3);  % 4行1列中的第3个位置
% bar(time_doy, LPWmid_bias, 'FaceColor', [1, 0.647, 0], 'EdgeColor', 'none');
% hold on;
% bar(time_doy, LPWmid_RMSE, 'FaceColor', [0.301, 0.745, 1], 'EdgeColor', 'none');
% xlabel('时间 (DOY)', 'FontSize', 10, 'FontName', 'Times New Roman');
% ylabel('精度指标 (mm)', 'FontSize', 10, 'FontName', 'Times New Roman');
% legend({'LPWmid Bias', 'LPWmid RMSE'}, 'Location', 'Best', 'FontSize', 10, 'FontName', 'Times New Roman');
% grid on;
% 
% % 第四个子图：PWV Bias 和 PWV RMSE
% subplot(4, 1, 4);  % 4行1列中的第4个位置
% bar(time_doy, PWV_bias, 'FaceColor', [1, 0.647, 0], 'EdgeColor', 'none');
% hold on;
% bar(time_doy, PWV_RMSE, 'FaceColor', [0.301, 0.745, 1], 'EdgeColor', 'none');
% xlabel('时间 (DOY)', 'FontSize', 10, 'FontName', 'Times New Roman');
% ylabel('精度指标 (mm)', 'FontSize', 10, 'FontName', 'Times New Roman');
% legend({'PWV Bias', 'PWV RMSE'}, 'Location', 'Best', 'FontSize', 10, 'FontName', 'Times New Roman');
% grid on;