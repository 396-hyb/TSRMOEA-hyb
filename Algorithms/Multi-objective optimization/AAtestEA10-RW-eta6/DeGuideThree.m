function Population = DeGuideThree(Problem, rRelate, flag, W, Z, eta)


%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    
    %分配鲁棒解到空权重向量
    % rRelateG = Spread(rRelate,flag,0);

    %% 引导进化
    guidePop = Problem.Evaluation(rRelate.decs);
    len   = size(rRelate,2);
    wr = find(flag == 1);
    WG = W(wr,:);
    T = ceil(min(10,len));
    B = pdist2(WG,WG);
    [~,B] = sort(B,2);
    B = B(:,1:T);

    guideFE = 100;
    while guideFE > 0
        guideFE = guideFE - 1;
        for i = 1 : len
            P = B(i,randperm(size(B,2)));
            Offspring = OperatorGAhalf(Problem,guidePop(P(1:2)));
            % Offspring = OperatorGAhalf(Problem,guidePop(P(1:2)), {1,10,1,50});
            Z = min(Z,Offspring.obj);
            % g_old = max(abs(guidePop(P).objs-repmat(Z,T,1)).*WG(P,:),[],2);
            % g_new = max(repmat(abs(Offspring.obj-Z),T,1).*WG(P,:),[],2);
            % Zmax  = max(guidePop.objs,[],1);
            % g_old = max(abs(guidePop(P).objs-repmat(Z,T,1))./repmat(Zmax-Z,T,1).*WG(P,:),[],2);
            % g_new = max(repmat(abs(Offspring.obj-Z)./(Zmax-Z),T,1).*WG(P,:),[],2);

            normW   = sqrt(sum(WG(P,:).^2,2));
            normP   = sqrt(sum((guidePop(P).objs-repmat(Z,T,1)).^2,2));
            normO   = sqrt(sum((Offspring.obj-Z).^2,2));
            CosineP = sum((guidePop(P).objs-repmat(Z,T,1)).*WG(P,:),2)./normW./normP;
            CosineO = sum(repmat(Offspring.obj-Z,T,1).*WG(P,:),2)./normW./normO;
            g_old   = normP.*CosineP + 5*normP.*sqrt(1-CosineP.^2);
            g_new   = normO.*CosineO + 5*normO.*sqrt(1-CosineO.^2);

            RE = RobustEta(Problem,Offspring);
            if RE <= eta
                % guidePop(P(g_old>g_new)) = Offspring;
                if ~isempty(find(all(Offspring.cons<=0,2)))
                    guidePop(P(g_old>=g_new)) = Offspring;
                end
                % if size(P(g_old>g_new)) > 0
                %     disp(["swap3"]);
                % end
            end
        end
    end

    Population = guidePop;

end