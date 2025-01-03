classdef TP11delta010 < PROBLEM
% <multi> <real> <large/none> <robust>
% Test problem for robust multi-objective optimization
% delta --- 0.1 --- Maximum disturbance degree
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
            if isempty(obj.M); obj.M = 3; end
            % obj.M = 3;
            obj.D = 5;
            obj.lower    = [1,1,1,1,1];
            obj.upper    = [3,3,3,3,3];
            obj.encoding = ones(1,obj.D);
        end
        %% Calculate objective values
        function PopObj = CalObj(~,PopDec)
            PopObj(:,1) = PopDec(:,1).*2.3573285 + PopDec(:,2).*2.3220035 + PopDec(:,3).*4.5688768 + PopDec(:,4).*7.7213633 + PopDec(:,5).*4.4559504;
            % PopObj(:,1) = 1640.2823 + PopDec(:,1).*2.3573285 + PopDec(:,2).*2.3220035 + PopDec(:,3).*4.5688768 + PopDec(:,4).*7.7213633 + PopDec(:,5).*4.4559504;
            PopObj(:,2) = 6.5856 + PopDec(:,1).*1.15 - PopDec(:,2).*1.0427 + PopDec(:,3).*0.9738 + PopDec(:,4).*0.8364 - PopDec(:,1).*PopDec(:,4).*0.3695 + ...
                PopDec(:,1).*PopDec(:,5).*0.0861 + PopDec(:,2).*PopDec(:,4).*0.3628 - (PopDec(:,1).^2).*0.1106 - (PopDec(:,3).^2).*0.3437 + (PopDec(:,4).^2).*0.1764;
            PopObj(:,3) = -0.0551 + PopDec(:,1).*0.0181 + PopDec(:,2).*0.1024 + PopDec(:,3).*0.0421 -  PopDec(:,1).*PopDec(:,2).*0.0073 + PopDec(:,2).*PopDec(:,3).*0.024 ...
                - PopDec(:,2).*PopDec(:,4).*0.0118 - PopDec(:,3).*PopDec(:,4).*0.0204 - PopDec(:,3).*PopDec(:,5).*0.008 - (PopDec(:,2).^2).*0.0241 + (PopDec(:,4).^2).*0.0109;  
            PopObj(:,1) = PopObj(:,1)./52;
            PopObj(:,2) = PopObj(:,2)./12;
            PopObj(:,3) = PopObj(:,3).*5;
        end
        %% Generate points on the Pareto front
        function R = GetOptimum(obj,N)
            R2 = [
                0.4677, 0.6214, 0.5351 ;
                0.4416, 0.6545, 0.4969 ;
                0.4261, 0.6742, 0.4351 ;
                0.4146, 0.6888, 0.3706 ;
                0.4239, 0.6989, 0.3499 ;
                0.4385, 0.6943, 0.3416 ;
                0.4462, 0.6949, 0.338 ;
                0.4871, 0.5968, 0.5101 ;
                0.475, 0.6418, 0.5136 ;
                0.4619, 0.6789, 0.4119 ;
                0.451, 0.6956, 0.3397 ;
                0.4612, 0.6962, 0.3311 ;
                0.4646, 0.6965, 0.3294 ;
                0.5104, 0.5795, 0.4588 ;
                0.543, 0.6441, 0.4582 ;
                0.5315, 0.6983, 0.3812 ;
                0.5043, 0.7086, 0.3132 ;
                0.4966, 0.6991, 0.3145 ;
                0.5766, 0.585, 0.4278 ;
                0.6005, 0.6415, 0.3876 ;
                0.589, 0.6968, 0.3208 ;
                0.554, 0.7039, 0.2877 ;
                0.6592, 0.592, 0.3893 ;
                0.7098, 0.6531, 0.3362 ;
                0.5834, 0.7064, 0.274 ;
                0.6939, 0.616, 0.3599 ;
                0.7448, 0.6738, 0.3133 ;
                0.7089, 0.6327, 0.3448 ;
            ];

            R1 = [
                0.6771, 0.5119, 1.32 ;
                0.412, 0.692, 0.354 ;
                0.995, 0.8802, 0.2124 ;
                0.995, 0.8802, 0.2124 ;
                0.9599, 0.8501, 0.2168 ;
                0.8869, 0.7897, 0.2412 ;
                0.5155, 0.5799, 0.4564 ;
                0.6771, 0.5119, 1.32 ;
                0.7778, 0.5782, 0.8239 ;
                0.6517, 0.5475, 1.1554 ;
                0.4666, 0.6228, 0.5352 ;
                0.9098, 0.8103, 0.2306 ;
                0.5917, 0.6462, 0.4244 ;
                0.6062, 0.6594, 0.3793 ;
                0.6895, 0.5336, 1.2608 ;
                0.847, 0.5261, 1.082 ;
                0.4286, 0.7032, 0.3489 ;
                0.551, 0.6311, 0.4271 ;
                0.9887, 0.8822, 0.215 ;
                0.6334, 0.7455, 0.2664 ;
                0.5774, 0.7059, 0.2768 ;
                0.6539, 0.5354, 1.217 ;
                0.6252, 0.7395, 0.2673 ;
                0.8008, 0.5688, 0.9034 ;
                0.9626, 0.8507, 0.2155 ;
                0.4674, 0.6254, 0.5336 ;
                0.7414, 0.6699, 0.316 ;
                0.847, 0.5261, 1.082 ;
                0.734, 0.6612, 0.3224 ;
                0.4666, 0.6228, 0.5352
            ];
            R = R2;
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