classdef TSRMOEAN31 < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained/none> 
% Two stage robust multi-objective evolutionary algorithm
% eta --- 0.5 --- Parameter

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

% Two stage robust multi-objective evolutionary algorithm
    methods
        function main(Algorithm,Problem)

            %% Parameter setting
            eta = Algorithm.ParameterSet(1.5);

            %% Generate random population
            Dec = unifrnd(repmat(Problem.lower,Problem.N,1),repmat(Problem.upper,Problem.N,1));
            Population = Problem.Evaluation(Dec);

            W = UniformPoint(Problem.N,Problem.M);
            T = ceil(Problem.N/10);

            %% Detect the neighbours of each solution
            B = pdist2(W,W);
            [~,B] = sort(B,2);
            B = B(:,1:T);
            
            Z    = min(Population.objs,[],1);
            gen  = 1;
            Arch = cell(Problem.maxFE/Problem.N,1);
            Arch{gen,1} = archive(Population.decs, Population.objs, gen);

            %% Optimization
            while Algorithm.NotTerminated(Population)

           
                for i = 1 : Problem.N   
                    % Choose the parents
                    P = B(i,randperm(size(B,2)));

                    % Generate an offspring

                    OffDec = OperatorGAhalf(Problem,Population(P(1:2)).decs);
                    Offspring = Problem.Evaluation(OffDec);

                    % Update the ideal point
                    Z = min(Z,Offspring.obj);
                    
                    % Tchebycheff approach with normalization
                    % Zmax  = max(Population.objs,[],1);
                    % g_old = max(abs(Population(P).objs-repmat(Z,T,1))./repmat(Zmax-Z,T,1).*W(P,:),[],2);
                    % g_new = max(repmat(abs(Offspring.obj-Z)./(Zmax-Z),T,1).*W(P,:),[],2);

                    % PBI approach
                    normW   = sqrt(sum(W(P,:).^2,2));
                    normP   = sqrt(sum((Population(P).objs-repmat(Z,T,1)).^2,2));
                    normO   = sqrt(sum((Offspring.obj-Z).^2,2));
                    CosineP = sum((Population(P).objs-repmat(Z,T,1)).*W(P,:),2)./normW./normP;
                    CosineO = sum(repmat(Offspring.obj-Z,T,1).*W(P,:),2)./normW./normO;
                    g_old   = normP.*CosineP + 5*normP.*sqrt(1-CosineP.^2);
                    g_new   = normO.*CosineO + 5*normO.*sqrt(1-CosineO.^2);

                    Population(P(g_old>=g_new)) = Offspring;
                end
                gen  = gen + 1;

                %档案更新
                Arch{gen,1} = archive(Population.decs, Population.objs, gen);
                % TemArch = archive(Population.decs, Population.objs, gen);
                % Arch    = [Arch;TemArch];
                
                if Problem.FE >= Problem.maxFE
                    % [resArch,ArT] = Final(Problem,Arch,Problem.N,W,gen,Z);
                    Population = Final(Problem,Arch,Problem.N,W,gen,Z,eta);
                    
                end
  
            end
        end
    end
end