function score = IGDRW(Population,Problem)
% <min> <multi/many> <real/integer/label/binary/permutation> <large/none> <constrained/none> <expensive/none> <multimodal/none> <sparse/none> <dynamic/none> <robust>
% robust inverted generational distance (for robust optimization)

%------------------------------- Reference --------------------------------
% C. A. Coello Coello and N. C. Cortes, Solving multiobjective optimization
% problems using an artificial immune system, Genetic Programming and
% Evolvable Machines, 2005, 6(2): 163-190.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    Population    = Population.best;
    PopObj        = Population.objs;
    N             = length(Population);
    [D, PopIndex] = min(pdist2(Problem.optimum,PopObj),[],2);
    for i = 1 : N
        PopX         = Problem.Perturb(Population(i).decs); % PopX为50行2列矩阵
        PopObjV(i,:) = max(PopX.objs); 
        E(i,:)       = abs(PopObjV(i,:) - PopObj(i,:))./(PopObjV(i,:));
    end
    R   = mean(E,2);  

    score =  mean(D.*R(PopIndex) + D);
end
