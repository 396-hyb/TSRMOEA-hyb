classdef AAtestEA1 < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained/none> <robust>
% ArchGEN --- 30 --- Parameter

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

% 存档大小固定，对应权重向量存满后在索引循环替换解

    methods
        function main(Algorithm,Problem)
            %% Parameter setting
            type = Algorithm.ParameterSet(1);

            %% Generate the weight vectors
            [W,Problem.N] = UniformPoint(Problem.N,Problem.M);
            T = ceil(Problem.N/10);

            %% Detect the neighbours of each solution
            B = pdist2(W,W);
            [~,B] = sort(B,2);
            B = B(:,1:T);

            %% Generate random population
            Population = Problem.Initialization();
            Z = min(Population.objs,[],1);

            % 存档中每个权重向量关联个体最大存档个数
            ArchGEN = 30;

            Arch = cell(ArchGEN, Problem.N);
            for i = 1 : Problem.N
                Arch{1, i} = Population(i);
            end
            
            tolerance = 1e-6; % 定义一个很小的容差

            IndexArr = zeros(1,Problem.N);  %注意档案是从1开始，但索引不是从1开始，索引从 0 到 ArchGEN-1

            %% Optimization
            while Algorithm.NotTerminated(Population)
                % For each solution
                for i = 1 : Problem.N
                    % Choose the parents
                    P = B(i,randperm(size(B,2)));

                    % Generate an offspring
                    Offspring = OperatorGAhalf(Problem,Population(P(1:2)));

                    % Update the ideal point
                    Z = min(Z,Offspring.obj);

                    % Update the neighbours
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

                %分配解
                N = Problem.N;
                for i = 1 : N
                    popNew = Population(i);
                    obj = popNew.obj;
                    %找到与这个解角度最近的权重向量
                    t = [];
                    for y = 1 : N
                        s = sum(W(y,:).*obj,2);
                        m = sqrt(sum(W(y,:).*W(y,:),2)*sum(obj.*obj,2));
                        t(1,y) = acos(s/m);
                    end
                    [~,h]     = min(t(1,:));
                    
                    arPopNum = IndexArr(h); % 权重向量上如果一直存解的解的索引
                    indexOld = mod(arPopNum, ArchGEN);  % 解在存档中的实际索引
                    indexNew = mod(arPopNum+1, ArchGEN);

                    popOld = Arch{indexOld+1, h};  % 同一权重向量的上一个存档解
                    if all( abs(popNew.obj - popOld.obj) <= tolerance ) 
                        continue;
                    else
                        % 两个解不同
                        if arPopNum < ArchGEN
                            Arch{indexNew+1, h} = popNew;
                            IndexArr(h) = arPopNum + 1;
                        else
                            popExist = Arch{indexNew+1, h};
                            

                        end
                    end
                    
                end

                if Problem.FE >= Problem.maxFE
                    disp(IndexArr);
                end

                % disp(num2str(Arch{gen,i}.obj)); //可以输出一个个体的目标值


            end
        end
    end
end