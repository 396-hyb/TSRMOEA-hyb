function [Population] = Final(Problem,Arch,N,W,gen)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    if length(Arch) <= N
        Population = Problem.Evaluation(Arch.decs);
    else
        visitArch = [];
        remainArch = [];
        resArch    = [];
        index = gen;

        flagW = zeros(1,N);
       
        while  length(find(flagW == 0)) > 0 && index >= gen/2
            % 去掉非鲁棒解
            arch = Remain(Problem,Arch(index,:));

            % 去掉重复解
            if isempty(visitArch)
                visitArch = arch;
            else
                Tdec   = arch.decs;
                AllDec = visitArch.decs;
                m      = size(Tdec,1);
                n      = size(AllDec,1);
                flag   = ones(m,1);
                for i = 1 : m   
                    for j = 1 : n
                        if all(Tdec(i,:)==AllDec(j,:))
                            flag(i,1) = 0;
                            break;
                        end
                    end
                end
                arch = arch(flag==1);
                visitArch = [visitArch,arch];
            end

            [resAr,remainAr,flagW] = Assign(arch,W,flagW);
            if isempty(resArch)
                resArch = resAr;
            else
                resArch = [resArch, resAr];
            end
            if isempty(remainArch)
                remainArch = remainAr;
            else
                remainArch = [remainArch, remainAr];
            end
            index = index - 1;
        end
        Population = Problem.Evaluation(resArch.decs);
    end
end


