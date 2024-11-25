function PopV3 = FindThree(rRelateV,flagV3,W,Z)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin

    Pop  = [];
    objs   = rRelateV.objs;
    wr     = find(flagV3 == 1);
    [~,k]  = size(wr);
    [~,n]  = size(rRelateV);
    for i = 1 : k
        y = wr(i);
        gTemp = 0;
        viIndex = 0;
        for x = 1 : n
            obj = objs(x,:);

            normW   = sqrt(sum(W(y,:).^2,2));
            normP   = sqrt(sum((obj-Z).^2,2));
            CosineP = sum((objs-Z).*W(y,:),2)./normW./normP;
            g       = normP.*CosineP + 5*normP.*sqrt(1-CosineP.^2);
            % g = max(abs(obj - Z).*W(y,:),[],2);
            if x == 1
                gTemp = g;
                viIndex = x;
            else
                if g < gTemp
                    gTemp = g;
                    viIndex = x;
                end
            end
        end
        pop = rRelateV(viIndex);
        Pop = [Pop, archive(pop.dec, pop.obj, 1)];
    end
    for i = 1 : k
        Pop(i).vno = wr(i);
    end 
    PopV3 = Pop;
end