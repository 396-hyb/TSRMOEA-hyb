function Population = DeGuideTwo(Problem, Population, rRelate, flag, W, Z, eta)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    
   

    % disp(rRelateG.objs);
    % disp(rRelateG.vnos);
    % disp("rRelateG2+++++");

    % error('用于查看结果，程序终止');
    wr = find(flag == 1);
    PopNR = Population(wr);
    % guidePop = Problem.Evaluation(rRelate.decs);
    guidePop = rRelate;
    len   = size(rRelate,2);
    WG = W(wr,:);
    T = ceil(min(10,len));
    % T = ceil(len);
    B = pdist2(WG,WG);
    [~,B] = sort(B,2);
    B = B(:,1:T);

    % objs = guidePop.objs;
    % keys = objs(:,1);  % 提取每个元素的第一个目标值
    % [~, idx] = sort(keys);  % 对键进行排序，获取排序后的索引
    % guidePop  = guidePop(idx);  % 重新排列
    % disp(wr);
    % disp("wr+++++");
    % disp(PopNR.objs);
    % disp("PopNR+++++");
    % disp(guidePop.objs);
    % disp("guidePop+++++");

    % for i = 1 : len
    %     obj = guidePop(i).obj;
    %     for y = 1 : Problem.N
    %         s = sum(W(y,:).*obj,2);
    %         m = sqrt(sum(W(y,:).*W(y,:),2)*sum(obj.*obj,2));
    %         t(1,y) = acos(s/m);
    %     end
    %     [~,h] = min(t(1,:));
    %     disp(num2str(h));
    % end
    % disp("wr+++++");
    % error('用于查看结果，程序终止');


    guideFE = 100;
    while guideFE > 0
        guideFE = guideFE - 1;

        for i = 1 : len
            P = B(i,randperm(size(B,2)));
            Offspring = OperatorGAhalf(Problem, PopNR(P(1:2)), {1,20,0.5,20});
            Z = min(Z,Offspring.obj);
            normW   = sqrt(sum(W(P,:).^2,2));
            normP   = sqrt(sum((PopNR(P).objs-repmat(Z,T,1)).^2,2));
            normO   = sqrt(sum((Offspring.obj-Z).^2,2));
            CosineP = sum((PopNR(P).objs-repmat(Z,T,1)).*W(P,:),2)./normW./normP;
            CosineO = sum(repmat(Offspring.obj-Z,T,1).*W(P,:),2)./normW./normO;
            g_old   = normP.*CosineP + 5*normP.*sqrt(1-CosineP.^2);
            g_new   = normO.*CosineO + 5*normO.*sqrt(1-CosineO.^2);
            PopNR(P(g_old>=g_new)) = Offspring;
        end

        for i = 1 : len
            P = B(i,randperm(size(B,2)));
            Offspring = OperatorGAhalf(Problem,[PopNR(i),guidePop(i)]);
            % Offspring = OperatorGAhalf(Problem,[PopNR(i),guidePop(i)],{1,20,0.5,50});
            % Offspring = OperatorGAhalf(Problem,guidePop(P(1:2)), {1,10,1,50});
            Z = min(Z,Offspring.obj);

            normW   = sqrt(sum(WG(P,:).^2,2));
            normP   = sqrt(sum((guidePop(P).objs-repmat(Z,T,1)).^2,2));
            normO   = sqrt(sum((Offspring.obj-Z).^2,2));
            CosineP = sum((guidePop(P).objs-repmat(Z,T,1)).*WG(P,:),2)./normW./normP;
            CosineO = sum(repmat(Offspring.obj-Z,T,1).*WG(P,:),2)./normW./normO;
            g_old   = normP.*CosineP + 5*normP.*sqrt(1-CosineP.^2);
            g_new   = normO.*CosineO + 5*normO.*sqrt(1-CosineO.^2);

            RE = RobustEta(Problem,Offspring);
            if RE <= eta
                guidePop(P(g_old>=g_new)) = Offspring;
               
            end
        end
    end

    Population = guidePop;
end