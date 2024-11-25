function [rRelateV,resV3,flagG1R,flagN0R] = VeClassify(Problem,flagG1R,flagN0R,noRepeat,eta,W,Z)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin 
    rRelateV = [];
    resV3 = [];
    relat = Assign(flagG1R,noRepeat,W,Z); % 得到与对应向量关联的解
    % disp(num2str(size(relat,2)));
    if ~isempty(relat)
        [relatR, relatNR] = Remain(Problem,relat,eta); % 去掉不满足鲁棒阈值的解
        if ~isempty(relatR)
            [~,n]  = size(relatR);
            for i = 1 : n
                h = relatR(i).vno;
                if flagN0R(h) == 0  %该向量没有鲁棒解
                    flagN0R(h) = 1;
                    rRelateV = [rRelateV, relatR(i)];
                else %该向量关联1个鲁棒解
                    flagG1R(h) = 1;
                    resV3 = [resV3, relatR(i)];
                end
            end
        end
    end
end