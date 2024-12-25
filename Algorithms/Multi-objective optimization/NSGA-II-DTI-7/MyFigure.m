% 定义.fig文件的路径
% figFile1 = 'E:/ExperimentResults/TSRMOEA/fig/ZDT2/fig1.fig';
% figFile1 = 'E:/ExperimentResults/TSRMOEA/fig/ZDT4/fig1.fig';
% figFile1 = 'E:/ExperimentResults/TSRMOEA/fig/TP6/fig1.fig';

figFile1 = 'E:/ExperimentResults/TSRMOEA/fig/ZDT2/fig1.fig';
figFile2 = 'E:/ExperimentResults/TSRMOEA/fig/ZDT2/fig2.fig';
figFile3 = 'E:/ExperimentResults/TSRMOEA/fig/ZDT2/fig3.fig';

figFile4 = 'E:/ExperimentResults/TSRMOEA/fig/ZDT4/fig1.fig';
figFile5 = 'E:/ExperimentResults/TSRMOEA/fig/ZDT4/fig2.fig';
figFile6 = 'E:/ExperimentResults/TSRMOEA/fig/ZDT4/fig3.fig';

figFile7 = 'E:/ExperimentResults/TSRMOEA/fig/TP6/fig1.fig';
figFile8 = 'E:/ExperimentResults/TSRMOEA/fig/TP6/fig2.fig';
figFile9 = 'E:/ExperimentResults/TSRMOEA/fig/TP6/fig3.fig';

% 加载.fig文件
fig1 = openfig(figFile1, 'invisible'); % 加载但不显示
fig2 = openfig(figFile2, 'invisible');
fig3 = openfig(figFile3, 'invisible');

fig4 = openfig(figFile4, 'invisible'); 
fig5 = openfig(figFile5, 'invisible');
fig6 = openfig(figFile6, 'invisible');

fig7 = openfig(figFile7, 'invisible'); 
fig8 = openfig(figFile8, 'invisible');
fig9 = openfig(figFile9, 'invisible');

% 创建一个新的图形窗口，并设置为3个子图
figure;
% t = tiledlayout(3, 1); % 垂直堆叠三个图
% t = tiledlayout(1, 3); % 水平堆叠三个图
% t = tiledlayout(3, 3); 
% 设置子图布局，增加纵向间距
t = tiledlayout(3, 3, 'TileSpacing', 'loose', 'Padding', 'loose');
% 可以调整'TileSpacing'的值来控制子图之间的间距：'compact', 'normal', or 'loose' 

% 存储所有图形对象的数组，以便循环访问
figs = [fig1, fig2, fig3, fig4, fig5, fig6, fig7, fig8, fig9];
% 子图标签数组
labels = {'(a)', '(b)', '(c)', '(d)', '(e)', '(f)', '(g)', '(h)', '(i)'};

for i = 1 : 9
    ax1 = nexttile(t);
    axesObjs = findobj(figs(i), 'Type', 'axes'); % 找到所有轴对象
    copyobj(get(axesObjs, 'children'), ax1);  % 复制所有对象到新轴
    title(ax1, get(get(axesObjs, 'Title'), 'String')); % 复制标题
    xlabel(ax1, get(get(axesObjs, 'XLabel'), 'String')); % 复制X轴标签
    ylabel(ax1, get(get(axesObjs, 'YLabel'), 'String')); % 复制Y轴标签
    % 设置Y轴范围为[0, 1]
    ylim(ax1, [0 1]);
    % pbaspect(ax1, [1 1 1]);  % 设置纵横比为原始比例，比如 1:1:1
    % 在X轴标签正下方添加标号
    text(ax1, 0.5, -0.2, labels{i}, 'Units', 'normalized', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold');
end

% 关闭原始.fig文件，以节省资源
arrayfun(@close, figs);
