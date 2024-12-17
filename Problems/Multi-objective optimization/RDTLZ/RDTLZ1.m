classdef RDTLZ1 < PROBLEM
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
            if isempty(obj.M); obj.M = 3; end
            if isempty(obj.D); obj.D = obj.M+4; end
            obj.lower    = zeros(1,obj.D);
            obj.upper    = ones(1,obj.D);
            obj.encoding = ones(1,obj.D);
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            g      = 100*(obj.D-obj.M+1+sum((PopDec(:,obj.M:end)-0.5).^2-cos(20.*pi.*(PopDec(:,obj.M:end)-0.5)),2));
            PopObj = 0.5*repmat(1+g,1,obj.M).*fliplr(cumprod([ones(size(PopDec,1),1),PopDec(:,1:obj.M-1)],2)).*[ones(size(PopDec,1),1),1-PopDec(:,obj.M-1:-1:1)];
        end
        %% Generate points on the Pareto front
        function R = GetOptimum(obj,N)
            R = UniformPoint(N,obj.M)/2;
        end
        %% Generate the image of Pareto front
        function R = GetPF(obj)
            if obj.M == 2
                R = obj.GetOptimum(100);
            elseif obj.M == 3
                a = linspace(0,1,10)';
                R = {a*a'/2,a*(1-a')/2,(1-a)*ones(size(a'))/2};
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