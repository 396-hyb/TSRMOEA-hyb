classdef RDTLZ9 < PROBLEM
% <multi> <real> <large/none> <robust>
% Test problem for robust multi-objective optimization
% delta --- 0.03 --- Maximum disturbance degree
% H     ---   50 --- Number of disturbances
% Benchmark MOP proposed by Deb, Thiele, Laumanns, and Zitzler

%------------------------------- Reference --------------------------------
% K. Deb, L. Thiele, M. Laumanns, and E. Zitzler, Scalable test problems
% for evolutionary multiobjective optimization, Evolutionary multiobjective
% Optimization. Theoretical Advances and Applications, 2005, 105-145.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
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
            [obj.delta,obj.H] = obj.ParameterSet(0.03,50);
            if isempty(obj.M); obj.M = 2; end
            if isempty(obj.D); obj.D = 10*obj.M; end
            obj.D        = ceil(obj.D/obj.M)*obj.M;
            obj.lower    = zeros(1,obj.D);
            obj.upper    = ones(1,obj.D);
            obj.encoding = ones(1,obj.D);
        end
        %% Calculate objective values and constraint violations
        function Population = Evaluation(obj,varargin)
            PopDec = varargin{1};
            PopDec = max(min(PopDec,repmat(obj.upper,size(PopDec,1),1)),repmat(obj.lower,size(PopDec,1),1));
            X      = PopDec;
            PopDec = PopDec.^0.1;
            PopObj = zeros(size(PopDec,1),obj.M);
            for m = 1 : obj.M
                PopObj(:,m) = sum(PopDec(:,(m-1)*obj.D/obj.M+1:m*obj.D/obj.M),2);
            end
            PopCon = 1 - repmat(PopObj(:,obj.M).^2,1,obj.M-1) - PopObj(:,1:obj.M-1).^2;
            Population = SOLUTION(X,PopObj,PopCon,varargin{2:end});
            obj.FE     = obj.FE + length(Population);
        end
        %% Generate points on the Pareto front
        function R = GetOptimum(obj,N)
            Temp = (0:1/(N-1):1)';
            R    = [repmat(cos(0.5.*pi.*Temp),1,obj.M-1),sin(0.5.*pi.*Temp)];
        end
        %% Generate the image of Pareto front
        function R = GetPF(obj)
            if obj.M < 4
                R = obj.GetOptimum(100);
            else
                R = [];
            end
        end
        %% Calculate the metric value
        function score = CalMetric(obj,metName,Population)
            switch metName
                % case {'Mean_IGD','Mean_HV','Worst_IGD','Worst_HV','IGDR'}
                case {'Mean_IGD','Mean_HV','Worst_IGD','Worst_HV','IGDRM2','IGDRW2','IGDRM1','IGDRW1','RobustFE','RobustRatio'}
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