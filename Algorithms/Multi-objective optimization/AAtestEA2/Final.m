function Population = Final(Problem,Arch,N,W,gen,Z,eta)

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

    index = gen;

    RFE = 0;


    % 存档中所有解按pbi值排序
    for i = 1 : Problem.N
        
        level   = IndexArr(i) + 1;
        if level > ArchGEN
            level = ArchGEN;
        end

        ArchVObjs = cell2mat(ObjsArch(1:level,i));  %单个权重向量上的所有存档解的目标值

        % P = B(i,randperm(size(B,2)));
        Z = min(Z,Offspring.obj);
        normW   = repmat(sqrt(sum(W(i,:).^2,2)), level, 1);
        normP   = sqrt(sum((ArchVObjs-repmat(Z,level,1)).^2,2));
        % normO   = sqrt(sum((Offspring.obj-Z).^2,2));
        CosineP = sum((ArchVObjs-repmat(Z,level,1)).*repmat(W(i,:),level,1),2)./normW./normP;
        % CosineO = sum(repmat(Offspring.obj-Z,T,1).*W(P,:),2)./normW./normO;
        g_v   = normP.*CosineP + 5*normP.*sqrt(1-CosineP.^2);
        % g_new   = normO.*CosineO + 5*normO.*sqrt(1-CosineO.^2);
        [~, idx] = sort(g_v); % 对键进行排序，获取排序后的索引
        ObjsArch(:,i) = ObjsArch(idx,i); % 重新排列
        DecsArch(:,i)  = DecsArch(idx,i); % 重新排列
    end

    while index >= 1

        % 去掉重复解
        arch = Arch{index,:};
        if isempty(allUnique)
            noRepeat = arch;
        else
            noRepeat = Unique(arch,allUnique);
        end

        if ~isempty(noRepeat)
            if index == gen
                [rRelateV,resV3,flagG1R,flagN0R,Rfe] = VeClassify(Problem,flagG1R,flagN0R,noRepeat,eta,W,Z);
                rRelateV1 = rRelateV;
                v3All = resV3;
                flagV1 = flagN0R;
                RFE = RFE + Rfe;
            else
                [rRelateV,resV3,flagG1R,flagN0R,Rfe] = VeClassify(Problem,flagG1R,flagN0R,noRepeat,eta,W,Z);
                if ~isempty(rRelateV)
                    rRelateV2 = [rRelateV2,rRelateV];
                end
                if ~isempty(resV3)
                    v3All = [v3All,resV3];
                end
                RFE = RFE + Rfe;
            end
        end
        allUnique = [rRelateV1,rRelateV2,v3All];

        index = index - 1;
        % disp(["index: ",num2str(index)]);
        
        %所有权重向量都有关联的解
        if(length(find(flagN0R == 0)) == 0)
            break;
        end
    end


    flagV3 = ones(1,N) - flagN0R;
    flagV2 = ones(1,N) - flagV1 - flagV3;
 
    % 三类鲁棒解数量不够权重向量关联
    if length(find(flagV3 == 1)) > size(v3All,2) 
        v3All = [v3All, Spread(Arch{gen,:},flagV3,1)];
        disp("缺少***");
    end

    %为第三类权重向量寻找关联解
    rRelateV3 = FindThreeP(v3All,flagV3,W,Z);

    disp(num2str(size(rRelateV1,2)));
    disp(num2str(size(rRelateV2,2)));
    disp(num2str(size(rRelateV3,2)));
    % disp("*************");
    % error("停止");

    if ~isempty(rRelateV1)
        populationOne = Problem.Evaluation(rRelateV1.decs);
    end

    %第二类向量关联解被引导
    if ~isempty(rRelateV2)
        RFE = RFE + size(rRelateV2,2)*100*50;
        populationTwo = DeGuideTwo(Problem, Arch{gen,:}, rRelateV2, flagV2, W, Z, eta);
    end
    % error('用于rRelateV2,程序终止');

    %第三类向量关联解被引导
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
    Population(1).add = RFE;
    
end


