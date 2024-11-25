function Population = DeGuideTwo(Problem, arcEnd, rRelate, flag, W, Z, eta)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    
    %分配原始解和鲁棒解到空权重向量
    arcEndG  = Spread(arcEnd,flag,1);
    rRelateG = Spread(rRelate,flag,0);
   
    
    % disp(arcEndG.objs);  % 显示关联后目标值
    % disp(arcEndG.vnos);  % 显示关联后权重索引
    % disp("arcEndG+++++");

    % disp(rRelateG.objs);
    % disp(rRelateG.vnos);
    % disp("rRelateG2+++++");

    % error('用于查看结果，程序终止');
    

    
    %% 引导进化
    [N ,~] = size(W);

    wr = find(flag == 1);
    len = size(rRelateG,2);
    offPop = [];
    for i = 1 : len
        offA = Problem.Evaluation(arcEndG(i).decs);
        offB = offA;
        for j = 1 : len
            if rRelateG(j).vno == arcEndG(i).vno
                offB = Problem.Evaluation(rRelateG(j).decs);
                break;
            end
        end
        y = arcEndG(i).vno;
        normW   = sqrt(sum(W(y,:).^2,2));

        normP   = sqrt(sum((offB.obj-Z).^2,2));
        CosineP = sum((offB.obj-Z).*W(y,:),2)./normW./normP;
        g_old   = normP.*CosineP + 5*normP.*sqrt(1-CosineP.^2);

        guideFE = 100;
        while guideFE > 0
            % guideFE = guideFE - 1;
            offC = OperatorGAhalf(Problem,[offA,offB]);
            obj = offC.obj;
            % if ~isempty(offPop)
            %     Z = min(Z,offPop.obj);
            % end
            % g_old = max(abs(guidePop(P).objs-repmat(Z,T,1)).*WG(P,:),[],2);
            % g_new = max(repmat(abs(Offspring.obj-Z),T,1).*WG(P,:),[],2);
            normO   = sqrt(sum((obj-Z).^2,2));
            CosineO = sum((obj-Z).*W(y,:),2)./normW./normO;
            g_new   = normO.*CosineO + 5*normO.*sqrt(1-CosineO.^2);

            % for index = 1 : N
            %     s = sum(W(index,:).*obj,2);
            %     m = sqrt(sum(W(index,:).*W(index,:),2)*sum(obj.*obj,2));
            %     t(1,index) = acos(s/m);
            % end
            % [~,h]     = min(t(1,:));

            % if h == y && all(offB.obj >= offC.obj)
            guideFE = guideFE - 1;
            
            % if h == y && g_old>=g_new
            if g_old>=g_new
                RE = RobustEta(Problem,offC);
                if RE <= eta 
                    offB = offC;
                    g_old = g_new;
                    disp(["swap2"]);
                end
            end
        end
        offPop = [offPop, offB];
    end

    Population = offPop;
end