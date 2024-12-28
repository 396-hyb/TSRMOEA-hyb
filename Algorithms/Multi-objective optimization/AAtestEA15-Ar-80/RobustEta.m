function flag = RobustEta(Problem,arch)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin
    Pobjs = arch.objs;
    Pobjs(Pobjs == 0) = 1e-6;
    % conv  = zeros(1, 100);
    len = length(arch);
    Rcon = zeros(len,Problem.M);
    for i = 1 : len
        PopX         = Problem.Perturb(arch(i).dec); % PopX为50行2列矩阵
        % PopObjV(i,:) = max(PopX.objs); 
        Z = max(Pobjs(i,:),[],1);
        PopObjV(i,:)   = mean(PopX.objs,1);    
        Z = max(Z, PopObjV(i,:));
        % RCon(i,:)    = abs(PopObjV(i,:) - Pobjs(i,:))./Pobjs(i,:);
        Rcon(i,:)    = abs(PopObjV(i,:) - Pobjs(i,:))./Z;
    end
    flag   = mean(Rcon,2);    
    % flag   = RCon;    
end