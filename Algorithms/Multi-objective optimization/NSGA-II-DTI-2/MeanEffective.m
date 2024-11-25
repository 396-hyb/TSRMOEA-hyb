function PopObjV = MeanEffective(Problem,Population)
% Calculate the mean objective values of each solution in the vicinity

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    for i = 1 : length(Population)
        PopX         = Problem.Perturb(Population(i).dec);
        PopObjV(i,:) = mean(PopX.objs,1);
        % PopObjV(i,:) = max(PopX.objs,[],2);
        % M = mean(A, dim)， dim = 1：计算每列的平均值，结果是一个行向量
    end
end