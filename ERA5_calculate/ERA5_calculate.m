% % % % 设置数据路径和筛选条件
% data_path = 'G:\ERA5\';
% month = '12'; % 月份，例如 01 表示一月
% parameter_range = [0.25, 1]; % 参数范围
% lat_range = [60, 70]; % 纬度范围
% lon_range = [10, 140]; % 经度范围
% 
% % 获取指定月份的所有文件夹
% month_path = fullfile(data_path, sprintf('ERA5PWV_%s', month));
% if ~isfolder(month_path)
%     error('未找到指定月份文件夹: %s', month_path);
% end
% 
% day_folders = dir(fullfile(month_path, '*_GRID'));
% if isempty(day_folders)
%     error('指定月份文件夹中未找到日数据文件夹: %s', month_path);
% end
% 
% % 遍历所有日数据文件夹
% all_pre_data = [];
% all_sh_data = [];
% 
% for i = 1:length(day_folders)
%     folder_name = day_folders(i).name;
%     folder_path = fullfile(month_path, folder_name);
% 
%     % 构造文件名
%     base_name = regexprep(folder_name, '_GRID$', ''); % 提取基本文件名
%     pre_file = fullfile(folder_path, sprintf('%s_pre_profile.mat', base_name));
%     sh_file = fullfile(folder_path, sprintf('%s_sh_profile.mat', base_name));
% 
%     % 修正文件名范围格式
%     pre_file = regexprep(pre_file, '\[0\.25,1\.00\]', '[0.25,1]');
%     sh_file = regexprep(sh_file, '\[0\.25,1\.00\]', '[0.25,1]');
% 
%     % 检查文件是否存在
%     if ~isfile(pre_file) || ~isfile(sh_file)
%         warning('文件夹 %s 中缺少预期的文件：\n - 预期文件路径: %s \n - 预期文件路径: %s', folder_path, pre_file, sh_file);
%         continue;
%     end
% 
%     % 加载文件
%     fprintf('正在读取文件: %s\n', pre_file);
%     pre_data = load(pre_file);
%     all_pre_data = [all_pre_data; pre_data];
% 
%     fprintf('正在读取文件: %s\n', sh_file);
%     sh_data = load(sh_file);
%     all_sh_data = [all_sh_data; sh_data];
%     longitude=ncread("E:\孙悦\MetCom-test(20241114)\MetCom-test(20241114)\test_data\pressure_level\geopotential\2023\2023020100_2023022823_[0.25,1]_[60.0,10.0,70.0,140.0]_geopotential.nc",'longitude');
%     latitude=ncread("E:\孙悦\MetCom-test(20241114)\MetCom-test(20241114)\test_data\pressure_level\geopotential\2023\2023020100_2023022823_[0.25,1]_[60.0,10.0,70.0,140.0]_geopotential.nc",'latitude');
%     % 初始化JZ为标量结构体
%     for i = 1:56481
%         js_ls1 = ceil(i / 281);  % 计算层索引
%         js_ls2 = mod(i, 281);    % 计算平面点索引
%         if js_ls2 == 0
%             js_ls2 = 281;  % 如果余数为0，则点索引为281
%         end
%         JZ(i).lon=longitude(js_ls2,1);
%         JZ(i).lat=latitude(js_ls1,1); 
%     end
%     for i = 1:56481
%         js_ls1 = ceil(i / 201);  % 计算层索引
%         js_ls2 = mod(i, 201);    % 计算平面点索引
%         if js_ls2 == 0
%             js_ls2 = 201;  % 如果余数为0，则点索引为281
%         end
% 
%     for j=1:24
%             JZ(i).pre(j,1).value =squeeze(pre_data.Data(js_ls1, js_ls2, :,j ));
%             JZ(i).sh(j,1).value =squeeze(sh_data.Data(js_ls1, js_ls2, :,j )) ; % 初始化value为36x1矩阵
%     end
%     end
% % 假设 JZ 是已经存在的结构体数组
% for i = 1:length(JZ)           % 遍历 JZ 中的每个元素
%     for j = 1:length(JZ(i).pre) % 遍历每个 JZ 元素中的 pre (24×1)
%         % 提取每个 pre 中的 value 的第一层数据并存储到 surf_pre
%         JZ(i).pre(j).surf_pre = JZ(i).pre(j).value(1,:); 
%     end
% end
% % 定义 sigma 参数
% sigma_values = [1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1]';  % sigma_values 为列向量
% 
% % 遍历 JZ 中的每个数据
% for i = 1:numel(JZ)
%     % 遍历每个 JZ(i) 元素中的 pre (24×1)
%     for j = 1:numel(JZ(i).pre)
%         % 获取当前 pre 中的 surf_pre
%         Psurf = JZ(i).pre(j).surf_pre;
% 
%         % 初始化 sigma_pre_values 为与 sigma_values 相同的大小
%         sigma_pre_values = zeros(numel(sigma_values), 1);  % 确保它是列向量
% 
%         % 对每个 sigma 参数进行计算
%         for k = 1:numel(sigma_values)
%             sigma = sigma_values(k);  % 当前 sigma 值
% 
%             % 进行相应的计算（假设我们用公式：0.005 + (Psurf - 0.005) * sigma）
%             sigma_pre_values(k) = 0.005 + (Psurf - 0.005) * sigma;  % 根据实际公式修改这里
%         end
% 
%         % 将计算出的 sigma_pre_values 存储到当前 JZ(i).pre(j) 中
%         JZ(i).pre(j).sigma_pre = single(sigma_pre_values);  % 将结果转换为 single 类型
%     end
% end
% % 遍历 JZ 中的每个数据
% for i = 1:numel(JZ)
%     % 遍历每个 JZ(i) 中的 pre
%     for j = 1:numel(JZ(i).pre)
%         % 读取原始的不规则压力和比湿值
%         irregular_pressure = JZ(i).pre(j).value;  % 原始压力值
%         specific_humidity = JZ(i).sh(j).value;    % 比湿值，与压力一一对应
% 
%         % 获取新的目标气压层 (即 sigma_pre)
%         regular_pressure_levels = JZ(i).pre(j).sigma_pre;  % 替换成结构体中的 surf_pre
% 
%         % 对1000-300 hPa的压力层进行插值
%         interpolated_sh = NaN(length(regular_pressure_levels), 1);  % 用于存储插值后的比湿度
% 
%         for k = 1:length(regular_pressure_levels)
%             target_pressure = regular_pressure_levels(k);
% 
%             if target_pressure >= 0
%                 % 找到最接近的上下两个压力值
%                 [~, idx_lower] = min(abs(irregular_pressure - target_pressure));  % 查找最接近的下压力值
%                 % 根据找到的下标获取上下两个压力值
%                 if idx_lower == 1
%                     % 如果下标为1，则只能取第一个和第二个压力值
%                     idx_upper = 2;
%                 elseif idx_lower == numel(irregular_pressure)
%                     % 如果下标为最后一个，则只能取倒数第二个和最后一个压力值
%                     idx_upper = numel(irregular_pressure) - 1;
%                 else
%                     % 如果下标不是极端的，则取上下两个压力值
%                     idx_upper = idx_lower + 1;
%                 end
% 
%                 % 获取上下两个压力值及其对应的比湿度
%                 lower_pressure = irregular_pressure(idx_lower);
%                 upper_pressure = irregular_pressure(idx_upper);
%                 lower_humidity = specific_humidity(idx_lower);
%                 upper_humidity = specific_humidity(idx_upper);
% 
%                 % 对数插值
%                 log_lower_pressure = log(lower_pressure);  % 计算压力的对数
%                 log_upper_pressure = log(upper_pressure);  % 计算压力的对数
%                 log_target_pressure = log(target_pressure); % 计算目标压力的对数
% 
%                 % 对数插值公式
%                 interpolated_value = lower_humidity + (upper_humidity - lower_humidity) * (log_target_pressure - log_lower_pressure) / (log_upper_pressure - log_lower_pressure);
%                 interpolated_sh(k) = single(interpolated_value);  % 将插值结果转为 single 类型并存储
%             end
%         end
% 
%         % 检查插值结果中的比湿数据是否足够
%         num_interpolated_sh = sum(~isnan(interpolated_sh));  % 计算插值出来的有效比湿值数量
% 
% 
%         % 合并原始数据和插值数据，预分配空间
%         all_pressures = NaN(length(irregular_pressure) + length(regular_pressure_levels), 1);  % 预分配空间
%         all_humidities = NaN(length(irregular_pressure) + length(regular_pressure_levels), 1);  % 预分配空间
% 
%         % 填充原始压力数据
%         all_pressures(1:length(irregular_pressure)) = irregular_pressure;
%         all_humidities(1:length(irregular_pressure)) = specific_humidity;
% 
%         % 填充插值后的压力数据（如果有的话）
%         all_pressures(length(irregular_pressure) + 1:length(irregular_pressure) + length(regular_pressure_levels)) = regular_pressure_levels;
%         all_humidities(length(irregular_pressure) + 1:length(irregular_pressure) + length(regular_pressure_levels)) = interpolated_sh;
% 
%         % 查并删除重复的气压数据
%         [all_pressures, unique_indices] = unique(all_pressures, 'first');  % 删除重复的压力值，保留第一次出现的
%         all_humidities = all_humidities(unique_indices);  % 根据去重后的气压值调整比湿度数据
% 
%         % 确保合并后的气压和比湿数据按从大到小排序
%         [all_pressures, sort_indices] = sort(all_pressures, 'descend');  % 按压力从大到小排序
%         all_humidities = all_humidities(sort_indices);  % 根据排序的索引对比湿值进行排序
% 
%         % 存储插值后的比湿度和气压到结构体
%         JZ(i).pre(j).pre_cha = all_pressures;  % 插值后的气压存储到 pre_cha
%         JZ(i).pre(j).sh_cha = all_humidities;  % 插值后的比湿度存储到 sh_cha
% 
% % 遍历 JZ 中的每个数据
% % 检查并删除 NaN 值
% % 对于 pre_cha（气压），删除 NaN 值
% valid_indices_pressures = ~isnan(JZ(i).pre(j).pre_cha);  % 找到非 NaN 值的索引
% JZ(i).pre(j).pre_cha = JZ(i).pre(j).pre_cha(valid_indices_pressures);  % 删除 NaN 值
% 
% % 对于 sh_cha（比湿度），删除 NaN 值
% valid_indices_humidities = ~isnan(JZ(i).pre(j).sh_cha);  % 找到非 NaN 值的索引
% JZ(i).pre(j).sh_cha = JZ(i).pre(j).sh_cha(valid_indices_humidities);  % 删除 NaN 值
%     end
% end
% g = 9.806665; % 重力加速度
% 
% for i = 1:numel(JZ)
%     % 遍历 JZ(i).pre 结构体数组，计算每个 pre 对应的 PWV 和 PWV_layer
%     for k = 1:length(JZ(i).pre)  % 遍历每个 pre 结构体
% 
%         % 获取当前 pre 结构体中的 pre_cha 和 sh_cha
%         pre_cha = JZ(i).pre(k).pre_cha;  % 当前 pre 结构体的 pre_cha
%         sh_cha = JZ(i).pre(k).sh_cha;    % 当前 pre 结构体的 sh_cha
% 
%         % 初始化 pwv_layer 数组，按列存储
%         pwv_layer = zeros(length(pre_cha) - 1, 1); 
% 
%         % 初始化累加和
%         cumulative_pwv = 0;
% 
%         % 计算每层的 PWV_1，并进行累加
%         for j = 1:length(pre_cha) - 1
%             % 计算当前层的 PWV_1
%             pwv_1 = 0.5 * (sh_cha(j) + sh_cha(j + 1)) * ...
%                     (pre_cha(j) - pre_cha(j + 1)) / g * 0.1;  % 使用当前层和下一层的比湿与气压进行计算
% 
%             % 累加当前层的 PWV_1
%             cumulative_pwv = cumulative_pwv + pwv_1;
% 
%             % 将累加和存储到 pwv_layer 数组中，按列存储
%             pwv_layer(j) = cumulative_pwv;
%         end
% 
%         % 将结果存储到 JZ(i).pre(k).PWV_layer 中
%         JZ(i).pre(k).PWV_layer = pwv_layer;  % 存储每个 pre 结构体的 PWV_layer
% 
%         % 计算总的 PWV
%         JZ(i).pre(k).PWV = cumulative_pwv;  % 存储每个 pre 结构体的总 PWV
%     end
% end
% % 遍历 JZ 中的每个数据
% for i = 1:numel(JZ)
%     % 遍历 JZ(i).pre 中的每个 pre 结构体
%     for k = 1:length(JZ(i).pre)  % 遍历每个 pre 结构体
% 
%         % 获取当前 pre 结构体中的 sigma_pre 和 pre_cha
%         sigma_pre = JZ(i).pre(k).sigma_pre;  % 当前 pre 结构体的 sigma_pre
%         pre_cha = JZ(i).pre(k).pre_cha;     % 当前 pre 结构体的 pre_cha
% 
%         % 获取当前 pre 结构体中的 pwv_layer
%         pwv_layer = JZ(i).pre(k).PWV_layer; % 获取 PWV_layer
% 
%         % 初始化 pwv_select 数组，按列存储
%         pwv_select = NaN(size(sigma_pre));  % 初始化为空值，防止出现无效数据
% 
%         % 遍历 sigma_pre 中的每个元素，找到其对应的 pwv_layer 数据
%         for j = 1:length(sigma_pre)
%             % 假设 pre_cha 和 pwv_layer 之间的关系是通过索引对齐的
%             % 这里减去1来找到 pwv_layer 中的对应索引
%             pwv_index = find(pre_cha == sigma_pre(j)) - 1;
% 
%             % 如果 pwv_index 是有效的，则从 pwv_layer 中提取相应的值
%             if any(pwv_index >= 1 & pwv_index <= length(pwv_layer))
%                 pwv_select(j) = pwv_layer(pwv_index);  % 提取对应的 pwv_layer 值
%             end
%         end
% 
%         % 将结果存储到 JZ(i).pre(k).pwv_select 中
%         JZ(i).pre(k).pwv_select = pwv_select;  % 存储每个 pre 结构体的 pwv_select
%     end
% end
% % 遍历 JZ 中的每个数据
% for i = 1:numel(JZ)
%     % 遍历每个 pre 结构体
%     for k = 1:length(JZ(i).pre)
%         % 获取当前 pre 结构体的 pwv_select 数据
%         pwv_select = JZ(i).pre(k).pwv_select;
% 
%         % 找到第一个 NaN 的位置
%         [row, ~] = find(isnan(pwv_select), 1);  % 找到第一个 NaN 的行
% 
%         if ~isempty(row)  % 如果找到了 NaN
%             % 删除该行
%             pwv_select(row, :) = [];
%         end
% 
%         % 将结果存回 JZ(i).pre(k).pwv_select
%         JZ(i).pre(k).pwv_select = pwv_select;
%     end
% end
% % 遍历 JZ 中的每个数据
% for i = 1:numel(JZ)  % 遍历整个 JZ 数据集
%     % 遍历每个 pre 结构体
%     for k = 1:length(JZ(i).pre)  % 遍历每个 JZ(i).pre 中的元素
%         % 获取当前 pre 结构体的 pwv_select 数据
%         pwv_select = JZ(i).pre(k).pwv_select;
% 
%         % 确保 pwv_select 至少有 8 个数据点
%         if numel(pwv_select) >= 8
%             % 保留第二列数据
%             second_column = pwv_select(1);
% 
%             % 计算差值
%             diff_3_2 = pwv_select(3) - pwv_select(1);  % 用第四列减去第二列
%             diff_7_3 = pwv_select(7) - pwv_select(3);  % 用第八列减去第四列
% 
%             % 生成新的数据 LPW
%             LPW = [second_column, diff_3_2, diff_7_3];  % 保留第二列，差值列1和差值列2
% 
%             % 将结果存储到 JZ(i).pre(k).LPW 中
%             JZ(i).pre(k).LPW = LPW;
%         else
%             warning(['JZ(' num2str(i) ').pre(' num2str(k) ') 中的 pwv_select 数据点不足 8，跳过该数据点']);
%         end
%     end
% end
% for i = 1:numel(JZ)  % 遍历整个 JZ 数据集
%     % 删除 JZ(i).pre 结构体中的指定字段
%     if isfield(JZ(i).pre, 'value')
%         JZ(i).pre = rmfield(JZ(i).pre, 'value');
%     end
%     if isfield(JZ(i).pre, 'surf_pre')
%         JZ(i).pre = rmfield(JZ(i).pre, 'surf_pre');
%     end
%     if isfield(JZ(i).pre, 'sigma_pre')
%         JZ(i).pre = rmfield(JZ(i).pre, 'sigma_pre');
%     end
%     if isfield(JZ(i).pre, 'pre_cha')
%         JZ(i).pre = rmfield(JZ(i).pre, 'pre_cha');
%     end
%     if isfield(JZ(i).pre, 'sh_cha')
%         JZ(i).pre = rmfield(JZ(i).pre, 'sh_cha');
%     end
% 
%     % 删除 PWV_layer.PWV_layer 字段
%     if isfield(JZ(i).pre, 'PWV_layer')
%         JZ(i).pre = rmfield(JZ(i).pre, 'PWV_layer');
%     end
%      % 检查 JZ 中是否存在 sh 字段
% if isfield(JZ, 'sh')
%     JZ = rmfield(JZ, 'sh');
% end
% 
% end
% 
% % 获取当前工作区中的所有变量名
% vars = who;

% 获取当前工作区中的所有变量名
vars = who;

% 遍历变量名列表，删除非 JZ、base_name 和 parameter_range 的变量
for i = 1:length(vars)
    if ~strcmp(vars{i}, 'FY4Bpwv') 
        clear(vars{i}); % 删除变量
    end
end

% 
% % 构造保存文件的名称
%     start_time = base_name(1:10); % 假设文件名前10字符表示起始时间，例如2024010200
%     end_time = base_name(12:21);  % 假设文件名12-21字符表示结束时间，例如2024010300
%     output_file = sprintf('%s_%s_[%.2f,%.2f]_[%d,%d,%d,%d]_PWV_profile.mat', ...
%                           start_time, end_time, ...
%                           parameter_range(1), parameter_range(2), ...
%                           lat_range(1), lat_range(2), lon_range(1), lon_range(2));
% output_folder = 'G:\ERA5_PWV\ERA5_PWV12'; % 保存处理结果的文件夹
% if ~isfolder(output_folder)
%     mkdir(output_folder);
% end
%     % 保存结果到目标文件夹
%     save(fullfile(output_folder, output_file), 'JZ');
%     fprintf('结果已保存至: %s\n', fullfile(output_folder, output_file));
% end
