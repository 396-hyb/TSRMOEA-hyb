function [Arch] = ArchUpdate(Problem,Population,arch,gen)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    TemArch = archives(Population.decs, Population.objs, gen);
    
    if isempty(arch)
        Arch = TemArch;
    else
        Arch = [arch;TemArch];
    end
end
