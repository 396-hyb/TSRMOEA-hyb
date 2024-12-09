function Population = Final(Problem,IndexArr,ObjsArch,DecsArch,ArchGEN,W,Z,eta,Population)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    
    allUnique  = [];  %所有不重复解
    % rAndUnique = [];  %鲁棒解且不重复解
    % rAndRemain = [];  %鲁棒解且未被选上的解
    % rAndRelate = [];  %鲁棒且与向量关联的解
 
    rRelateV1 = [];  %第一类参考向量关联的鲁棒解
    rRelateV2 = [];  %第二类参考向量关联的鲁棒解
    rRelateV3 = [];  %第三类参考向量关联的鲁棒解
    v3All     = [];  %所有可能会与第三类参考向量关联的鲁棒解
    N = Problem.N;
    flagW   = zeros(1,N);
    flagV1  = flagW;  %第一类权重向量索引
    flagV2  = flagW;  %第二类权重向量索引
    flagV3  = flagW;  %第三类权重向量索引
    % flagV12 = flagW;  %第一二类权重向量索引

    flagN0R = zeros(1,N);   % 向量关联的鲁棒解是0个还是1个(0表示0个，1表示1个，即初始时都不关联鲁棒解)
    flagG1R = zeros(1,N);  % 有超过一个鲁棒解关联的向量(1表示有)
    
    populationOne   = [];
    populationTwo   = [];
    populationThree = [];

    RFE = 0;

    % 存档中所有解按pbi值排序
    for i = 1 : Problem.N
        level   = IndexArr(i) + 1;
        % 只有存档发生过替换才重新排序
        if level > ArchGEN
            level = ArchGEN;
            ArchVObjs = cell2mat(ObjsArch(1:level,i));  %单个权重向量上的所有存档解的目标值
            normW   = repmat(sqrt(sum(W(i,:).^2,2)), level, 1);
            normP   = sqrt(sum((ArchVObjs-repmat(Z,level,1)).^2,2));
            CosineP = sum((ArchVObjs-repmat(Z,level,1)).*repmat(W(i,:),level,1),2)./normW./normP;
            g_v   = normP.*CosineP + 5*normP.*sqrt(1-CosineP.^2);
            [~, idx] = sort(g_v); % 对键进行排序，获取排序后的索引
            DecsArch(:,i)  = DecsArch(idx,i); % 重新排列
            ObjsArch(:,i)  = ObjsArch(idx,i); % 重新排列
        end
    end

    % 判断最后一代解的鲁棒解
    rRelateV1Objs = cell(1,1);
    Reta    = RobustEta(Problem,Population); 
    xR      = find(Reta <= eta);     %鲁棒解
    PopR    = Population(xR);  % 为一行多列

    % disp("*********Reta************");
    % disp(Reta);
    % disp("*********xR************");
    % disp(xR);
    % disp("*********************");

    % disp("*********PopR************");
    % disp(num2str(size(PopR,2)));
    V1len = 0;
    if ~isempty(PopR)
        [~,n]  = size(PopR);
        
        for i = 1 : n
            pop = PopR(i);
            obj = pop.obj;
            %找到与这个解角度最近的权重向量
            t = [];
            for y = 1 : Problem.N
                s = sum(W(y,:).*obj,2);
                m = sqrt(sum(W(y,:).*W(y,:),2)*sum(obj.*obj,2));
                t(1,y) = acos(s/m);
            end
            [~,h]     = min(t(1,:));
            if flagV1(h) == 1   %该权重向量有关联的鲁棒解
                if flagG1R(h) == 0  %该权重向量只有一个鲁棒解
                    v3All = [v3All,pop];
                    flagG1R(h) = 1;
                end
            else  %该权重向量无关联的鲁棒解
                flagN0R(h) = 1;
                flagV1(h) = 1;
                rRelateV1 = [rRelateV1,pop];
                V1len = V1len + 1;
                rRelateV1Objs{V1len,1} = obj;
            end
        end
    end

    % 权重向量关联鲁棒解，将权重向量分为三类
    for i = 1 : Problem.N
        if flagG1R(i) == 1
            continue;  %这个权重向量已经有两个关联的鲁棒解
        end
        %下面是：这个权重向量有0个或者1个鲁棒解
        level   = IndexArr(i) + 1;
        if level > ArchGEN
            level = ArchGEN;
        end
        k = 1;
        while k <= level
            if k == 1
                obj = ObjsArch(k,i); % 存档的第一层有可能是最后代种群中的解
                % tempObjs = rRelateV1.objs;
                if Unique(cell2mat(obj),cell2mat(rRelateV1Objs),size(rRelateV1,2),size(rRelateV1,2)) == 1
                    k = k + 1;
                    continue;
                end
            end
            pop = Problem.Evaluation(DecsArch{k,i});
            if RobustEta(Problem,pop) <= eta
                if flagN0R(i) == 1     % 该权重向量上已经有一个关联的鲁棒解
                    v3All = [v3All,pop];
                    flagG1R(i) = 1;  %这个解是第二类向量的第二个鲁棒解
                    break;
                else  % 该权重向量上没有关联的鲁棒解
                    flagN0R(i) = 1;  % 这个解是第二类向量的第一个鲁棒解
                    flagV2(i) = 1;  
                    rRelateV2 = [rRelateV2,pop];
                end
            end
            k = k + 1;
        end
    end

    flagV3 = ones(1,N) - flagN0R;
              
    v3size = size(v3All,2); 
    v3keep = ones(1,v3size); %v3All没有选择的解

    for i = 1 : Problem.N
        if length(find(v3keep == 1)) == 0 %v3All的解已经选完
            break;    
        end
        if flagV3(i) == 1
            t = [];
            for j = 1 : v3size;
                if v3keep(j) == 1
                    obj = v3All(j).obj;
                    s = sum(W(i,:).*obj,2);
                    m = sqrt(sum(W(i,:).*W(i,:),2)*sum(obj.*obj,2));
                    t(1,j) = acos(s/m);
                end
            end
            [~,v3select]     = min(t(1,:));
            v3keep(v3select) = 0;
            rRelateV3 = [rRelateV3, v3All(v3select)];
            flagV3(i) = 0;
        end
    end
  
    % 三类鲁棒解数量不够权重向量关联, 用最终代种群非鲁棒解补足
    if length(find(flagV3 == 1)) > 0
        PopNR   = Population(find(Reta > eta)); %非鲁棒解
        PopNRsize = size(PopNR,2); 
        PopNRkeep = ones(1,PopNRsize); %PopNR没有选择的解

        for i = 1 : Problem.N
            if length(find(PopNRkeep == 1)) == 0 %PopNR的解已经选完
                break;    
            end
            if flagV3(i) == 1
                t = [];
                for j = 1 : PopNRsize;
                    if PopNRkeep(j) == 1
                        obj = PopNR(j).obj;
                        s = sum(W(i,:).*obj,2);
                        m = sqrt(sum(W(i,:).*W(i,:),2)*sum(obj.*obj,2));
                        t(1,j) = acos(s/m);
                    end
                end
                [~,PopNRselect]     = min(t(1,:));
                PopNRkeep(PopNRselect) = 0;
                rRelateV3 = [rRelateV3, PopNR(PopNRselect)];
                flagV3(i) = 0;
            end
        end
        % disp("缺少***");
    end

    %为第三类权重向量寻找关联解
    % rRelateV3 = FindThreeP(v3All,flagV3,W,Z);

    disp(num2str(size(rRelateV1,2)));
    disp(num2str(size(rRelateV2,2)));
    disp(num2str(size(rRelateV3,2)));
    % disp("*************");
    % error("停止");

    if ~isempty(rRelateV1)
        if length(find(flagV1 == 1)) == 1
            % populationThree = Problem.Evaluation(rRelateV3.decs);
            populationOne = Problem.Evaluation(rRelateV1.decs);
        else
            % RFE = RFE + size(rRelateV3,2)*100*50;
            % populationThree = DeGuideThree(Problem, rRelateV3, flagV3, W, Z, eta);
            populationOne = DeGuideThree(Problem, rRelateV1, flagV1, W, Z, eta);
            % populationThree = DeGuideThree(Problem,Arch{gen,:}, flagV3, W, Z, eta);
        end
        % populationOne = Problem.Evaluation(rRelateV1.decs);
    end

    %第二类向量关联解被引导
    if ~isempty(rRelateV2)
        if length(find(flagV2 == 1)) == 1
            % populationThree = Problem.Evaluation(rRelateV3.decs);
            populationTwo = rRelateV2;
        else
            RFE = RFE + size(rRelateV2,2)*100*50;
            populationTwo = DeGuideTwo(Problem, Population, rRelateV2, flagV2, W, Z, eta);
        end
    end
    % error('用于rRelateV2,程序终止');


    %第三类向量关联解被引导
    flagV3 = ones(1,N) - flagN0R;
    if length(find(flagV3 == 1)) > 0
        if ~isempty(rRelateV3)
            if length(find(flagV3 == 1)) == 1
                populationThree = Problem.Evaluation(rRelateV3.decs);
            else
                RFE = RFE + size(rRelateV3,2)*100*50;
                populationThree = DeGuideThree(Problem, rRelateV3, flagV3, W, Z, eta);
                % populationThree = DeGuideThree(Problem,Arch{gen,:}, flagV3, W, Z, eta);
            end
        end
    end


    Population = [populationOne, populationTwo, populationThree];
    % Population = [populationOne, Problem.Evaluation(rRelateV2.decs), Problem.Evaluation(rRelateV3.decs)];
    Population(1).add = RFE;
    
end


