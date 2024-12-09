function MyFigure(filePath)
% 指定.mat文件的完整路径
filePath = 'Data/Result/Result-1.mat';

% 加载.mat文件中的数据
data = load(filePath);

% 提取数据
myData = data.Result;

% 如果数据的列数为2，则可以继续
if size(myData, 2) == 2
    x = myData(:, 1);  % 第一列为X数据
    y = myData(:, 2);  % 第二列为Y数据

    % 创建图形
    figure;
    plot(x, y, 'o');  % 使用圆圈标记点
    title('Data Plot');
    xlabel('X Axis');
    ylabel('Y Axis');

    % 设置轴的范围以包括所有点
    axis([min(x) max(x) min(y) max(y)]);  

    % 设置坐标轴的范围
    % xlim([0 1]);  % 设置X轴范围为0到5
    % ylim([0 5]);  % 设置Y轴范围为0到5

else
    error('Data does not have two columns');
end

