classdef NSGAIIDTI6 < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained/none> <robust>
% eta --- 0.1 --- Parameter

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
            eta = Algorithm.ParameterSet(0.1);
            % 现在 ResultPop 变量包含了加载的数据，可以直接使用它
            loadPath = ['Data/Result/' class(Problem) '.mat'];
            load(loadPath, 'ResultPop');
            ArchGEN = Problem.maxFE / Problem.N;
            delta = Problem.delta;
            for j = 1 : 3
                WS = [10,50,90];
                Result=[]; %初始化一个名为 Result 的空数组。
                ResultName = ['Data/Result/' class(Problem) '-W' num2str(WS(j)) '-delta-' num2str(delta) '.mat'];
                i = 3;
                while i <= ArchGEN
                    Population = Problem.Evaluation(ResultPop{i,j});
                    flag = RobustEta(Problem,Population);
                    Result = [Result;flag];
                    i = i + 1;
                    if mod(i,20) == 0
                        disp(num2str(i));
                    end
                end
                save(ResultName,'Result');
                MyFigure1(ResultName,WS(j),delta,Problem);
            end
            Problem.FE = Problem.maxFE;
            
        end
    end
end

function MyFigure1(filePath,w,delta,Problem)
    figure;
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
    title([class(Problem) '-W' num2str(w) '-delta-' num2str(delta)]);
    xlabel('进化代数');
    ylabel('归一化目标变化值');
    grid on; % 显示网格线
    % 设置纵坐标范围为0到1
    xlim([-1 length(dataVector)]);
    ylim([0 1]);
end
