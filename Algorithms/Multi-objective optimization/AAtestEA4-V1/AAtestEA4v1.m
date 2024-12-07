classdef AAtestEA4v1 < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained/none> <robust>
% eta --- 0.5 --- Parameter
% ArchGEN --- 30 --- Parameter
% gap    ---    30 --- Parameter calculating the change rate of ideal points
% lambda --- 1e-3 --- Parameter determining the evolving stages 

%------------------------------- Reference --------------------------------
% Q. Zhang and H. Li, MOEA/D: A multiobjective evolutionary algorithm based
% on decomposition, IEEE Transactions on Evolutionary Computation, 2007,
% 11(6): 712-731.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% 根据某个指标quota：当小于值q1是，开始存档；当小于值q2一定代数后，开始切换到第二阶段；(未采用)
% 存档大小固定，对应权重向量存满后按 某个指标 替换存档中的一个解，一阶段存满的档案要用PBI值排序后才进入鲁棒解搜寻
% 每个权重向量对应领域有个指标quota：当都小于值q1后，开始切换到第二阶段；存档满了用距离比率切换
% 在第一阶段，每代解都要判断是否存档

% 消融实验：验证一阶段有效性,直接跑第二阶段（100代）
    methods
        function main(Algorithm,Problem)
            
            %% Parameter setting
            [eta, ArchGEN, gap, lambda] = Algorithm.ParameterSet(0.5, 30, 30, 1e-3);
    
            Iter        = 1;
            IdealPoints = {gap, Problem.N};
            flag = zeros(1,Problem.N);   % 0 for the first stage, 1 for the second stage

            %% Generate the weight vectors
            [W,Problem.N] = UniformPoint(Problem.N,Problem.M);
            T = ceil(Problem.N/10);

            %% Detect the neighbours of each solution
            B = pdist2(W,W);  % B(i, j) 表示第 i 个和第 j 个权重向量之间的距离。
            [~,B] = sort(B,2);
            B = B(:,1:T);   % 每个权重向量就只保留与其最近的 T 个邻居的索引
  
            %% Generate random population
            Population = Problem.Initialization();
            Z = min(Population.objs,[],1);

            %% Optimization
            while Algorithm.NotTerminated(Population)
                % [PopObjV] = MeanEffective(Problem,Population);
                for i = 1 : Problem.N
                    P = B(i,randperm(size(B,2)));
                    Offspring = OperatorGAhalf(Problem, Population(P(1:2)), {1,20,0.5,10});
                    Z = min(Z,Offspring.obj);
                    normW   = sqrt(sum(W(P,:).^2,2));
                    normP   = sqrt(sum((Population(P).objs-repmat(Z,T,1)).^2,2));
                    normO   = sqrt(sum((Offspring.obj-Z).^2,2));
                    CosineP = sum((Population(P).objs-repmat(Z,T,1)).*W(P,:),2)./normW./normP;
                    CosineO = sum(repmat(Offspring.obj-Z,T,1).*W(P,:),2)./normW./normO;
                    g_old   = normP.*CosineP + 5*normP.*sqrt(1-CosineP.^2);
                    g_new   = normO.*CosineO + 5*normO.*sqrt(1-CosineO.^2);

                    RE = RobustEta(Problem,Offspring);
                    if RE <= eta
                        Population(P(g_old>=g_new)) = Offspring;
                    end
                    % Population(P(g_old>=g_new)) = Offspring;
                end
                    
 

            end
        end
    end
end
