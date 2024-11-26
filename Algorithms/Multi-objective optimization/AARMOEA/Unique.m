function noRepeat = Unique(arch,allUnique)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin 
   
    % noRepeat = arch(find(repeat==1));
    tolerance = 1e-4; % 定义一个很小的容差
    m      = size(arch,2);  %archR只有一行？
    n      = size(allUnique,2);
    repeat = ones(m,1);
    for i = 1 : m   
        for j = 1 : n
            if all( abs(arch(i).decs - allUnique(j).decs) < tolerance ) 
                % || all( abs(arch(i).objs - allUnique(j).objs) < tolerance )
                repeat(i,1) = 0;
                break;
            end
        end
    end
    noRepeat = arch(find(repeat==1));
end