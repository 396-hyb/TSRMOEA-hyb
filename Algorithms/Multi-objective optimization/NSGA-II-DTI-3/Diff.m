function Population3 = Diff(Population1,Population2)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin
% 去掉重复的解
    
    [~,n1] = size(Population1);  %新种群
    [~,n2] = size(Population2);  %父代种群
    for x = 1 : n1
        flag(x) = 0;
        for y = 1 : n2
            if(isequal(Population1(x).decs, Population2(y).decs))
                flag(x) = 1;
            end
        end
    end
    % disp(['flag=1_len:', num2str(length( find(flag == 1) ) )]); 
    Population3 = Population1(flag == 0);
    % Population3
    % [~,n3] = size(Population3);
    % disp(['Population3_len:', num2str(n3)]);  




   

end