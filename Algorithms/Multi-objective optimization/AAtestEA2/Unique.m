function isEqual = Unique(obj,ArchVObjs,arPopNum,ArchGEN)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin 
    tolerance = 1e-5; % 定义一个很小的容差
    m = arPopNum + 1;
    if m > ArchGEN
        m = ArchGEN;
    end
    isEqual = 0;
    
    %% 可以优化吗？
    for i = 1 : m   
        if all(abs(obj - ArchVObjs(i))) < tolerance 
            isEqual = 1;
            break;
        end
    end
end