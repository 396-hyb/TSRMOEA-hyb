function [ds,fn]=Nonrobust_optimization(M,n,N,mu,mum,r_c,r_p,num,pool,tour,func)
%ds: population of solution
%fn: population of solution after environmental selection
   %% Parameter setting
   %Evolution operator parameter setting
    %mu=0;mum=20;             %distribution index of SBX,  distribution index of polynomial mutation
    %r_c=1;r_p=1/n;           %rate of SBX, rate of polynomial mutation
    %num=3000;                   %num: the number of generations
    %pool = 2;tour = 2;       %parameter in tournament_selection
    %% Initialization
    fn=initialize_variables(N,n,func);       % Initialize all individuals
    fn(:,M+n+1)=1:N;                    % Assign a number to each individual
    ds=fn;                              % Store all visited solutions 
    fn=non_domination_sort_mod(fn,M,n); % Do non_dominated sorting
    %% Evolution Loop
    for ii=1:num    
        cc1=[];
        % 对于每一代（从第1代到第num代）：初始化一个空矩阵cc1，用于存储这一代产生的后代。
        for i=1:(N/2)
            p=tournament_selection(fn(:,1:M+n+3), pool, tour); % Select solution as parent
            %Combiantion
            %offspring_chromosome = genetic_operator(p(:,1:M+n),mu,mum,n);
            offspring_chromosome = genetic_operator(p(:,1:M+n),mu,mum,r_c,r_p,n,func); %Generate the child
            cc1=[cc1;offspring_chromosome(:,1:M+n)];
        end
        
        %Number the new solutions and put them into ds
        [ss2,ss3]=size(ds); %Record the size of original solutions
        [st1,st2]=size(cc1);%Record the size of the generated solutions
        cc1(1:st1,M+n+1)=(ss2+1):(ss2+st1);%Assign a number to each individual
        ds=[ds;cc1];%Record all solutions'locations in the decision space
        % 更新解的历史记录ds：
            % 计算ds的大小，记录原始解的数量。
            % 计算cc1的大小，即新生成后代的数量。
            % 给新生成的每一个后代分配一个编号，从ds中最后一个个体的编号加1开始。
            % 将cc1添加到ds中，记录所有解在决策空间中的位置。
            % size 函数用于获取矩阵的尺寸。它会返回两个元素,分别代表矩阵的行数和列数。
        
        cc=[fn(:,1:M+n+1);cc1]; %Combine both old population and new population
        intermediate_chromosome=non_domination_sort_mod(cc, M, n);%Do non_dominated sorting
        fn=replace_chromosome(intermediate_chromosome, M, n, N);  %Select solutions to form new population
        figure (1), plot(fn(:,n+1),fn(:,n+2),'o'); %Show the image
        ii
    end    
    