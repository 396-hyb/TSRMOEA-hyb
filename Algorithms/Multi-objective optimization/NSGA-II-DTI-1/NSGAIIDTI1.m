

classdef NSGAIIDTI1 < ALGORITHM
% <multi> <real/integer/label/binary/permutation> 
% NSGA-II of Deb's type I robust version

%------------------------------- Reference --------------------------------
% K. Deb and H. Gupta, Introducing robustness in multi-objective
% optimization, Evolutionary Computation, 2006, 14(4): 463-494.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

	methods
       function main(Algorithm,Problem)
            %% Generate random population
            % Population = Problem.Initialization();
            % [PopObjV,PopConV]    = MeanEffective(Problem,Population);
            % [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,Problem.N,PopObjV,PopConV);
            
            
      
                
                %ZDT1
                % PopDec1 = zeros(100, 30);  % 一次性创建一个 100x30 的零矩阵
                % PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
                % PopObj1(:,1) = PopDec1(:,1);
                % g = 1 + 9*mean(PopDec1(:,2:end),2);
                % h = 1 - (PopObj1(:,1)./g).^0.5;
                % PopObj1(:,2) = g.*h;
                % PopCon1 = zeros(size(PopDec1,1),1);
                % Population1 = SOLUTION(PopDec1,PopObj1,PopCon1);
                % numZeros_ZDT1 = Classification(Problem,Population1);
                % disp(['numZeros_ZDT1:', num2str(numZeros_ZDT1)]);  
                
                % TP1
                % PopDec1 = zeros(100, 10);  % 一次性创建一个 100x10 的零矩阵
                % PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
                % PopObj1(:,1) = PopDec1(:,1);
                % g = mean(PopDec1(:,2:end),2);
                % h = -((PopObj1(:,1)-0.6).^3-0.4^3)/(0.6^3+0.4^3);
                % s = 1./(PopDec1(:,1)+0.2);
                % PopObj1(:,2) = h + g.*s;
                % PopCon1 = zeros(size(PopDec1,1),1);
                % Population1 = SOLUTION(PopDec1,PopObj1,PopCon1);
                % numZeros_TP1 = Classification(Problem,Population1);
                % disp(['numZeros_TP1:', num2str(numZeros_TP1)]);  
                
                % TP2（D = 10）
                % PopDec1 = zeros(100, 10);  % 一次性创建一个 100x10 的零矩阵
                % PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
                % PopObj1(:,1) = cos(pi/2*PopDec1(:,1));
                % g = 1 + 10*mean(PopDec1(:,2:end),2);
                % PopObj1(:,2) = sin(pi/2*PopDec1(:,1)).*g;
                % PopCon1 = zeros(size(PopDec1,1),1);
                % Population1 = SOLUTION(PopDec1,PopObj1,PopCon1);
                % numZeros_TP2 = Classification(Problem,Population1);
                % disp(['numZeros_TP2:', num2str(numZeros_TP2)]);  
                
  
                % % TP3
                % PopDec1 = zeros(100, 30);  % 一次性创建一个 100x30 的零矩阵
                % PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
                % PopObj1(:,1) = PopDec1(:,1);
                % g = mean(PopDec1(:,2:end),2);
                % h = -((PopObj1(:,1)-0.6).^3-0.4^3)/(0.6^3+0.4^3);
                % s = 1./(PopDec1(:,1)+0.2);
                % PopObj1(:,2) = h + g.*s;

                % PopCon1 = zeros(size(PopDec1,1),1);
                % Population1 = SOLUTION(PopDec1,PopObj1,PopCon1);
                % numZeros_ZDT1 = Classification(Problem,Population1);
                % disp(['numZeros_ZDT1:', num2str(numZeros_ZDT1)]);  

                % % TP4
                % PopDec1 = zeros(100, 30);  % 一次性创建一个 100x30 的零矩阵
                % PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
                % PopObj1(:,1) = PopDec1(:,1);
                % g = mean(PopDec1(:,2:end),2);
                % h = -((PopObj1(:,1)-0.6).^3-0.4^3)/(0.6^3+0.4^3);
                % s = 1./(PopDec1(:,1)+0.2);
                % PopObj1(:,2) = h + g.*s;

                % PopCon1 = zeros(size(PopDec1,1),1);
                % Population1 = SOLUTION(PopDec1,PopObj1,PopCon1);
                % numZeros_ZDT1 = Classification(Problem,Population1);
                % disp(['numZeros_ZDT1:', num2str(numZeros_ZDT1)]);  


                % % TP5
                % PopDec1 = zeros(100, 30);  % 一次性创建一个 100x30 的零矩阵
                % PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
                % PopObj1(:,1) = PopDec1(:,1);
                % g = mean(PopDec1(:,2:end),2);
                % h = -((PopObj1(:,1)-0.6).^3-0.4^3)/(0.6^3+0.4^3);
                % s = 1./(PopDec1(:,1)+0.2);
                % PopObj1(:,2) = h + g.*s;

                % PopCon1 = zeros(size(PopDec1,1),1);
                % Population1 = SOLUTION(PopDec1,PopObj1,PopCon1);
                % numZeros_ZDT1 = Classification(Problem,Population1);
                % disp(['numZeros_ZDT1:', num2str(numZeros_ZDT1)]);  

                % % TP6 (D = 5)
                % PopDec1 = zeros(100, 5);  % 一次性创建一个 100x10 的零矩阵
                % PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
                % PopObj1(:,1) = PopDec1(:,1);
                % h = 1 - PopDec1(:,1).^2;
                % g = sum(10-10*cos(4*pi*(PopDec1(:,2:end)))+PopDec1(:,2:end).^2,2);
                % S = 1./(0.2+PopDec1(:,1)) + PopDec1(:,1).^2;
                % PopObj1(:,2) = h + g.*S;
                % PopCon1 = zeros(size(PopDec1,1),1);
                % Population1 = SOLUTION(PopDec1,PopObj1,PopCon1);
                % numZeros_TP6 = Classification(Problem,Population1);
                % disp(['numZeros_TP6:', num2str(numZeros_TP6)]);  

                % % TP7
                PopDec1 = zeros(100, 5);  % 一次性创建一个 100x30 的零矩阵
                PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
                PopObj1(:,1) = PopDec1(:,1);
                h = 1 - PopDec1(:,1).^2;
                g = sum(10-10*cos(4*pi*(PopDec1(:,2:end)))+PopDec1(:,2:end).^2,2);
                S = 1./(0.2+PopDec1(:,1)) + 50*PopDec1(:,1).^2;
                PopObj1(:,2) = h + g.*S;
                PopCon1 = zeros(size(PopDec1,1),1);
                Population1 = SOLUTION(PopDec1,PopObj1,PopCon1);
                numZeros_TP7 = Classification(Problem,Population1);
                disp(['numZeros_TP7:', num2str(numZeros_TP7)]);  

                % % TP8(global x2=0.85)
                % PopDec1 = zeros(100, 5);  % 一次性创建一个 100x30 的零矩阵
                % PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
                % PopDec1(:,2) = repmat(0.85, 100, 1);
                % PopObj1(:,1) = PopDec1(:,1);
                % h = 2 - 0.8*exp(-((PopDec1(:,2)-0.35)/0.25).^2) - exp(-((PopDec1(:,2)-0.85)/0.03).^2);
                % g = 50*sum(PopDec1(:,3:end).^2,2);
                % S = 1 - sqrt(PopObj1(:,1));
                % PopObj1(:,2) = h.*(g+S);
                % PopCon1 = zeros(size(PopDec1,1),1);
                % Population1 = SOLUTION(PopDec1,PopObj1,PopCon1);
                % numZeros_TP8_global = Classification(Problem,Population1);
                % disp(['numZeros_TP8_global:', num2str(numZeros_TP8_global)]);  
                
                % TP8(local x2=0.35)
                % PopDec1 = zeros(100, 5);  % 一次性创建一个 100x30 的零矩阵
                % PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
                % PopDec1(:,2) = repmat(0.35, 100, 1);
                % PopObj1(:,1) = PopDec1(:,1);
                % h = 2 - 0.8*exp(-((PopDec1(:,2)-0.35)/0.25).^2) - exp(-((PopDec1(:,2)-0.85)/0.03).^2);
                % g = 50*sum(PopDec1(:,3:end).^2,2);
                % S = 1 - sqrt(PopObj1(:,1));
                % PopObj1(:,2) = h.*(g+S);
                % PopCon1 = zeros(size(PopDec1,1),1);
                % Population1 = SOLUTION(PopDec1,PopObj1,PopCon1);
                % numZeros_TP8_local = Classification(Problem,Population1);
                % disp(['numZeros_TP8_local:', num2str(numZeros_TP8_local)]);  

                % % TP9
                % PopDec1 = zeros(100, 30);  % 一次性创建一个 100x30 的零矩阵
                % PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
                % PopObj1(:,1) = PopDec1(:,1);
                % g = mean(PopDec1(:,2:end),2);
                % h = -((PopObj1(:,1)-0.6).^3-0.4^3)/(0.6^3+0.4^3);
                % s = 1./(PopDec1(:,1)+0.2);
                % PopObj1(:,2) = h + g.*s;

                % PopCon1 = zeros(size(PopDec1,1),1);
                % Population1 = SOLUTION(PopDec1,PopObj1,PopCon1);
                % numZeros_ZDT1 = Classification(Problem,Population1);
                % disp(['numZeros_ZDT1:', num2str(numZeros_ZDT1)]);  


                % TP1
                % PopDec1 = zeros(100, 30);  % 一次性创建一个 100x30 的零矩阵
                % PopDec1(:,1) = linspace(0,1,100)';%创建一个从 0 到 1 线性间隔的列向量,末尾的单引号 (') 是转置操作，将行向量转换成列向量.
                % PopObj1(:,1) = PopDec1(:,1);
                % g = mean(PopDec1(:,2:end),2);
                % h = -((PopObj1(:,1)-0.6).^3-0.4^3)/(0.6^3+0.4^3);
                % s = 1./(PopDec1(:,1)+0.2);
                % PopObj1(:,2) = h + g.*s;

                % PopCon1 = zeros(size(PopDec1,1),1);
                % Population1 = SOLUTION(PopDec1,PopObj1,PopCon1);
                % numZeros_ZDT1 = Classification(Problem,Population1);
                % disp(['numZeros_ZDT1:', num2str(numZeros_ZDT1)]);  


                % [OffObjV,OffConV] = MeanEffective(Problem,Population);
                % [Population,FrontNo,CrowdDis,PopObjV,PopConV] = EnvironmentalSelection([Population,Offspring],Problem.N,[PopObjV;OffObjV],[PopConV;OffConV]);
            %% Optimization
            while Algorithm.NotTerminated(Population1)
                [PopObjV,PopConV]    = MeanEffective(Problem,Population1);
                [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population1,Problem.N,PopObjV,PopConV);
                MatingPool = TournamentSelection(2,Problem.N,FrontNo,-CrowdDis);
                Offspring  = OperatorGA(Problem,Population1(MatingPool));
                [OffObjV,OffConV] = MeanEffective(Problem,Population1);
                [Population,FrontNo,CrowdDis,PopObjV,PopConV] = EnvironmentalSelection([Population1,Offspring],Problem.N,[PopObjV;OffObjV],[PopConV;OffConV]);
            end
        end
    end
end