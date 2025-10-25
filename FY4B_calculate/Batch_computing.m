
% 定义ERA5的时间范围
ERA5_start_time = datetime(2024, 10, 1, 0, 0, 0);
ERA5_end_time = datetime(2024, 10, 31, 23, 0, 0);
ERA5_times = ERA5_start_time:hours(1):ERA5_end_time; % 逐小时的时间序列
% 
% 设置FY4B文件夹路径
FY4BPath = 'E:\孙悦\浙江金华站点pwv\C202501021302000130\';
FY4Bfilelist = dir([FY4BPath, '*.nc']); % 获取所有FY4B文件
n = length(FY4Bfilelist); % FY4B文件数量

% 初始化FY4B时间数组
FY4B_times = datetime.empty;

for k = 1:n
    FY4Bfilename = FY4Bfilelist(k).name;
    time = FY4Bfilename(45:54); % 获取时间字符串
    FY4B_times(k) = datetime(str2double(time(1:4)), str2double(time(5:6)), str2double(time(7:8)), str2double(time(9:10)), 0, 0);
end

% % 动态存储匹配结果
% data_FY3_struct = struct();

% 匹配ERA5和FY4B数据时间
for m = 1:length(ERA5_times)
    current_time = ERA5_times(m);

    % 查找是否有直接匹配的FY4B时刻
    exact_match = FY4B_times(FY4B_times == current_time);

    if ~isempty(exact_match)
        fprintf('ERA5时间: %s 直接匹配的FY4B时刻为: %s\n', ...
                datestr(current_time, 'yyyy-mm-dd HH:MM:SS'), ...
                datestr(exact_match, 'yyyy-mm-dd HH:MM:SS'));

        match_idx = find(FY4B_times == exact_match, 1);
        FY4Bfile = fullfile(FY4BPath, FY4Bfilelist(match_idx).name);

        % 调用处理函数加载并筛选FY4B数据
        data_FY3 = processFY4BFile(FY4Bfile);

        % 生成动态字段名并存储结果
        date_str = datestr(current_time, 'mmddHH');  % 格式为 MMDDHH，例如 060800
        field_name = ['data_FY3_', date_str];
        data_FY3_struct.(field_name) = data_FY3;  % 存储到结构体中
    end
end

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
% 
function data_FY3 = processFY4BFile(FY4Bfile)
    % 加载FY4B文件中的数据
    fullfilepath = FY4Bfile; % 完整的FY4B文件路径
    MWlon = ncread(fullfilepath, 'MW_Longitude'); % 微波经度
    MWlat = ncread(fullfilepath, 'MW_Latitude'); % 微波纬度
    Surf_Pre = ncread(fullfilepath, 'Surf_Pressure'); % 地表气压
    Surf_Temp = ncread(fullfilepath, 'Surf_Temp'); % 地表温度 (K)
    DEM = ncread(fullfilepath, 'DEM'); % 数字高程模型

    Pre = ncread(fullfilepath, 'Pressure'); % 气压层，101层
    Geo_Hgt = ncread(fullfilepath, 'Geo_Hgt'); % 位势高 (m)
    AT_Prof = ncread(fullfilepath, 'AT_Prof'); % 温廓线
    AT_Prof_QFlag = ncread(fullfilepath, 'AT_Prof_QFlag'); % 温廓线质量指标
    AQ_Prof = ncread(fullfilepath, 'AQ_Prof'); % 比湿 (g/kg)
    AQ_Prof_QFlag = ncread(fullfilepath, 'AQ_Prof_QFlag'); % 比湿质量指标

    % 数据反转（剖面数据从高空到地面）
    pre = Pre(end:-1:1, :);
    Geo_Hgt = Geo_Hgt(:, :, end:-1:1);
    AT_Prof = AT_Prof(:, :, end:-1:1);
    AT_Prof_QFlag = AT_Prof_QFlag(:, :, end:-1:1);
    AQ_Prof = AQ_Prof(:, :, end:-1:1);
    AQ_Prof_QFlag = AQ_Prof_QFlag(:, :, end:-1:1);

    %% 提取FY4B数据中相应经纬度范围内的数据
    % 范围中国及周边区域：70-140E，10-60N
    id1 = find(MWlon <= 140 & MWlon >= 70); % 找到经度在70-140E之间的位置
    lat1 = MWlat(id1);
    id2 = find(lat1 <= 60 & lat1 >= 10); % 找到纬度在10-60N之间的位置
    id3 = id1(id2);

    if ~isempty(id3)
        n = length(MWlon);
        for j = 1:length(id3)
            ls1 = mod(id3(j), n); % 取余数，得行下标
            ls2 = ceil(id3(j) / n); % 向上取整，得列下标
            if ls1 == 0
                ls1 = n;
            end
            rows(j, 1) = ls1;
            cols(j, 1) = ls2;
        end

        for m = 1:length(id3)
            data_FY(m).lon = MWlon(id3(m)); % 经度
            data_FY(m).lat = MWlat(id3(m)); % 纬度

            % data_FY(m).row = rows(m); % 行下标
            % data_FY(m).col = cols(m); % 列下标
            surf_pre(m, 1) = Surf_Pre(id3(m)); % 地表气压
            data_FY(m).surf_pre = surf_pre(m, 1);
            surf_temp(m, 1) = Surf_Temp(id3(m)); % 地表温度 (K)
            dem(m, 1) = DEM(id3(m)); % 数字高程
            at_prof(m, 1, :) = AT_Prof(rows(m), cols(m), :); % 温廓线
            at_QFlag(m, 1, :) = AT_Prof_QFlag(rows(m), cols(m), :); % 温廓线质量
            geoh(m, 1, :) = Geo_Hgt(rows(m), cols(m), :); % 位势高
            aq_prof(m, 1, :) = AQ_Prof(rows(m), cols(m), :); % 比湿
            aq_QFlag(m, 1, :) = AQ_Prof_QFlag(rows(m), cols(m), :); % 比湿质量
        end
    end

    clear AQ_Prof_QFlag AQ_Prof Geo_Hgt AT_Prof_QFlag AT_Prof Surf_Temp Surf_Pre ls2 ls1 id2 id1 lat1 Pre;

    %% 数据筛选与处理
    for i = 1:length(data_FY)
        ls_pre = pre;
        ls_geoh = reshape(geoh(i, 1, :), 101, 1);
        ls_at_prof = reshape(at_prof(i, 1, :), 101, 1);
        ls_at_QFlag = reshape(at_QFlag(i, 1, :), 101, 1);
        ls_aq_prof = reshape(aq_prof(i, 1, :), 101, 1);
        ls_aq_QFlag = reshape(aq_QFlag(i, 1, :), 101, 1);

        id = find(ls_geoh == -999999);
        ls_geoh(id) = [];
        ls_pre(id) = [];
        ls_at_prof(id) = [];
        ls_at_QFlag(id) = [];
        ls_aq_prof(id) = [];
        ls_aq_QFlag(id) = [];

        id = find(ls_at_QFlag < 0 | ls_at_QFlag > 1);
        ls_geoh(id) = [];
        ls_pre(id) = [];
        ls_at_prof(id) = [];
        ls_aq_prof(id) = [];
        ls_aq_QFlag(id) = [];

        id = find(ls_aq_QFlag < 0 | ls_aq_QFlag > 1);
        ls_geoh(id) = [];
        ls_pre(id) = [];
        ls_at_prof(id) = [];
        ls_aq_prof(id) = [];

        data_FY(i).dem = dem(i);
        data_FY(i).pre = ls_pre;
        data_FY(i).geoh = ls_geoh;
        data_FY(i).t = ls_at_prof;
        data_FY(i).q = ls_aq_prof;
    end

  clear ls_aq_QFlag ls_aq_prof ls_at_QFlag ls_at_prof ls_pre ls_geoh aq_prof at_prof at_QFlag aq_QFlag geoh pre id dem;

    % 筛选留下起始高为DEM相应数值的点位数据
    k1=1;
    for i=1:length(data_FY)
        if ~isempty(data_FY(i).geoh) %数据非空
            id=find(data_FY(i).geoh==data_FY(i).dem); %查找geoh=dem的层数

            if length(id)==1 %只有一层geoh数值=dem
                data_FY1(k1)=data_FY(i);
                k=id;
                data_FY1(k1).pre=data_FY(i).pre(k:end,1);
                data_FY1(k1).geoh=data_FY(i).geoh(k:end,1);
                data_FY1(k1).t=data_FY(i).t(k:end,1);
                data_FY1(k1).q=data_FY(i).q(k:end,1);
                k1=k1+1;

            elseif length(id)>1 %不止一层geoh数值=dem
                data_FY1(k1)=data_FY(i);
                k=id(end); %最后一个geoh=dem的层
                data_FY1(k1).pre=data_FY(i).pre(k:end,1);
                data_FY1(k1).geoh=data_FY(i).geoh(k:end,1);
                data_FY1(k1).t=data_FY(i).t(k:end,1);
                data_FY1(k1).q=data_FY(i).q(k:end,1);
                k1=k1+1;

            else %没有geoh=dem的层
                aaa=0;
            end

        end
    end

    if k1>1 %data_FY1存在

        %按照可计算Tm的数据标准筛选数据，先筛掉有效观测层数少于20的点
        k2=1;
        for i=1:length(data_FY1)
            if length(data_FY1(i).pre)>19
                data_FY2(k2)=data_FY1(i);
                k2=k2+1;
            end
        end

        if k2>1 %data_FY2存在

            %再筛掉连续相邻气压层气压差大于200hPa的点（如果前20+层满足条件，第n层不满足，那就只留下前20+层）
            k3=1;
            for i=1:length(data_FY2)
                for j=1:length(data_FY2(i).pre)-1
                    diff(j,1)=data_FY2(i).pre(j)-data_FY2(i).pre(j+1);
                end
                if diff<=200 %气压差都小于200hPa
                    data_FY3(k3)=data_FY2(i);
                    k3=k3+1;
                else %存在气压差都大于200hPa
                    id=find(diff>200,1); %找到第一个气压差大于200hPa的位置
                    if id>20 %气压差小于200hPa的层数是20+
                        data_FY3(k3)=data_FY2(i);
                        k3=k3+1;
                    end
                end
            end
            clear diff data_FY data_FY1 data_FY2;

            if k3>1 %如果data_FY3存在，即多轮筛选之后还有符合要求的数据，那么继续计算

                num=k3-1; %计算Tm数

            end
        end
    end
% 定义 sigma 参数
sigma_values = [1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3,0.2,0.1]';  % sigma_values 为列向量

% 遍历 data_FY3 中的每个数据
for i = 1:numel(data_FY3)
    % 获取当前结构体的 surf_pre
    Psurf = data_FY3(i).surf_pre;

    % 初始化 sigma_pre_values 为与 sigma_values 相同的大小
    sigma_pre_values = zeros(numel(sigma_values), 1);  % 确保它是列向量

    % 对每个 sigma 参数进行计算
    for j = 1:numel(sigma_values)
        sigma = sigma_values(j);  % 当前 sigma 值

        % 进行相应的计算（这里假设我们用 Psurf * sigma 作为示例）
        sigma_pre_values(j) = 0.005+(Psurf-0.005) * sigma;  % 根据实际公式修改这里
    end

    % 将计算出的 sigma_pre_values 存储到当前结构体中
    data_FY3(i).sigma_pre = single(sigma_pre_values);  % 将结果转换为 single 类型
end
% % 遍历 data_FY3 中的每个数据
for i = 1:numel(data_FY3)
    % 读取原始的不规则压力和比湿值
    irregular_pressure = data_FY3(i).pre;  % 原始压力值
    specific_humidity = data_FY3(i).q;     % 比湿值，与压力一一对应

    % 获取新的目标气压层 (即 sigma_pre)
    regular_pressure_levels = data_FY3(i).sigma_pre;  % 替换成结构体中的 sigma_pre

    % 对1000-300 hPa的压力层进行插值
    for j = 1:length(regular_pressure_levels)
        target_pressure = regular_pressure_levels(j);

        if target_pressure >= 0
            % 查找临近的压力值
            if target_pressure >= 300
                % 对于1000到700，查找临近20 hPa的压力值
                nearby_pressures = irregular_pressure(irregular_pressure >= target_pressure - 30 & irregular_pressure <= target_pressure + 30);
            else
                % 对于700到300，查找临近50 hPa的压力值
                nearby_pressures = irregular_pressure(irregular_pressure >= target_pressure - 50 & irregular_pressure <= target_pressure + 50);
            end

            if ~isempty(nearby_pressures)
                % 进行对数插值
                log_irregular_pressure = log(irregular_pressure);
                log_target_pressure = log(target_pressure);
                interpolated_value = interp1(log_irregular_pressure, specific_humidity, log_target_pressure, 'linear', 'extrap');
               interpolated_sh(j) = single(interpolated_value);  % 将比湿度插值结果转为 single 类型并存储
                % interpolated_pressure(j) = single(target_pressure);  % 将插值后的气压值存储为 single 类型
            end
        end
    end

% 检查插值结果中的比湿数据是否足够
num_interpolated_sh = sum(~isnan(interpolated_sh));  % 计算插值出来的有效比湿值数量

if num_interpolated_sh < 10
    fprintf('插值后的比湿数据少于10个，跳过该数据点\n');
    continue;  % 如果比湿值少于10个，跳过当前数据点，继续处理下一个数据
end
% 合并原始数据和插值数据，预分配空间
all_pressures = NaN(length(irregular_pressure) + 10, 1);  % 预分配空间
all_humidities = NaN(length(irregular_pressure) + 10, 1);  % 预分配空间

% 填充原始压力数据
all_pressures(1:length(irregular_pressure)) = irregular_pressure;
all_humidities(1:length(irregular_pressure)) = specific_humidity;

% % 填充插值后的压力数据（如果有的话）
all_pressures(length(irregular_pressure) + 1:length(irregular_pressure) + 10) =  regular_pressure_levels;
all_humidities(length(irregular_pressure) + 1:length(irregular_pressure) + 10) = interpolated_sh;
 % 查并删除重复的气压数据
[all_pressures, unique_indices] = unique(all_pressures, 'first');  % 删除重复的压力值，保留第一次出现的
all_humidities = all_humidities(unique_indices);  % 根据去重后的气压值调整比湿度数据
% 确保合并后的气压和比湿数据按从大到小排序
[all_pressures, sort_indices] = sort(all_pressures, 'descend');  % 按压力从大到小排序
all_humidities = all_humidities(sort_indices);  % 根据排序的索引对比湿值进行排序
    % 存储插值后的比湿度和气压到结构体
    data_FY3(i).pre_cha = all_pressures;  % 插值后的气压存储到 pre_cha
    data_FY3(i).q_cha = all_humidities;  % 插值后的比湿度存储到 q_cha
end

% 假设 data_FY3 是一个结构体数组，q_cha 是其中的一个字段
for i = 1:length(data_FY3)
    % 提取 q_cha 数据
    q_cha_data = data_FY3(i).q_cha;

    % 检测 NaN 值的索引
    nan_indices = isnan(q_cha_data);

    % 删除含有 NaN 值的点
    data_FY3(i).q_cha = q_cha_data(~nan_indices);
end
g = 9.806665; % 重力加速度
for i = 1:length(data_FY3)
    % 初始化 pwv_layer 数组，按列存储
    data_FY3(i).pwv_layer = zeros(length(data_FY3(i).pre_cha)-1, 1);
    % 初始化累加和
    cumulative_pwv = 0;
    for j = 1:length(data_FY3(i).pre_cha) - 1
        % 计算当前层的 PWV_1
        pwv_1 =0.5*(data_FY3(i).q_cha(j,1)+data_FY3(i).q_cha(j+1,1))*(data_FY3(i).pre_cha(j,1)-data_FY3(i).pre_cha(j+1,1))/ g*0.1;
        % 累加当前层的 PWV_1
        cumulative_pwv = cumulative_pwv + pwv_1;
        % 将累加和存储到 pwv_layer 数组中，按列存储
        data_FY3(i).pwv_layer(j) = cumulative_pwv;
    end

    % 计算总的 PWV
    data_FY3(i).pwv_total = cumulative_pwv;
end

for i = 1:numel(data_FY3)
    % 获取当前结构体的 sigma_pre 和 pre_cha
    sigma_pre = data_FY3(i).sigma_pre;
    pre_cha = data_FY3(i).pre_cha;

    % 假设 pwv_layer 也是存在于当前 data_FY3(i) 中
    pwv_layer = data_FY3(i).pwv_layer;

    % 初始化 pwv_select 用于存储提取的值
    pwv_select = NaN(size(sigma_pre));  % 初始化为空值，防止出现无效数据

    % 遍历 sigma_pre 中的每个元素，找到其对应的 pwv_layer 数据
    for j = 1:length(sigma_pre)
        % 假设 pre_cha 和 pwv_layer 之间的关系是通过索引对齐的
        % 这里减去1来找到 pwv_layer 中的对应索引
        pwv_index = find(pre_cha == sigma_pre(j)) - 1;

        % 如果 pwv_index 是有效的，则从 pwv_layer 中提取相应的值
        % 使用 any() 来确保索引是有效的
        if any(pwv_index >= 1 & pwv_index <= length(pwv_layer))
            pwv_select(j) = pwv_layer(pwv_index);
        end
    end

    % 将结果存储到 data_FY3(i).pwv_select 中
    data_FY3(i).pwv_select = pwv_select;
end

% 删除第一个 NaN 值所在的行
for i = 1:numel(data_FY3)
    % 获取当前结构体的 pwv_select 数据
    pwv_select = data_FY3(i).pwv_select;

    % 找到第一个 NaN 的位置
    [row, ~] = find(isnan(pwv_select), 1);  % 找到第一个 NaN 的行

    if ~isempty(row)  % 如果找到了 NaN
        % 删除该行
        pwv_select(row, :) = [];
    end

    % 将结果存回 data_FY3(i).pwv_select
    data_FY3(i).pwv_select = pwv_select;
end
% 
for i = 1:numel(data_FY3)  % 遍历整个 data_FY3 数据集
    % 获取当前结构体的 pwv_select 数据（单列向量）
    pwv_select = data_FY3(i).pwv_select;

    % 确保 pwv_select 至少有 8 个数据
    if numel(pwv_select) >= 8
        % 保留第二列数据
        second_column = pwv_select(1);

        % 计算差值
        diff_3_1 = pwv_select(3) - pwv_select(1);  % 用第四列减去第二列
        diff_7_3 = pwv_select(7) - pwv_select(3);  % 用第八列减去第四列

        % 生成新的数据 LPW
        LPW = [second_column, diff_3_1, diff_7_3];  % 保留第二列，差值列1和差值列2

        % 将结果存储到 data_FY3(i).LPW 中
        data_FY3(i).LPW = LPW;
    else
        warning(['data_FY3(' num2str(i) ') 中的 pwv_select 数据点不足 8，跳过该数据点']);
    end
end



end
