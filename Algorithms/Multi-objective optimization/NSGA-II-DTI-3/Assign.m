function [resAr,remainAr,flagW] = Assign(arch,W,flagW)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin
    Popobj = arch.objs;
    L      = max(Popobj)-min(Popobj);
    objs   = (Popobj-min(Popobj))./L ;
    [~,n]  = size(arch);
    [N ,~] = size(W);

    resAr = [];
    remainAr = [];
    flagT = flagW;
    for x = 1 : n
        obj = objs(x,:);
        for y = 1 : N
            s = sum(W(y,:).*obj,2);
            m = sqrt(sum(W(y,:).*W(y,:),2)*sum(obj.*obj,2));
            dang(1,y) = acos(s/m);
            [~,h]     = sort(dang);
        end
        arch(x).vno = h(1);
        if flagW(h(1)) == 0 
            if flagT(h(1)) == 1
                for i = 1 : size(resAr)
                    if resAr(i).vno == h(1)
                        if max(abs(resAr(i).objs-Z).*W(P,:),[],2) > max(abs(arch(x).objs-Z).*W(P,:),[],2)
                            if isempty(remainAr)
                                remainAr = resAr(i);
                            else
                                remainAr = [remainAr, resAr(i)];
                            end
                            resAr(i) = arch(x);
                        else
                            if isempty(remainAr)
                                remainAr = arch(x);
                            else
                                remainAr = [remainAr, arch(x)];
                            end
                        end
                        break;
                    end
                end
            else
                flagT(h(1)) = 1;
                if isempty(resAr)
                    resAr = arch(x);
                else
                    resAr = [resAr, arch(x)];
                end
            end
        end
    end
    flagW = flagT;
end