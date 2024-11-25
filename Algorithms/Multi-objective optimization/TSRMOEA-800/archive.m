classdef archive < handle
    
%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    properties
        dec;
        obj;
        gen;
        vno;
    end
    methods      
        function [Arch] = archive(Dec,Obj,Gen)
            if nargin > 0
                Arch(1,size(Obj,1)) = Arch;
                for i = 1 : size(Obj,1)
                    Arch(i).dec  = Dec(i,:);
                    Arch(i).obj  = Obj(i,:);
                    Arch(i).gen  = Gen;
                    Arch(i).vno  = 0;
                end
            end
        end
        function value = decs(Arch)
            value = cat(1,Arch.dec);
        end
        function value = objs(Arch)
            value = cat(1,Arch.obj);
        end
        function value = gens(Arch)
            value = cat(1,Arch.gen);
        end
        function value = vnos(Arch)
            value = cat(1,Arch.vno);
        end
    end
end