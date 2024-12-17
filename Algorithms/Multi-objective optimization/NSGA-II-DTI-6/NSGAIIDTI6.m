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

            Result=[]; %初始化一个名为 Result 的空数组。
            ResultName = strcat('Data/Result/ZDT5-raodong.mat');
            eta = Algorithm.ParameterSet(0.1);

            % 现在 ResultPop 变量包含了加载的数据，可以直接使用它
            load('Data/Result/ZDT5.mat', 'ResultPop');

            ArchGEN = Problem.maxFE / Problem.N;

            i = 1;
            while i <= ArchGEN
                Population = [];
                for j = 1 : Problem.N
                    Population = [Population, Problem.Evaluation(ResultPop{i,j})];
                end
                flag = Classification(Problem,Population,eta);
                Result = [Result;flag];
                
                i = i + 1;
                if mod(i,10) == 1
                    disp(num2str(i));
                end
            end

            Problem.FE = Problem.maxFE;
            if Problem.FE >= Problem.maxFE
                disp(num2str(flag));
                save(ResultName,'Result');
                MyFigure(ResultName);


            end 
        end
    end
end