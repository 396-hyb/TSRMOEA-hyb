function flag = Classification(Problem,Population1,Population2,PopObjV2,beita)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by He YiBin
    obj1               = MeanEffective(Problem,Population1);
    obj2               = PopObjV2;
    [FrontNo1,MaxFNo] = NDSort(Population1.objs,inf);
    [FrontNo2,MaxFNo] = NDSort(obj2,inf);
    x1                 = find(FrontNo1==1);
    x2                 = find(FrontNo2==1);
    % find(FrontNo==1) 返回所有前沿编号为 1 的解的索引，即属于第一个前沿的解。
  
    obj1 = obj1(x1,:);
    obj2 = obj2(x2,:);
    [FrontNo,MaxFNo] = NDSort([obj1;obj2],inf); 
    % 这段代码对前两个种群中属于第一个前沿的解进行了筛选，然后将这些解合并为一个新的种群，并对该新种群进行了非支配排序。

           
    %  ll indicates the ratio that pop1(x1) belong to the first level in the combination of pop1(x1) and pop2(x2)
    disp(['pop1:', num2str(length( ( find( FrontNo(1:length(x1))==1 ) ) ) )]);  
    disp(['pop1:', num2str(length( FrontNo(1:length(x1)) ))]); 
    disp(['pop2:', num2str(length( ( find( FrontNo(length(x1)+1:length(x1)+length(x2))==1 ) ) ) )]);  
    disp(['pop2:', num2str(length( FrontNo(length(x1)+1:length(x1)+length(x2)) ))]);  
    % ll = length( ( find( FrontNo(1:length(x1))==1 ) ) ) / length( FrontNo(1:length(x1)) );   
    ll = length( ( find( FrontNo(1:length(x1))==1 ) ) )  / length( FrontNo(1:length(x1)) );   
    disp(['ll:', num2str(ll)]);  

    if ll > beita
        flag = 1;
    elseif ll < 1 - beita
        flag = 3;
    else
        flag = 2;
    end

end