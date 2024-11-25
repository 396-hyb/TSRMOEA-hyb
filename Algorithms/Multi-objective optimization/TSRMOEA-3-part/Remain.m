function [archR, archNR] = Remain(Problem,arch,eta)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin 
    % flag = mean(RobustEta(Problem,arch), 2); 
    flag = RobustEta(Problem,arch); 
    % x            = find(conv==0);    
    xR      = find(flag <= eta);     %鲁棒解
    xNR      = find(flag > eta);     %非鲁棒解
    archR   = arch(xR);  % 为一行多列
    archNR   = arch(xNR);  
end