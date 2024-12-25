classdef NSGAIIDTI7 < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained/none> <robust>
% eta --- 0.1 --- Parameter
% type --- 1 --- The type of select


%------------------------------- Reference --------------------------------
% K. Deb, A. Pratap, S. Agarwal, and T. Meyarivan, A fast and elitist
% multiobjective genetic algorithm: NSGA-II, IEEE Transactions on
% Evolutionary Computation, 2002, 6(2): 182-197.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        function main(Algorithm,Problem)
            [eta,type] = Algorithm.ParameterSet(0.1,1);
            % 现在 ResultPop 变量包含了加载的数据，可以直接使用它
            loadPath = ['Data/Result/' class(Problem) '.mat'];
            load(loadPath, 'ResultPop');
            ArchGEN = Problem.maxFE / Problem.N;
            deltaOri = Problem.delta;
            delta1 = [1,2,4,6,8,10];    
            delta2 = [1,2,4,6,8,10,12,14,16,18,20];
            deltas = delta1; 
            switch type
                case 1    
                    deltas = delta1;                 % delta参数系数数组
                case 2    
                    deltas = delta2;                 % delta参数系数数组
            end     
            filePaths = cell(length(deltas), 1); % 初始化cell数组，用于存储文件路径

            for j = 1 : 3
                WS = [10,50,90];
                for k = 1 : length(deltas)
                    Result=[]; %初始化一个名为 Result 的空数组。
                    Problem.delta = deltaOri*deltas(k);
                    ResultName = ['Data/Result/' class(Problem) '-W' num2str(WS(j)) '-delta-' num2str(Problem.delta) '.mat'];
                    i = 3;
                    while i <= ArchGEN
                        Population = Problem.Evaluation(ResultPop{i,j});
                        flag = RobustEta(Problem,Population);
                        Result = [Result;flag];
                        i = i + 1;
                        if mod(i,100) == 0
                            disp(num2str(i));
                        end
                    end
                    save(ResultName,'Result');
                    filePaths{k} = ResultName;
                end
                MyFigureMultiple(filePaths,WS(j),deltaOri, deltas ,Problem);
            end

            Problem.FE = Problem.maxFE;
            
        end
    end
end

function MyFigureMultiple(filePaths, w, deltaOri, deltas, Problem)

    figure; % 创建一个图形窗口
    hold on; % 保持图像，以便在同一图形上绘制多个线条
    colors = lines(length(filePaths)); % 获取一组颜色以区分不同的线条
    % 假设已经定义了filePaths和colors变量
    legendEntries = cell(length(filePaths), 1); % 创建一个cell数组来保存图例条目
    lineHandles = gobjects(length(filePaths), 1); % 创建一个图形对象数组来保存线条对象
    for i = 1:length(filePaths)
        filePath = filePaths{i};
        loadedData = load(filePath);
        dataVector = loadedData.Result;
        if ~isvector(dataVector) || size(dataVector,2) ~= 1
            error('dataVector is not a column vector.');
        end
        x = (1:length(dataVector))';
        h = plot(x, dataVector, 'LineWidth', 1.3, 'Color', colors(i,:), 'DisplayName', ['Delta ' num2str(deltaOri*deltas(i))]);
        legendEntries{i} = ['Delta ' num2str(deltaOri*deltas(i))]; % 保存图例描述
        lineHandles(i) = h; % 保存对应的线条对象
    end
    % 图例逆序
    legend(flipud(lineHandles), flipud(legendEntries), 'Location', 'best');
    %%

    title([class(Problem) ' - W' num2str(w)]);
    xlabel('Number of evaluations');
    % ylabel('归一化目标变化值');
    xlim([1 Problem.maxFE/Problem.N]);
    ylim([0 1]);

    legend show; % 显示图例
    hold off; % 结束叠加绘图
end

