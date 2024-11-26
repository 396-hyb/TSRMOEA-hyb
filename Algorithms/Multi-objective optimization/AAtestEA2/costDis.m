function flag = costDis(ArchV, ArchGEN, h)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin

% 受PREA启发
    PopObj = [];
    for i = 1 : ArchGEN
        PopObj = [PopObj;Arch{i,h}.obj];
    end

    for i = 1 : ArchGEN
        obj            = PopObj(i,:);
        Ir             = PopObj./repmat(obj,ArchGEN,1) - 1;  
        InvertIr       = repmat(obj,ArchGEN,1)./PopObj - 1;
        MaxIr          = max(Ir,[],2);
        MinIr          = max(InvertIr,[],2);
        DomInds        = find(MaxIr<=0);
        MaxIr(DomInds) = -MinIr(DomInds);
        IMatrix(i,:)   = MaxIr';
        IMatrix(i,i)   = Inf;
    end


    Pobjs = arch.objs;
    Pobjs(Pobjs == 0) = 1e-6;
    % conv  = zeros(1, 100);
    len = length(arch);
    Rcon = zeros(len,Problem.M);
    for i = 1 : len
        PopX         = Problem.Perturb(arch(i).decs); % PopX为50行2列矩阵
        PopObjV(i,:) = max(PopX.objs); 
        % PopObjV(i,:)   = mean(PopX.objs,1);    
        % RCon(i,:)    = abs(PopObjV(i,:) - Pobjs(i,:))./Pobjs(i,:);
        Rcon(i,:)    = abs(PopObjV(i,:) - Pobjs(i,:))./Pobjs(i,:);
    end
    flag   = mean(Rcon,2);    
    % flag   = RCon;    
end