function relat = Assign(flagG1R,noRepeat,W,Z)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin
% 选择鲁棒解<=1个的向量，返回与这些向量关联的解
    objs   = noRepeat.objs ;
    n      = size(noRepeat,2);
    index  = zeros(1,n);
    [N ,~] = size(W);
    relat  = [];
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
        noRepeat(x).vno = h;
        if flagG1R(h) == 0
            index(x) = 1;
        end
    end
    relat = noRepeat(index == 1);
end