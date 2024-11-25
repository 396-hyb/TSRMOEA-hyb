function Population = newPop_TP6()

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
         % TP7
        PopDec1 = zeros(100, 5);  % 一次性创建一个 100x30 的零矩阵
        PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
        PopObj1(:,1) = PopDec1(:,1);
        h = 1 - PopDec1(:,1).^2;
        g = sum(10-10*cos(4*pi*(PopDec1(:,2:end)))+PopDec1(:,2:end).^2,2);
        S = 1./(0.2+PopDec1(:,1)) + PopDec1(:,1).^2;
        PopObj1(:,2) = h + g.*S;
        PopCon1 = zeros(size(PopDec1,1),1);
        Population = SOLUTION(PopDec1,PopObj1,PopCon1);
        % numZeros_TP7 = Classification(Problem,Population);
        % disp(['numZeros_TP7:', num2str(numZeros_TP7)]);   
end