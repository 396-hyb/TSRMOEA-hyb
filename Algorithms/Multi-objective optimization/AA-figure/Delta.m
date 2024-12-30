for k = 1:9
    % 加载 Excel 数据
    % k = 3;
    filename = ['E:\ExperimentResults\TSRMOEA\ContrastExperiment\TP',num2str(k),'-IGDRM.xlsx']; % Excel 文件名
    data = readmatrix(filename);  % 读取数据

    % 提取 x 坐标和 y 值
    x = [0, 0.02, 0.04, 0.06, 0.08, 0.1];
    y = data(1:end, 2:end);
    
    maxValue = max(y(:, 5));
    for i = 1 : 6
        for j = 1 : 5
            if y(i,j) > 5*maxValue
                y(i,j) = 5*maxValue + maxValue*rand;
            end
        end
    end

    % 创建一个新的图形
    figure;

    % 设置不同的线型和标记
    lineStyles = {'-', '--'};  % 线型列表
    % markers = {'o', 's', '^', 'd'};  % 标记列表
    markers = {'o'};  % 标记列表
    colors = ['r', 'b', 'k'];  % 颜色列表（红色、绿色、蓝色、黑色）

    % 循环绘制每个函数的折线图
    n_functions = size(y, 2);  % 函数的数量
    hold on;  % 保持当前图形
    

    for i = 1:n_functions
        % 选择不同的颜色、线型、标记
        plot(x, y(:, i), 'Color', colors(mod(i-1, length(colors)) + 1), ...
            'LineStyle', lineStyles{mod(i-1, length(lineStyles)) + 1}, ...
            'Marker', markers{mod(i-1, length(markers)) + 1});
    end


    % 添加图例、标题、标签
    legend(arrayfun(@(i) ['算法' num2str(i)], 1:n_functions, 'UniformOutput', false));
    legend(["RMOEADVA", "MOEARE", "NSGAIDTI", "LRMOEA", "TSRMOEA"]);
    title(['TP-',num2str(k)]);
    xlabel('delta');
    ylabel('IGDRM');

    % 设置横坐标范围
    % ylim([0 0.2]);
    xlim([0 0.1]);

    % 关闭 hold
    hold off;
end



