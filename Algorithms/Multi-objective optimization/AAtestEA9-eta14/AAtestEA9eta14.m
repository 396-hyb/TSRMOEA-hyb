classdef AAtestEA9eta14 < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained/none> <robust>
% eta --- 1.4 --- Parameter
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

% 第一类策略：仍然向前进化，最后判断下鲁棒性
% 第二类策略：每个向量单独生成子代，然后更新的时候一起更新
    methods
        function main(Algorithm,Problem)
            
            %% Parameter setting
            [eta, ArchGEN, gap, lambda] = Algorithm.ParameterSet(1.3, 30, 30, 1e-3);
    
            Iter        = 1;
            IdealPoints = {gap, Problem.N};
            flag = zeros(1,Problem.N);   % 0 for the first stage, 1 for the second stage

            % Result=[]; %初始化一个名为 Result 的空数组。
            % ResultName = strcat('Data/Result/Result-1.mat');

            %% Generate the weight vectors
            [W,Problem.N] = UniformPoint(Problem.N,Problem.M);
            T = ceil(Problem.N/10);

            %% Detect the neighbours of each solution
            B = pdist2(W,W);  % B(i, j) 表示第 i 个和第 j 个权重向量之间的距离。
            [~,B] = sort(B,2);
            B = B(:,1:T);   % 每个权重向量就只保留与其最近的 T 个邻居的索引
  
            %% Generate random population
            Population = Problem.Initialization();
            for i = 1 : Problem.N
                IdealPoints{Iter, i} = min(Population(B(i,:)).objs, [], 1);
            end
            Z = min(Population.objs,[],1);

            DecsArch = cell(ArchGEN, Problem.N);  %决策变量存档
            ObjsArch = cell(ArchGEN, Problem.N);  %目标值存档
            for i = 1 : Problem.N
                DecsArch{1, i} = Population(i).dec;
                ObjsArch{1, i} = Population(i).obj;
            end
            
            tolerance = 1e-5; % 定义一个很小的容差

            IndexArr = zeros(1,Problem.N);  %注意档案是从1开始，但索引不是从1开始，索引从 0 到 ArchGEN-1
            
            Matrix = cell(Problem.N);

            %% Optimization
            while Algorithm.NotTerminated(Population)
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
                    Population(P(g_old>=g_new)) = Offspring;
                end
                % 计算邻域的理想点变化指标
                Iter = Iter + 1;
                for i = 1 : Problem.N
                    IdealPoints{mod(Iter,gap+1)+1, i} = min(Population(B(i,:)).objs, [], 1);
                    if Iter > gap  %&& flag(i) == 0
                        max_change = calc_maxchange(cell2mat(IdealPoints(:,i)), Iter, gap);
                        if max_change <= lambda
                            flag(i) = 1;
                        else
                            flag(i) = 0;
                        end
                    end
                end

                %分配解
                N = Problem.N;
                if length(find(flag == 0)) > 0
                    for i = 1 : N
                        popNew = Population(i);
                        obj = popNew.obj;
                        % 找到与这个解角度最近的权重向量
                        % t = [];
                        % for y = 1 : N
                        %     s = sum(W(y,:).*obj,2);
                        %     m = sqrt(sum(W(y,:).*W(y,:),2)*sum(obj.*obj,2));
                        %     t(1,y) = acos(s/m);
                        % end
                        % [~,h]     = min(t(1,:));
                        h = i;
                        arPopNum  = IndexArr(h); % 权重向量上最后关联解的索引
                        ArchVObjs = cell2mat(ObjsArch(:,h));  %h权重向量上的所有存档解的目标值
                        % isEqual = Unique(obj,ArchVObjs,arPopNum,ArchGEN); %是否有重复解
                        m = arPopNum + 1;
                        if m > ArchGEN
                            m = ArchGEN;
                        end
                        isEqual = 0;
                        for i2 = 1 : m   
                            if all(abs(obj - ArchVObjs(i2) )) < tolerance 
                                isEqual = 1;
                                break;
                            end
                        end
                        if isEqual == 1 || flag(h) == 1
                            continue;
                        else    % 与权重向量存入存档的解不同
                            if arPopNum < ArchGEN     % 存档未满
                                ObjsArch{mod(arPopNum+1, ArchGEN)+1, h} = obj;
                                DecsArch{mod(arPopNum+1, ArchGEN)+1, h} = popNew.dec;
                                IndexArr(h) = arPopNum + 1;
                            else
                                ArchVObjs = [ArchVObjs; obj];
                                if  arPopNum == ArchGEN
                                    Matrix{h} = DisCreat(ArchVObjs, arPopNum+1);
                                end
                                [index, MatrixNew] = costDis(ArchVObjs, ArchGEN+1, cell2mat(Matrix(h)));
                                % index = costDis(ArchVObjs, ArchGEN+1);
                                if index <= ArchGEN   %前面存的解有最小距离比率
                                    ObjsArch{index, h} = obj;
                                    DecsArch{index, h} = popNew.dec;
                                    Matrix{h} = MatrixNew;
                                    IndexArr(h) = arPopNum + 1;
                                end
                            end
                        end
                    end
                end 
                if length(find(flag == 0)) == 0 || Problem.FE >= Problem.maxFE * 0.9  %所有小区域的指标都小于lambda，则开始切换。
                    disp(["**Problem.FE:",num2str(Problem.FE)]);
               
                    Population = Final(Problem,IndexArr,ObjsArch,DecsArch,ArchGEN,W,Z,eta,Population);
                        
                        % for i = 1 : Problem.N
                        %     ArchVObjs = cell2mat(ObjsArch(:,i)); 
                        %     Result = [Result; ArchVObjs];
                        % end
                        % save(ResultName,'Result');
                        % MyFigure(ResultName);
                        % disp(size(Result));
                        disp(IndexArr);
                    Problem.FE = Problem.maxFE;
             
                    disp(["**Problem.FE:",num2str(Problem.FE)]);
                    
                end
                % disp(["**Problem.FE:",num2str(Problem.FE)]);
                % disp(num2str(Arch{gen,i}.obj)); //可以输出一个个体的目标值

            end
        end
    end
end

function max_change = calc_maxchange(ideal_points,Iter,gap)
    % Calculate the maximum change rate of ideal points
    delta = 1e-6 * ones(1,size(ideal_points,2));
    rz    = abs((ideal_points(mod(Iter,gap+1)+1,:) - ideal_points(mod(Iter - gap,gap+1)+1,:)) ./ max(ideal_points(mod(Iter - gap,gap+1)+1,:),delta));  
    % rz    = abs((ideal_points(Iter,:) - ideal_points(Iter - gap,:)) ./ max(ideal_points(Iter - gap,:),delta));  
    max_change = max(rz);
end