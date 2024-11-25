function popG = Spread(population,flag,con)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin
      
    objs = population.objs;
    keys = objs(:,1);  % 提取每个元素的第一个目标值
    [~, idx] = sort(keys);  % 对键进行排序，获取排序后的索引
    popS  = population(idx);  % 重新排列
    if con == 1
        popG  = popS(flag == 1);  
    else
        popG = popS;
    end
    wr    = find(flag == 1);
    len   = size(popG,2);
    for i = 1 : len
        popG(i).vno = wr(i);
    end 

end