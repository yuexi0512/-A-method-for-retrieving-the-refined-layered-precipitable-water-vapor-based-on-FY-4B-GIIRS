% % % 
folder_path = "G:\实验及论文撰写\LPW相关内容\ERA5_PWV\ERA5_PWV02\";

file_list = dir(fullfile(folder_path, '*_PWV_profile.mat'));

% load("G:\分层大气可降水量\LPW-FY4B\FY202305.mat")

% % 初始化存储数据的结构体数组

% 假设 data_FY3_struct 是载入的 FY3 数据结构体，其中包含字段，例如 'data_FY3_120101'（类似于该字段名）
% 遍历每个文件
for n =1:length(file_list)
    % 获取当前文件的完整路径
    file_name = file_list(n).name;
    file_path = fullfile(folder_path, file_name);
    % 
    % 显示正在读取的文件
    disp(['Loading file: ', file_name]);
    load(file_path);


    lon_start = 70; lon_end = 140; % 经度范围
    lat_start = 60; lat_end = 10;  % 纬度范围
    lon_values = lon_start:0.25:lon_end; % 经度序列
    lat_values = lat_start:-0.25:lat_end; % 纬度序列（从北到南）
    counter = 1; % 索引计数
    % 处理 JZ 数据
    for i = 1:length(lon_values)
        for m = 1:length(lat_values)
            % 逐点赋值到 JZ
            JZ(counter).lon = lon_values(i); % 设置经度
            JZ(counter).lat = lat_values(m); % 设置纬度
            % 保留原有的 pre 数据，假设数据本身是正确的
            counter = counter + 1; % 更新计数
        end
    end
     for j=1:24
        for i=1:length(JZ)
            ERA5(i).lon=JZ(i).lon;
            ERA5(i).lat=JZ(i).lat;

            ERA5(i).pwv=JZ(i).pre(j).PWV;
            ERA5(i).lpw=JZ(i).pre(j).LPW;
            ERA5(i).pwv_sigma=JZ(i).pre(j).pwv_select;          
        end
        % 动态生成字段名，例如 'data_FY3_010100' 对应 1月1日 00时
            date_str = sprintf('%02d%02d%02d',2,n , j-1);  % 格式化日期为 010100（1月1日 00时）

            % 构建结构体变量名
            field_name = ['data_FY3_' date_str];  % 例如 'data_FY3_010100'

            % 检查 data_FY3_struct 是否包含该字段
            if isfield(data_FY3_struct, field_name)
                % 提取对应时间点的数据
                data_FY3 = data_FY3_struct.(field_name);
            else
                % 如果没有该时间点的数据，跳过当前时间步
                disp(['No data for ' date_str ' in FY3 dataset, skipping.']);
                continue; % 跳过当前时间步的处理
            end
            % 假设 data_FY3 包含纬度和经度
            FY3_lon = [data_FY3.lon];  % FY3的经度数据
            FY3_lat = [data_FY3.lat];  % FY3的纬度数据

            % 假设 ERA5 结构体包含纬度和经度
            JZ_lon = [ERA5.lon];  % JZ的经度数据
            JZ_lat = [ERA5.lat];  % JZ的纬度数据

            % 设定删除距离的阈值，例如 0.1（根据需要调整）
            distance_threshold = 0.1;

            % 创建一个逻辑数组，用于标记需要保留的 JZ 点
            keep_points = false(size(JZ_lon));

            % 遍历 JZ 结构体中的每一个点，计算与 FY3 点的距离
            for i = 1:length(JZ_lon)
                distances = (FY3_lat - JZ_lat(i)).^2 + (FY3_lon - JZ_lon(i)).^2;
                [min_distance, ~] = min(distances);  % 仅关心最小距离
                keep_points(i) = min_distance <= distance_threshold;  % 如果小于阈值，保留该点
            end

           % 提取 ERA5 数据中的经纬度和待插值变量
            lon_ERA5 = [ERA5.lon];
            lat_ERA5 = [ERA5.lat];
            pwv_ERA5 = [ERA5.pwv];
            lpw_ERA5 = vertcat(ERA5.lpw); % 转换为矩阵（每行对应一个点）
            % 初始化变量，确保 pwv_sigma 的所有分量格式一致
            expected_num_components = 9; % 每个点的分量数量应为 9
            
            % 遍历 ERA5 数据，确保每个 pwv_sigma 是长度为 9 的行向量
            for i = 1:length(ERA5)
                if isvector(ERA5(i).pwv_sigma)
                    ERA5(i).pwv_sigma = ERA5(i).pwv_sigma(:)'; % 转为行向量
                end
                
                % 如果长度不足 9，用 NaN 填充；如果长度超过 9，截取前 9 个
                num_components = length(ERA5(i).pwv_sigma);
                if num_components < expected_num_components
                    ERA5(i).pwv_sigma = [ERA5(i).pwv_sigma, NaN(1, expected_num_components - num_components)];
                elseif num_components > expected_num_components
                    ERA5(i).pwv_sigma = ERA5(i).pwv_sigma(1:expected_num_components);
                end
            end
            
            % 拼接所有数据点为矩阵
            pwv_sigma_ERA5 = vertcat(ERA5.pwv_sigma);
            
            % 获取 lpw 和 pwv_sigma 的维度
            [num_ERA5_points, num_lpw_components] = size(lpw_ERA5);
            [~, num_sigma_components] = size(pwv_sigma_ERA5);
            
            % 初始化插值后的数据数组
            interpolated_PWV_ERA5 = NaN(length(data_FY3), 1);  % 初始化插值后的 PWV 数组
            interpolated_LPW_ERA5 = NaN(length(data_FY3), num_lpw_components);  % 初始化插值后的 LPW 数组
            interpolated_PWV_Sigma_ERA5 = NaN(length(data_FY3), num_sigma_components);  % 初始化插值后的 PWV Sigma 数组
            
            % 遍历每个 FY3 数据点进行插值
            for i = 1:length(data_FY3)
                lon_FY4A = data_FY3(i).lon;  % FY3的经度
                lat_FY4A = data_FY3(i).lat;  % FY3的纬度
            
                % 计算与每个 ERA5 点的距离，找到最近的四个点
                distances = sqrt((lon_ERA5 - lon_FY4A).^2 + (lat_ERA5 - lat_FY4A).^2);
                [~, closest_indices] = sort(distances);  % 排序并选取最近的4个点
            
                % 获取这四个点的值
                pwv_closest = pwv_ERA5(closest_indices(1:4));
                lpw_closest = lpw_ERA5(closest_indices(1:4), :); % 获取 LPW 的所有分量
                pwv_sigma_closest = pwv_sigma_ERA5(closest_indices(1:4), :); % 获取 PWV Sigma 的所有分量
            
                % 如果四个点的经纬度不唯一或不成矩形，返回 NaN
                if length(unique(lon_ERA5(closest_indices(1:4)))) < 2 || ...
                   length(unique(lat_ERA5(closest_indices(1:4)))) < 2
                    continue;
                end
            
                % 获取矩形区域的经纬度
                lon_closest = lon_ERA5(closest_indices(1:4));
                lat_closest = lat_ERA5(closest_indices(1:4));
                [lon_min, lon_max] = bounds(lon_closest);
                [lat_min, lat_max] = bounds(lat_closest);
            
                % 如果 FY3 点不在矩形区域内，返回 NaN
                if lon_FY4A < lon_min || lon_FY4A > lon_max || lat_FY4A < lat_min || lat_FY4A > lat_max
                    continue;
                end
            
                % 获取矩形四个角点的值
                f11_pwv = pwv_closest(lon_closest == lon_min & lat_closest == lat_min);
                f12_pwv = pwv_closest(lon_closest == lon_min & lat_closest == lat_max);
                f21_pwv = pwv_closest(lon_closest == lon_max & lat_closest == lat_min);
                f22_pwv = pwv_closest(lon_closest == lon_max & lat_closest == lat_max);
            
                % 防止 PWV 数据异常
                if isempty(f11_pwv) || isempty(f12_pwv) || isempty(f21_pwv) || isempty(f22_pwv)
                    continue;
                end
            
                % 插值 PWV
                interpolated_PWV_ERA5(i) = (f11_pwv * (lon_max - lon_FY4A) * (lat_max - lat_FY4A) + ...
                                            f21_pwv * (lon_FY4A - lon_min) * (lat_max - lat_FY4A) + ...
                                            f12_pwv * (lon_max - lon_FY4A) * (lat_FY4A - lat_min) + ...
                                            f22_pwv * (lon_FY4A - lon_min) * (lat_FY4A - lat_min)) / ...
                                           ((lon_max - lon_min) * (lat_max - lat_min));
            
                % 插值 LPW（每个分量分别插值）
                for m= 1:num_lpw_components
                    f11_lpw = lpw_closest(lon_closest == lon_min & lat_closest == lat_min, m);
                    f12_lpw = lpw_closest(lon_closest == lon_min & lat_closest == lat_max, m);
                    f21_lpw = lpw_closest(lon_closest == lon_max & lat_closest == lat_min, m);
                    f22_lpw = lpw_closest(lon_closest == lon_max & lat_closest == lat_max, m);
            
                    % 防止 LPW 数据异常
                    if isempty(f11_lpw) || isempty(f12_lpw) || isempty(f21_lpw) || isempty(f22_lpw)
                        continue;
                    end
            
                    interpolated_LPW_ERA5(i, m) = (f11_lpw * (lon_max - lon_FY4A) * (lat_max - lat_FY4A) + ...
                                                   f21_lpw * (lon_FY4A - lon_min) * (lat_max - lat_FY4A) + ...
                                                   f12_lpw * (lon_max - lon_FY4A) * (lat_FY4A - lat_min) + ...
                                                   f22_lpw * (lon_FY4A - lon_min) * (lat_FY4A - lat_min)) / ...
                                                  ((lon_max - lon_min) * (lat_max - lat_min));
                end
            
                % 插值 PWV Sigma（每个分量分别插值）
                for m = 1:num_sigma_components
                    f11_sigma = pwv_sigma_closest(lon_closest == lon_min & lat_closest == lat_min, m);
                    f12_sigma = pwv_sigma_closest(lon_closest == lon_min & lat_closest == lat_max, m);
                    f21_sigma = pwv_sigma_closest(lon_closest == lon_max & lat_closest == lat_min, m);
                    f22_sigma = pwv_sigma_closest(lon_closest == lon_max & lat_closest == lat_max, m);
            
                    % 防止 PWV Sigma 数据异常
                    if isempty(f11_sigma) || isempty(f12_sigma) || isempty(f21_sigma) || isempty(f22_sigma)
                        continue;
                    end
            
                    interpolated_PWV_Sigma_ERA5(i, m) = (f11_sigma * (lon_max - lon_FY4A) * (lat_max - lat_FY4A) + ...
                                                         f21_sigma * (lon_FY4A - lon_min) * (lat_max - lat_FY4A) + ...
                                                         f12_sigma * (lon_max - lon_FY4A) * (lat_FY4A - lat_min) + ...
                                                         f22_sigma * (lon_FY4A - lon_min) * (lat_FY4A - lat_min)) / ...
                                                        ((lon_max - lon_min) * (lat_max - lat_min));
                end
            end
            
            % 将插值后的 ERA5 数据存储到 FY3 结构体中
            for i = 1:length(data_FY3)
                data_FY3(i).PWV_ERA5 = interpolated_PWV_ERA5(i);
                data_FY3(i).LPW_ERA5 = interpolated_LPW_ERA5(i, :); % 存储所有分量
                data_FY3(i).PWV_Sigma_ERA5 = interpolated_PWV_Sigma_ERA5(i, :); % 存储所有分量
            end

            % 计算差值
            difference_PWV = arrayfun(@(x) x.pwv_total - x.PWV_ERA5, data_FY3);
            valid_difference_PWV = difference_PWV(~isnan(difference_PWV));  % 移除NaN值
            % % 初始化存储差值的数组
            difference_PWV = zeros(length(data_FY3), 1);
            % 计算风云自身 PWV 和插值自 ERA5 的 PWV 差值
            for i = 1:length(data_FY3)
                if ~isnan(data_FY3(i).PWV_ERA5) && ~isnan(data_FY3(i).pwv_total)
                    difference_PWV(i) = data_FY3(i).pwv_total - data_FY3(i).PWV_ERA5;
                else
                    difference_PWV(i) = NaN; % 如果有任何一方为空，差值设为 NaN
                end
                data_FY3(i).pwv_diff = difference_PWV(i); % 存储差值
            end
            
            % 如果需要移除整个结构体中对应 NaN 的元素：
            data_FY3 = data_FY3(~isnan([data_FY3.pwv_diff]));
            FY4Bpwv(n).Feb(j,1).value=data_FY3;

      end

end