function Population = Final(Problem,Arch,N,W,gen,Z,eta)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    rAndUnique = [];  %鲁棒解且不重复解
    rAndRemain = [];  %鲁棒解且未被选上的解
    rAndRelate = [];  %鲁棒且与向量关联的解
 
    rRelateV1 = [];  %第一类参考向量关联的鲁棒解
    rRelateV2 = [];  %第二类参考向量关联的鲁棒解
    rRelateV3 = [];  %第三类参考向量关联的鲁棒解
    v3All     = [];  %所有可能会与第三类参考向量关联的解

    flagW   = zeros(1,N);
    flagV1  = flagW;  %第一类权重向量索引
    flagV2  = flagW;  %第二类权重向量索引
    flagV3  = flagW;  %第三类权重向量索引
    flagV12 = flagW;  %第一二类权重向量索引
    
    populationOne   = [];
    populationTwo   = [];
    populationThree = [];

    tolerance = 1e-4; % 定义一个很小的容差
    index = gen;

    while index >= 2*(gen/5) || (index >= 1 && (length(find(flagV12 == 1)) + size(v3All,2) < N))
        [archR, archNR]= Remain(Problem,Arch{index,:},eta); % 去掉这一代非鲁棒解
        %如果这一代没有鲁棒解
        if isempty(archR)  
            index = index - 1;
            continue;
        end
        noRepeatR = []; %这一代不重复的鲁棒解
        % 去掉这一代重复鲁棒解
        if isempty(rAndUnique)
            rAndUnique = archR;
            noRepeatR = archR;
            % disp(["isempty"]);
        else
            m      = size(archR,2);  %archR只有一行？
            n      = size(rAndUnique,2);
            repeat = ones(m,1);
            for i = 1 : m   
                for j = 1 : n
                    if all( abs(archR(i).decs - rAndUnique(j).decs) < tolerance ) 
                        % || all( abs(archR(i).objs - visitArch(j).objs) < tolerance )
                        repeat(i,1) = 0;
                        break;
                    end
                end
            end
            noRepeatR = archR(find(repeat==1));
            rAndUnique = [rAndUnique,noRepeatR];
        end
       
        if index == gen
            % 寻找第一类向量关联鲁棒解,剩下的解作为可能会与第三类参考向量关联的解
            [relatR,v3Res,flagW] = Assign(flagW,noRepeatR,W,Z);
            rRelateV1 = relatR;
            v3All = v3Res;
            flagV1 = flagW;
        else
            % 寻找第二类向量关联鲁棒解,剩下的解作为可能会与第三类参考向量关联的解
            [relatR,v3Res,flagW] = Assign(flagW,noRepeatR,W,Z);
            rRelateV2 = [rRelateV2, relatR];
            v3All = [v3All, v3Res];
            flagV12 = flagW;
        end

        index = index - 1;
        % disp(["index: ",num2str(index)]);
        
        %所有权重向量都有关联的解
        if(length(find(flagW == 0)) == 0)
            break;
        end
    end

    flagV2 = flagV12 - flagV1;
    flagV3 = ones(1,N) - flagV12;
 
    % 三类鲁棒解数量不够权重向量关联
    if length(find(flagV12 == 1)) + size(v3All,2) < N
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
        populationTwo = DeGuideTwo(Problem, Arch{gen,:}, rRelateV2, flagV2, W, Z, eta);
    end
    % error('用于rRelateV2,程序终止');

    %第三类向量关联解被引导
    if ~isempty(rRelateV3)
        populationThree = DeGuideThree(Problem, rRelateV3, flagV3, W, Z, eta);
        % populationThree = DeGuideThree(Problem,Arch{gen,:}, flagV3, W, Z, eta);
    end


    Population = [populationOne, populationTwo, populationThree];

    
end


