function Population = newPop_TP8()

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
         % TP8
        PopDec1 = zeros(100, 5);  % 一次性创建一个 100x30 的零矩阵
        PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
        % PopDec1(:,2) = repmat(0.85, 100, 1); %global
        PopDec1(:,2) = repmat(0.35, 100, 1); %local
        PopObj1(:,1) = PopDec1(:,1);
        h = 2 - 0.8*exp(-((PopDec1(:,2)-0.35)/0.25).^2) - exp(-((PopDec1(:,2)-0.85)/0.03).^2);
        g = 50*sum(PopDec1(:,3:end).^2,2);
        S = 1 - sqrt(PopObj1(:,1));
        PopObj1(:,2) = h.*(g+S);
        PopCon1 = zeros(size(PopDec1,1),1);
        Population = SOLUTION(PopDec1,PopObj1,PopCon1);
end