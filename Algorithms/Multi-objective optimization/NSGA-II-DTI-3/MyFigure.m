function MyFigure(filePath)
% 指定.mat文件的完整路径
% filePath = 'Data/Result/Result-1.mat';

% 加载.mat文件中的数据
loadedData = load(filePath);

% 提取列向量数据（假设列向量的名字是dataVector）
dataVector = loadedData.Result;

% 检查dataVector是否为列向量
if ~isvector(dataVector) || size(dataVector,2) ~= 1
    error('dataVector is not a column vector.');
end

% 创建行向量作为x轴的数据点索引
x = (1:length(dataVector))';

% 绘制折线图
plot(x, dataVector);
title('每一代的非支配解中的鲁棒解比例');
xlabel('进化代数');
ylabel('鲁棒解的比例');
grid on; % 显示网格线

% 设置纵坐标范围为0到1
ylim([0 1]);

% 如果需要，可以显示图例（如果有的话）
% legend('Data Vector');

% 显示图形
figure;