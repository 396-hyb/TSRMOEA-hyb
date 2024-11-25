function [resR,remainArR,flagR] = Assign(preRelatR,noRepeatR,v3All,W,flagW,Z)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin
    objs   = noRepeatR.objs ;

    [~,n]  = size(noRepeatR);
    [N ,~] = size(W);

    % resAr = [];
    remainAr = [];
    flagT = flagW;

    for x = 1 : n
        obj = objs(x,:);
        
        %找到与这个解角度最近的权重向量
        t = [];
        for y = 1 : N
            s = sum(W(y,:).*obj,2);
            m = sqrt(sum(W(y,:).*W(y,:),2)*sum(obj.*obj,2));
            t(1,y) = acos(s/m);
        end
        [~,h]     = min(t(1,:));
        noRepeatR(x).vno = h;
        
        % 如果这个权重向量有关联的鲁棒解，这个解作为要与第三类向量关联的候选解
        if flagT(h) == 1
            [~, n1] = size(preRelatR);
            for i = 1 : n1
                if preRelatR(i).vno == h

                    % PBI approach
                    normW   = sqrt(sum(W(h,:).^2,2));
                    normP   = sqrt(sum((preRelatR(i).objs-Z).^2,2));
                    normO   = sqrt(sum((noRepeatR(x).obj-Z).^2,2));
                    CosineP = sum((preRelatR(i).objs-Z).*W(h,:),2)./normW./normP;
                    CosineO = sum((noRepeatR(x).obj-Z).*W(h,:),2)./normW./normO;
                    g_old   = normP.*CosineP + 5*normP.*sqrt(1-CosineP.^2);
                    g_new   = normO.*CosineO + 5*normO.*sqrt(1-CosineO.^2);

                    % if max(abs(resAr(i).objs-Z).*W(h(1),:),[],2) > max(abs(arch(x).objs-Z).*W(h(1),:),[],2)
                    % if all(resAr(i).objs >= arch(x).objs)
                    if g_old >= g_new
                    % if norm(resAr(i).objs,2) > norm(arch(x).objs,2)
                        remainAr = [remainAr, preRelatR(i)];
                        preRelatR(i) = noRepeatR(x);
                        % disp(["swape: "]);
                    else
                        remainAr = [remainAr, noRepeatR(x)];
                    end
                    break;
                end
            end
        else
            flagT(h) = 1;
            preRelatR = [preRelatR, noRepeatR(x)];
        end
        
    end
    % disp(["resAr: ",num2str(size(resAr,2))]);
    flagR = flagT;
    resR = preRelatR;
    remainArR = remainAr;
end