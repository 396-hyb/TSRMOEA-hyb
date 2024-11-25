function numZeros = Classification(Problem,Population)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin
    Pobjs        = Population.objs;
    conv         = zeros(1,Problem.N);
    for i = 1 : length(Population)
        PopX         = Problem.Perturb(Population(i).dec);
        PopObjV(i,:) = mean(PopX.objs,1);    
        RCon(i,:)    = abs(PopObjV(i,:) - Pobjs(i,:))./(PopObjV(i,:));
        % RCon(i,:)    = abs(PopObjV(i,:) - Pobjs(i,:));
        
        % for j = 1 : length(RCon(i))
        %     if RCon(i,j) >= 0.3
        %         conv(i) = 1;
        %     end
        % end

    end   
    flag = mean(RCon,2);    
    flag
    % disp(['-----------']);  
    % disp(['-----------']);  
    % RCon
    % PopObjV(:,2)

    numZeros = sum(flag <= 0.35);
    
    % disp(numZeros);
    % disp(['-----------']);  
    % PopX.objs
    % PopObjV(i,:) 
    % Pobjs(i,:)
    % RCon(i,:)
    % disp(['-----------']);  

end