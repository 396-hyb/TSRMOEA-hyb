for k = 1:5
    % 加载 Excel 数据
    % k = 3;
    filename = ['E:\ExperimentResults\TSRMOEA\Lambda-TP',num2str(k),'.xlsx']; % Excel 文件名
    data = readmatrix(filename);  % 读取数据

    % 提取 x 坐标和 y 值
    x = data(1, :);  % 第一行是 x 坐标值
    y = data(2:end, :);  % 后续的每一行是 y 值（多个函数的 y 值）

    % 创建一个新的图形
    figure;

    % 设置不同的线型和标记
    lineStyles = {'-', '--', ':', '-.'};  % 线型列表
    markers = {'o', 's', '^', 'd'};  % 标记列表
    colors = ['r', 'g', 'b', 'k'];  % 颜色列表（红色、绿色、蓝色、黑色）

    % 循环绘制每个函数的折线图
    n_functions = size(y, 1);  % 函数的数量
    hold on;  % 保持当前图形


    for i = 2:n_functions
        % 选择不同的颜色、线型、标记
        plot(x, y(i, :), 'Color', colors(mod(i-1, length(colors)) + 1), ...
            'LineStyle', lineStyles{mod(i-1, length(lineStyles)) + 1}, ...
            'Marker', markers{mod(i-1, length(markers)) + 1});
    end


    % 添加图例、标题、标签
    legend(arrayfun(@(i) ['1e-' num2str(i)], 2:n_functions, 'UniformOutput', false));
    title(['TP-',num2str(k)]);
    xlabel('Number of evaluations');
    ylabel('IGDRM');

    ylim([0 0.6]); %TP6

    % 设置纵坐标范围
    if k == 6
        ylim([0 5]); %TP6
    elseif k == 7
        ylim([0 8]); %TP7
    elseif k == 8
        ylim([0 1.5]); %TP8
    elseif k == 9
        ylim([0 1]); %TP9
    end


    % 设置横坐标范围
    xlim([0 900]);

    % 关闭 hold
    hold off;
end



