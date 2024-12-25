classdef NSGAIIDTI5 < ALGORITHM
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

            % Result=[]; %初始化一个名为 Result 的空数组。
            % ResultName = strcat('Data/Result/Result-1.mat');

            eta = Algorithm.ParameterSet(0.1);
            
            %% Generate the weight vectors
            [W,Problem.N] = UniformPoint(Problem.N,Problem.M);
            T = ceil(Problem.N/10);

            %% Detect the neighbours of each solution
            B = pdist2(W,W);
            [~,B] = sort(B,2);
            B = B(:,1:T);

            %% Generate random population
            % Dec = unifrnd(repmat(Problem.lower,Problem.N,1),repmat(Problem.upper,Problem.N,1));
            % Population = Problem.Evaluation(Dec);
            Population = Problem.Initialization();

            Z = min(Population.objs,[],1);

            ArchGEN = Problem.maxFE / Problem.N;
            ResultPop = cell(ArchGEN, Problem.N);  %决策变量存档, 初始化一个名为 ResultPop 的空数组。
            ResultNamePop = strcat('Data/Result/', class(Problem), '.mat');

            gen = 1;
            for i = 1 : Problem.N
                ResultPop{gen, i} = Population(i).dec;
            end
            gen = gen + 1;
            disp(class(Problem));
            
            %% Optimization
            while Algorithm.NotTerminated(Population)
                for i = 1 : Problem.N
                    P = B(i,randperm(size(B,2)));
                    
                    Offspring = OperatorGAhalf(Problem,Population(P(1:2)),{1,10,1,10});
                 
                    Z = min(Z,Offspring.obj);
                    normW   = sqrt(sum(W(P,:).^2,2));
                    normP   = sqrt(sum((Population(P).objs-repmat(Z,T,1)).^2,2));
                    normO   = sqrt(sum((Offspring.obj-Z).^2,2));
                    CosineP = sum((Population(P).objs-repmat(Z,T,1)).*W(P,:),2)./normW./normP;
                    CosineO = sum(repmat(Offspring.obj-Z,T,1).*W(P,:),2)./normW./normO;
                    g_old   = normP.*CosineP + 5*normP.*sqrt(1-CosineP.^2);
                    g_new   = normO.*CosineO + 5*normO.*sqrt(1-CosineO.^2);
                    Population(P(g_old>=g_new)) = Offspring;
                end

                for i = 1 : Problem.N
                    ResultPop{gen, i} = Population(i).dec;
                end
                gen = gen + 1;
                
                % flag = Classification(Problem,Population,eta);

                % Result = [Result;flag];
            
                
                if Problem.FE >= Problem.maxFE
                    % disp(num2str(flag));
                    % save(ResultName,'Result');
                    % MyFigure(ResultName);
                    % disp(Problem.name);
                    save(ResultNamePop,'ResultPop');
                    disp("saved");

                end
            end

        end
    end
end