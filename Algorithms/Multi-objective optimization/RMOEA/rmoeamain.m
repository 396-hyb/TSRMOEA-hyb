function [res,RFE] = rmoeamain(p1,p2,p3,p4,p5,p6)
    % function f = RMOEA_main(Problem)
    %% Parameter setting
    M = p1;      % NO.Objectives
    n = p2;      % NO.Decision variables
    N = p3;    % The size of initial population
    phi = p4;  % Disturbance level
    mu = 0;     % Distribution index of SBX  
    mum = 20;   % Distribution index of polynomial mutation
    r_c = 1;    % Rate of SBX
    r_p = 1/n;  % Rate of polynomial mutation
    num = p5 / N; % The number of generations
    pool = 2;   % Parameter in tournament_selection
    tour = 2;   % Parameter in tournament_selection
    Tnon = 1000;% Number of sampled solutions
    theta = 5;  % theta used in PBI
    T = 10;     % Neighborhood size
    TN = 50;    % Sampling size in robust detection
    % func = @p6; % Benchmark
    func = str2func(p6); % 将字符串转换为函数句柄
    %Notify: The benchmark problems should be written in a separate document.
    %The example of benchmark problems is given in TP1.m, TP2.m, TP3.m, and TP4.m

    %% Step 1:Non-robust Optimization
    [ds,fn]=Nonrobust_optimization(M,n,N,mu,mum,r_c,r_p,num,pool,tour,func); %optimization using NSGA-II
    w=generate_vectors(99,M); %weight vectors setting
    lf=archive_updating(w,ds,n); %Organize solutions in objective space
    g0=Organize_solutions(ds,n,phi); %Organize solutions in decision space

    %% Step 2:Find Robust Region for Each Vector 
    [w_limit,m_limit,fn1,lf1]=non_robust_front2(lf,n,M,phi,w,Tnon,theta,func);%Sampling and performance evaluation under disturbance
    llf=sort_archive(lf1,w_limit);
    lff=update_archive(llf,n,g0);%Update solution in archive of each vector
    nei=Neighborhood_setting(w,T); %neighborhood setting
    [w_re,wc,rFE] = Search_robust(w,n,lff,g0,phi,ds,m_limit,w_limit,nei,TN,theta,func); %Robust region detection
    w_re=final_update(w_re,n,phi);%Update solution in archive of each vector

    %% Step 3:Determine Robust Optimal Solution
    f=Robust_solution1(w,nei,w_re,n,lf,w_limit,wc,fn1,T);%Determine Robust Optimal Solution
    
    RFE = p5 + Tnon*N + rFE;

    res = f;
end


