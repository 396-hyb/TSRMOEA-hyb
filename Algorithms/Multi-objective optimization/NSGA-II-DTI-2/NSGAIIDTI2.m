classdef NSGAIIDTI2 < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained/none>
% NSGA-II of Deb's type I robust version

%------------------------------- Reference --------------------------------
% K. Deb and H. Gupta, Introducing robustness in multi-objective
% optimization, Evolutionary Computation, 2006, 14(4): 463-494.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    % 阈值判断问题类型

	methods
        function main(Algorithm,Problem)
            %% Generate random population
            Population2 = Problem.Initialization();
            PopObjV2    = MeanEffective(Problem,Population2);
            [~,FrontNo2,CrowdDis2] = EnvironmentalSelection(Population2,Problem.N,PopObjV2);

            
            %% Optimization
            first_FES = 20000;
            beita     = 0.9;

            while Algorithm.NotTerminated(Population2)
                % disp(['Problem.FE:', num2str(Problem.FE)]); 
                MatingPool2 = TournamentSelection(2,Problem.N,FrontNo2,-CrowdDis2);
                Offspring2  = OperatorGA(Problem,Population2(MatingPool2),{1,10,1,50});
                OffObjV2    = MeanEffective(Problem,Offspring2);
                [Population2,FrontNo2,CrowdDis2,PopObjV2] = EnvironmentalSelection([Population2,Offspring2],Problem.N,[PopObjV2;OffObjV2]);

                if Problem.FE >= first_FES    
                    
                    Population1 = newPop_TP8();

                    flag   = Classification(Problem,Population1,Population2,PopObjV2,beita);  
                    disp(['flag:', num2str(flag)]);  
                end
            end
        end
    end
end