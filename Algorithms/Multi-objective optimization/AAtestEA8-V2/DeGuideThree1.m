function Population = DeGuideThree1(Problem, Population, rRelate, flag, W, Z, eta)

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
    offPop = [];
    wr = find(flag == 1);
    Vsize = length(find(flag == 1));
    Popsize = size(Population,2); 
    Popkeep = ones(1,Popsize); %Pop没有选择的解
    for i = 1 : Vsize
        y = wr(i);
        t = [];
        for j = 1 : Popsize
            if Popkeep(j) == 1
                obj = Population(j).obj;
                s = sum(W(y,:).*obj,2);
                m = sqrt(sum(W(y,:).*W(y,:),2)*sum(obj.*obj,2));
                t(1,j) = acos(s/m);
            end
        end
        [~,Popselect]     = min(t(1,:));  %寻找离第二类权重向量最近的终代解
        Popkeep(Popselect) = 0;
        offA = Population(Popselect);

        offB = rRelate(i);
        normW   = sqrt(sum(W(y,:).^2,2));
        normP   = sqrt(sum((offB.obj-Z).^2,2));
        CosineP = sum((offB.obj-Z).*W(y,:),2)./normW./normP;
        g_old   = normP.*CosineP + 5*normP.*sqrt(1-CosineP.^2);

        guideFE = 100;
        while guideFE > 0
            guideFE = guideFE - 1;
            % offC = OperatorGAhalf(Problem,[offA,offB]);
            offC = OperatorGAhalf(Problem,[offA,offB], {1,10,1,50});
            obj = offC.obj;
            normO   = sqrt(sum((obj-Z).^2,2));
            CosineO = sum((obj-Z).*W(y,:),2)./normW./normO;
            g_new   = normO.*CosineO + 5*normO.*sqrt(1-CosineO.^2);

            if g_new <= g_old
                REC = RobustEta(Problem,offC);
                if REC <= eta 
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