function flag = Classification(Problem,Population)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin
    
    [FrontNo,MaxFNo]   = NDSort(Population.objs,Problem.N);
    x1                 = find(FrontNo==1);
    % find(FrontNo==1) 返回所有前沿编号为 1 的解的索引，即属于第一个前沿的解。
  
    Pobjs        = Population.objs;
    conv         = zeros(1,Problem.N);
    for i = 1 : length(Population)
        PopX         = Problem.Perturb(Population(i).dec);
        PopObjV(i,:) = max(PopX.objs);    
        RCon(i,:)    = abs(PopObjV(i,:) - Pobjs(i,:))./(PopObjV(i,:));
        % RCon(i,:)    = abs(PopObjV(i,:) - Pobjs(i,:))./(Pobjs(i,:));
        % RCon(i,:)    = abs(PopObjV(i,:) - Pobjs(i,:));

        % conv(i) = 1;
        % for j = 1 : length(RCon(i,:))
        %     if RCon(i,j) >= 0.6
        %         conv(i) = 0;
        %     end
        % end

    end   
    flag = mean(RCon,2);   
    % disp(flag); 
    % disp("*********");
     % len1 = length(find(conv(x1) == 1));
    len1 = length(find(flag(x1) <= 0.6));  %TP1-5: 0.05(mean) 0.2(max)
    len2 = length(x1);
    flag = len1 / len2;  

end