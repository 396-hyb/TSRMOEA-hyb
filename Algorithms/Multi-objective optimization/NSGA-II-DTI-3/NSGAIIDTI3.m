classdef NSGAIIDTI3 < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained/none> <robust>
% eta --- 0.5 --- Parameter
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

            Result=[]; %初始化一个名为 Result 的空数组。
            ResultName = strcat('Data/Result/Result-1.mat');
            eta = Algorithm.ParameterSet(0.5);

            %% Generate random population
            Population = Problem.Initialization();
           
            [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,Problem.N);
            
            %% Optimization
            first_FES = 10000;    

            %% Optimization
            while Algorithm.NotTerminated(Population)
                MatingPool = TournamentSelection(2,Problem.N,FrontNo,-CrowdDis);
                Offspring  = OperatorGA(Problem,Population(MatingPool),{1,0,0.5,20});
                [Population,FrontNo,CrowdDis] = EnvironmentalSelection([Population,Offspring],Problem.N);

                flag = Classification(Problem,Population,eta);
                Result = [Result;flag];
                
                if Problem.FE >= Problem.maxFE
                    save(ResultName,'Result');
                    MyFigure(ResultName);
                end
            end

        end
    end
end