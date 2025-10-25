field_names = fieldnames(data_FY3_struct); % 获取结构体字段名

for i = 1:length(field_names)
    % 提取当前字段数据
    fy3_field = field_names{i};
    struct_array = data_FY3_struct.(fy3_field); % 获取字段中的结构体数组

    % 遍历结构体数组中的每个元素
    for j = 1:numel(struct_array)
        % 检查是否存在 pwv_layer
        if isfield(struct_array(j), 'pwv_select')
            pwv_data = struct_array(j).pwv_select;
        else
            warning('字段 %s 的元素 %d 中不存在 pwv_layer，跳过处理', fy3_field, j);
            continue;
        end

        % 检查 pwv_layer 是否满足至少 9 个元素的长度要求
        if numel(pwv_data) < 9
            warning('字段 %s 的元素 %d 的 pwv_layer 数据长度不足 9 层，跳过处理', fy3_field, j);
            continue;
        end

        % 保留第 2 层
        layer_1 = pwv_data(1);

        % 第 6 层减去第 2 层
        layer_diff_3_1 = pwv_data(3) - pwv_data(1);

        % 第 9 层减去第 6 层
        layer_diff_7_3 = pwv_data(7) - pwv_data(3);

        % 保存 LPW 数据到结构体中
        LPW = [layer_1; layer_diff_3_1; layer_diff_7_3];
        struct_array(j).LPW = LPW; % 正确赋值
    end

    % 更新结构体数组回到原结构体中
    data_FY3_struct.(fy3_field) = struct_array;
end
% 
% % 输出结果
% disp('LPW 计算并保存到 data_FY3_struct 完成');
% disp('结构体字段检查:');
% disp(data_FY3_struct);

% for i = 1:length(field_names)
%     % 提取当前字段数据
%     fy3_field = field_names{i};
%     struct_array = data_FY3_struct.(fy3_field); % 获取字段中的结构体数组
% 
%     % 初始化一个数组，用于存储需要保留的元素索引
%     keep_indices = [];
% 
%     % 遍历结构体数组中的每个元素
%     for j = 1:numel(struct_array)
%         % 检查并获取每个元素的 LPW 字段
%         if isfield(struct_array(j), 'LPW')
%             LPW_data = struct_array(j).LPW;
% 
%             % 检查 LPW 中 NaN 的数量
%             if sum(isnan(LPW_data)) < 1
%                 % 如果 NaN 的数量少于2，添加到保留索引列表中
%                 keep_indices = [keep_indices, j];
%             end
%         else
%             % 如果没有 LPW 字段，也保留该数据点
%             keep_indices = [keep_indices, j];
%         end
%     end
% 
%     % 保留没有多个 NaN 的数据点
%     data_FY3_struct.(fy3_field) = struct_array(keep_indices);
% end
% 
% % 输出结果
% disp('处理完成，删除含有多个 NaN 的 LPW 数据点');
% disp('更新的结构体字段检查:');
% disp(data_FY3_struct);

% % 假设两个结构体分别是 data_FY3_struct 和 data_FY3_struct2
% fields1 = fieldnames(data_FY3_struct);
% fields2 = fieldnames(data_FY3_struct2);
% 
% % 创建一个新的结构体存放合并后的数据
% merged_struct = struct();
% 
% % 合并 data_FY3_struct 的字段
% for i = 1:length(fields1)
%     field_name = fields1{i};
%     merged_struct.(field_name) = data_FY3_struct.(field_name);
% end
% 
% % 合并 data_FY3_struct2 的字段
% for i = 1:length(fields2)
%     field_name = fields2{i};
%     if isfield(merged_struct, field_name)
%         % 如果字段已经存在，检查如何合并
%         merged_struct.(field_name) = [merged_struct.(field_name); data_FY3_struct2.(field_name)];
%     else
%         % 如果字段不存在，直接添加
%         merged_struct.(field_name) = data_FY3_struct2.(field_name);
%     end
% end
% 
% % % 保存合并后的结构体
% % save('merged_data_FY3.mat', 'merged_struct');
% % % 获取 data_FY3_struct 中的所有字段名
% % field_names = fieldnames(data_FY3_struct);
% 
% % 对字段名进行排序，假设所有字段名都以相同的前缀开始，只是结尾的数字不同
% sorted_field_names = sort(field_names);
% 
% % 创建一个新的结构体以存储排序后的数据
% sorted_data_FY3_struct = struct();
% 
% % 将原始结构体中的数据按排序后的字段名重新填充到新结构体中
% for i = 1:length(sorted_field_names)
%     field = sorted_field_names{i};
%     sorted_data_FY3_struct.(field) = data_FY3_struct.(field);
% end
% 
% % 现在 sorted_data_FY3_struct 包含按顺序排列的字段
% data_FY3_struct = sorted_data_FY3_struct;
% 
% % 显示重新排序后的字段
% disp('重新排序后的结构体字段:');
% disp(fieldnames(data_FY3_struct));
% 第二阶段：平均处理无直接匹配的数据
for m = 1:length(ERA5_times)
    current_time = ERA5_times(m);

    % 生成当前时间字段名
    date_str = datestr(current_time, 'mmddHH'); % 格式为 MMDDHH
    field_name = ['data_FY3_', date_str];

    % 检查当前时间是否已经直接匹配
    if isfield(data_FY3_struct, field_name)
        continue;  % 如果已直接匹配，跳过无匹配处理
    end

    % 获取前后1小时的时间
    prev_time = current_time - hours(1);
    next_time = current_time + hours(1);

    % 前后1小时对应的字段名
    prev_date_str = datestr(prev_time, 'mmddHH');
    next_date_str = datestr(next_time, 'mmddHH');
    prev_field = ['data_FY3_', prev_date_str];
    next_field = ['data_FY3_', next_date_str];

    % 检查前后时刻的数据是否存在
    if isfield(data_FY3_struct, prev_field) && isfield(data_FY3_struct, next_field)
        fprintf('ERA5时间: %s 无直接匹配，使用 %s 和 %s 数据进行平均\n', ...
                datestr(current_time, 'yyyy-mm-dd HH:MM:SS'), ...
                datestr(prev_time, 'yyyy-mm-dd HH:MM:SS'), ...
                datestr(next_time, 'yyyy-mm-dd HH:MM:SS'));

        % 提取前后时刻的数据
        data_FY7 = data_FY3_struct.(prev_field);
        data_FY9 = data_FY3_struct.(next_field);

        % 初始化新的结构体
        data_FY8 = struct('lon', [], 'lat', [], 'pwv_select', [], 'pwv_total', []);

        % 遍历 data_FY7 和 data_FY9，提取经纬度
        lon_FY7_rounded = round([data_FY7.lon], 2);
        lat_FY7_rounded = round([data_FY7.lat], 2);

        lon_FY9_rounded = round([data_FY9.lon], 2);
        lat_FY9_rounded = round([data_FY9.lat], 2);

        % 找到共同的经纬度
        [common_coords, idx_FY7, idx_FY9] = intersect([lon_FY7_rounded', lat_FY7_rounded'], ...
                                                      [lon_FY9_rounded', lat_FY9_rounded'], 'rows');

       % 使用循环填充新的结构体
for i = 1:size(common_coords, 1)
    data_FY8(i).lon = common_coords(i, 1);
    data_FY8(i).lat = common_coords(i, 2);

      % 获取对应的 pwv_layer 数据
    pwv_FY7 = data_FY7(idx_FY7(i)).pwv_select;
    pwv_FY9 = data_FY9(idx_FY9(i)).pwv_select;
    pwvt_FY7 = data_FY7(idx_FY7(i)).pwv_total;
    pwvt_FY9 = data_FY9(idx_FY9(i)).pwv_total;
     LPW_FY7 = data_FY7(idx_FY7(i)).LPW;
    LPW_FY9 = data_FY9(idx_FY9(i)).LPW;

    % 计算每个数据的平均值并分别存储
    data_FY8(i).pwv_select = zeros(1, 9); % 初始化 pwv_layer
    for j = 1:9
        data_FY8(i).pwv_select(j) = mean([pwv_FY7(j), pwv_FY9(j)]);  % 对每个值取平均
    end
    for l=1:3
        data_FY8(i).LPW(l) = mean([LPW_FY7(l), LPW_FY9(l)]);  % 对每个值取平均
    end

   data_FY8(i).pwv_total = mean([pwvt_FY7, pwvt_FY9]);  % 对每个值取平均
end

        % 将平均处理后的数据存储到动态结构体
        data_FY3_struct.(field_name) = data_FY8;

    else
        fprintf('ERA5时间: %s 无足够数据进行平均\n', datestr(current_time, 'yyyy-mm-dd HH:MM:SS'));
    end
end


% 第三阶段：清理数据，保留必要字段
fields_to_keep = {'lon', 'lat', 'pwv_total', 'pwv_select','LPW'};
all_fields = fieldnames(data_FY3_struct);

for i = 1:numel(all_fields)
    struct_data = data_FY3_struct.(all_fields{i});
    % 直接重建结构体，只保留需要的字段
    data_FY3_struct.(all_fields{i}) = rmfield(struct_data, setdiff(fieldnames(struct_data), fields_to_keep));
end
