function [relatR,v3Res,flagT] = Assign(flagW,noRepeatR,W,Z)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin
    objs   = noRepeatR.objs ;

    [~,n]  = size(noRepeatR);
    [N ,~] = size(W);

    relatR  = [];
    v3Res  = [];
    flagT = flagW;
    for x = 1 : n
        obj = objs(x,:);
        
        %找到与这个解角度最近的权重向量
        t = [];
        for y = 1 : N
            s = sum(W(y,:).*obj,2);
            m = sqrt(sum(W(y,:).*W(y,:),2)*sum(obj.*obj,2));
            t(1,y) = acos(s/m);
        end
        [~,h]     = min(t(1,:));
        noRepeatR(x).vno = h;
        
        if flagT(h) == 1
            % 序号为h的权重向量有关联的鲁棒解，这个解作为要与第三类向量关联的候选解
            v3Res = [v3Res, noRepeatR(x)];
        else
            % 序号为h的权重向量无关联的鲁棒解，这个解是与第一、二类向量关联的解
            flagT(h) = 1;
            relatR = [relatR, noRepeatR(x)];
        end
    end
end