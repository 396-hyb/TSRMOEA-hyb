function Matrix = DisCreat(PopObj, level)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin

% 受PREA启发，根据解之间的距离比率删除最密集的解
    Matrix = ones(level,level);
    for i = 1 : level
        obj            = PopObj(i,:);
        DisMax         = PopObj./repmat(obj,level,1) - 1;  % - 1 是代替log的运算，更简单
        DisMim         = repmat(obj,level,1)./PopObj - 1;
        MaxCost        = max(DisMax,[],2);
        MinCost        = max(DisMim,[],2);
        DIs            = find(MaxCost<=0);
        MaxCost(DIs)   = -MinCost(DIs);
        Matrix(i,:)    = MaxCost';
        Matrix(i,i)    = Inf;
    end
end