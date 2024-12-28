classdef TP10 < PROBLEM
% <multi> <real> <large/none> <robust>
% Test problem for robust multi-objective optimization
% delta --- 0.05 --- Maximum disturbance degree
% H     ---   50 --- Number of disturbances

%------------------------------- Reference --------------------------------
% A. Gaspar-Cunha, J. Ferreira, and G. Recio, Evolutionary robustness
% analysis for multi-objective optimization: benchmark problems, Structural
% and Multidisciplinary Optimization, 2014, 49: 771-793.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    properties
        delta;      % Maximum disturbance degree
        H;          % Number of disturbances
    end
    methods
        %% Default settings of the problem
        function Setting(obj)
            [obj.delta,obj.H] = obj.ParameterSet(0.05,50);
            obj.M = 3;
            obj.D = 5;
            obj.lower    = [0,0,1];
            obj.upper    = [10,10,3];
            obj.encoding = ones(1,obj.D);
        end
        %% Calculate objective values
        function PopObj = CalObj(~,PopDec)
            PopObj(:,1) = 1640.2823 + PopDec(:,1).*2.3573285 + PopDec(:,2).*2.3220035 + PopDec(:,3).*4.5688768 + PopDec(:,4).*7.7213633 + PopDec(:,5).*4.4559504;
            PopObj(:,2) = 6.5856 + PopDec(:,1).*1.15 - PopDec(:,2).*1.0427 + PopDec(:,3).*0.9738 + PopDec(:,4).*0.8364 - PopDec(:,1).*PopDec(:,4).*0.3695 + ...
                PopDec(:,1).*PopDec(:,5).*0.0861 + PopDec(:,2).*PopDec(:,4).*0.3628 - (PopDec(:,1).^2).*0.1106 - (PopDec(:,3).^2).*0.3437 + (PopDec(:,4).^2).*0.1764;
            PopObj(:,3) = -0.0551 + PopDec(:,1).*0.0181 + PopDec(:,2).*0.1024 + PopDec(:,3).*0.0421 -  PopDec(:,1).*PopDec(:,2).*0.0073 + PopDec(:,2).*PopDec(:,3).*0.024 - ...
                PopDec(:,2).*PopDec(:,4).*0.0118 - PopDec(:,3).*PopDec(:,4).*0204 - PopDec(:,3).*PopDec(:,5).*0.008 - (PopDec(:,2).^2).*0.0241 + (PopDec(:,4).^2).*0.0109                     
        end
        %% Generate points on the Pareto front
        function R = GetOptimum(obj,N)
            R = [100,100];
        end
        %% Calculate the metric value
        function score = CalMetric(obj,metName,Population)
            switch metName
                case {'Mean_IGD','Mean_HV','Worst_IGD','Worst_HV','IGDRM2','IGDRW2','IGDRM1','IGDRW1','RobustFE','RobustRatio','HVRM1'}
                    score = feval(metName,Population,obj);
                otherwise
                    score = feval(metName,Population,obj.optimum);
            end
        end
        %% Perturb solutions multiple times
        function PopX = Perturb(obj,PopDec,N)
            if nargin < 3; N = obj.H; end
            Delta = repmat(obj.delta.*(obj.upper-obj.lower),N*size(PopDec,1),1);
            w     = UniformPoint(N,obj.D,'Latin');
            Dec   = 2*Delta.*w(reshape(repmat(1:end,size(PopDec,1),1),1,[]),:) + repmat(PopDec,N,1) - Delta;
            Dec   = obj.CalDec(Dec);
            PopX  = SOLUTION(Dec,obj.CalObj(Dec),obj.CalCon(Dec));
        end
    end
end