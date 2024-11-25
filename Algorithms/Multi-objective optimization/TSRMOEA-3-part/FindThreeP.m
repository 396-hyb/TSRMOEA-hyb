function PopV3 = FindThreeP(v3All,flagV3,W,Z)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin

    PopV3  = [];
    objs   = v3All.objs;
    wr     = find(flagV3 == 1);
    [~,k]  = size(wr);
    [~,n]  = size(v3All);
    vi     = zeros(1,n);  %标记v3All中的解是否被选择
    for i = 1 : k
        y = wr(i);
        gTemp = Inf;
        viIndex = 1;
        isSelect = 0;   %第i个权重向量是否选择了解
        for x = 1 : n
            if vi(x) == 0  % 该解没有被选择
                obj = objs(x,:);
                g = max(abs(obj - Z).*W(y,:),[],2);
                if isSelect == 0
                    gTemp = g;
                    viIndex = x;
                    isSelect = 1;
                else
                    if abs( v3All(viIndex).vno - y ) > abs( v3All(x).vno - y )
                        % 优先选择邻居权重向量上关联的解
                        gTemp = g;
                        viIndex = x;
                    elseif abs( v3All(viIndex).vno - y ) == abs( v3All(x).vno - y )
                        if gTemp > g
                            gTemp = g;
                            viIndex = x;
                        end
                    end
                end
            end
        end
        vi(viIndex) = 1;  
        v3All(viIndex).vno = y;
        PopV3 = [PopV3, v3All(viIndex)];
    end
end