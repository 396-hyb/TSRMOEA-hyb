classdef NSGAIIDTI3 < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained/none> <robust>
% Nondominated sorting genetic algorithm II

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
            % %% Generate random population
            % Population = Problem.Initialization();
            % [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,Problem.N);

            Result=[]; %初始化一个名为 Result 的空数组。
            ResultName = strcat('Data/Result/Result-1.mat');
            
            %% Generate random population
            if Problem.encoding(1)==4
                Dec = ones(Problem.N,Problem.D);
            else
                Dec = unifrnd(repmat(Problem.lower,Problem.N,1),repmat(Problem.upper,Problem.N,1));
            end
            Population = Problem.Evaluation(Dec);

            w = UniformPoint(Problem.N,Problem.M);
            W = w;
            T = ceil(Problem.N/10);

            %% Detect the neighbours of each solution
            B = pdist2(W,W);
            [~,B] = sort(B,2);
            B = B(:,1:T);
            
            Z = min(Population.objs,[],1);
 

            %% Optimization
            while Algorithm.NotTerminated(Population)

           
                for i = 1 : Problem.N
                    % Choose the parents
                    P = B(i,randperm(size(B,2)));

                    % Generate an offspring
                    Offspring = OperatorGAhalf(Problem,Population(P(1:2)));

                    % Update the ideal point
                    Z = min(Z,Offspring.obj);
                    
                    % Tchebycheff approach with normalization
                    Zmax  = max(Population.objs,[],1);
                    % Population.objs列向量是个体，行向量是目标值
                    g_old = max(abs(Population(P).objs-repmat(Z,T,1))./repmat(Zmax-Z,T,1).*W(P,:),[],2);
                    % max(A, [], 2) 是一个函数调用，用来找出矩阵 A 中每一行的最大元素，返回一个列向量
                    g_new = max(repmat(abs(Offspring.obj-Z)./(Zmax-Z),T,1).*W(P,:),[],2);

                    Population(P(g_old>=g_new)) = Offspring;
                end
                flag = Classification(Problem,Population);
                
                Result = [Result;flag];
                
                if Problem.FE >= Problem.maxFE
                    save(ResultName,'Result');
                    MyFigure(ResultName);
                end
            end
            % load(ResultName);                             %载入之前存储的鲁棒解
        end
    end
end