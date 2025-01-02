% 读取Excel文件
% filename = 'E:\ExperimentResults\TSRMOEA\ContrastExperiment\TP-runtime.xlsx'; % Excel文件名
filename = 'E:\ExperimentResults\TSRMOEA\ContrastExperiment\ZDT-runtime.xlsx'; % Excel文件名

dataTable = readtable(filename, 'ReadRowNames', true); % 假设第一列是行名

% 将table数据转换为数组，用于绘图
dataMatrix = table2array(dataTable);

% 绘制柱状图
figure; % 创建一个新图形窗口
bar(dataMatrix, 'grouped'); % 绘制分组柱状图
% title('不同算法在不同问题上的运行时间比较'); % 图形标题
ylabel('Runtime(s)'); % y轴标签
legend(dataTable.Properties.VariableNames, 'Location', 'best'); % 添加图例
xticks(1:size(dataMatrix, 1)); % 设置x轴刻度
xticklabels(dataTable.Properties.RowNames); % 设置x轴刻度标签

% 显示图形
%grid on; % 添加网格
