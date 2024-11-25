function Population = Final(Problem,Arch,N,W,gen,Z,eta)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% 一类和二类的解作为第三类解

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
                [rRelateV,resV3,flagG1R,flagN0R] = VeClassify(Problem,flagG1R,flagN0R,noRepeat,eta,W,Z);
                rRelateV1 = rRelateV;
                v3All = resV3;
                flagV1 = flagN0R;
            else
                [rRelateV,resV3,flagG1R,flagN0R] = VeClassify(Problem,flagG1R,flagN0R,noRepeat,eta,W,Z);
                if ~isempty(rRelateV)
                    rRelateV2 = [rRelateV2,rRelateV];
                end
                if ~isempty(resV3)
                    v3All = [v3All,resV3];
                end
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
    rRelateV3 = FindThree([rRelateV1,rRelateV2],flagV3,W,Z);

    % wr    = find(flagV3 == 1);
    % len   = size(rRelateV3,2);
    % for i = 1 : len
    %     rRelateV3(i).vno = wr(i);
    % end 

    % disp(num2str(size(rRelateV1,2)));
    disp(num2str(size(rRelateV2,2)));
    % disp(num2str(size(rRelateV3,2)));
    % disp(num2str(size(rRelateV1,2)));
    % disp(rRelateV1.vnos);  % 显示关联后权重索引
    % disp("*************1");
    % disp(rRelateV2.vnos);  % 显示关联后权重索引
    % disp("*************2");
    % disp(rRelateV3.vnos);  % 显示关联后权重索引
    % disp("*************3");
    % disp(find(flagV3 == 1));  % 显示关联后权重索引
    % disp("*************3");
    % error("停止");

    if ~isempty(rRelateV1)
        populationOne = Problem.Evaluation(rRelateV1.decs);
    end


    
    % Population = Problem.Perturb(Population1.decs,1).best;
    data = rRelateV2.objs;  
    plot(data(:,1), data(:,2), 'o');
    title('第二类鲁棒解-未进化');
    xlabel('目标1');
    ylabel('目标2');
    saveas(gcf, ['Plot_R1.png']);  % 保存为 PNG 文件


    rRelateV21 = Spread(Arch{gen,:},flagV2,1);
    data = rRelateV21.objs;  
    plot(data(:,1), data(:,2), 'o');
    title('第二类非鲁棒解');
    xlabel('目标1');
    ylabel('目标2');
    saveas(gcf, ['Plot_NR1.png']);  % 保存为 PNG 文件

    %第二类向量关联解被引导
    if ~isempty(rRelateV2)
        populationTwo = DeGuideTwo(Problem, Arch{gen,:}, rRelateV2, flagV2, W, Z, eta);
    end
    data = populationTwo.objs;  
    plot(data(:,1), data(:,2), 'o');
    title('第二类鲁棒解-单个体引导进化');
    xlabel('目标1');
    ylabel('目标2');
    saveas(gcf, ['Plot_R2.png']);  % 保存为 PNG 文件

    if length(find(flagV2 == 1)) > 0
        if ~isempty(rRelateV2)
            % populationThree = Problem.Evaluation(rRelateV3.decs);
            if length(find(flagV2 == 1)) == 1
                populationTwo = Problem.Evaluation(rRelateV2.decs);
            else
                populationTwo = DeGuideThree(Problem, rRelateV2, flagV2, W, Z, eta);
            end
        end
    end

    data = populationTwo.objs;  
    plot(data(:,1), data(:,2), 'o');
    title('第二类鲁棒解-种群共同进化');
    xlabel('目标1');
    ylabel('目标2');
    saveas(gcf, ['Plot_R3.png']);  % 保存为 PNG 文件

    
    error('用于rRelateV2,程序终止');
    %第三类向量关联解被引导
    % if length(find(flagV3 == 1)) > 0
    %     if ~isempty(rRelateV3)
    %         % populationThree = Problem.Evaluation(rRelateV3.decs);
    %         if length(find(flagV3 == 1)) == 1
    %             populationThree = Problem.Evaluation(rRelateV3.decs);
    %         else
    %             populationThree = DeGuideThree(Problem, rRelateV3, flagV3, W, Z, eta);
    %         end
    %     end
    % end
    if ~isempty(rRelateV3)
        populationThree = DeGuideTwo(Problem,Arch{gen,:}, rRelateV3, flagV3, W, Z, eta);
    end


    Population = [populationOne, populationTwo, populationThree];

    
end


