classdef ZDT5delta004 < PROBLEM
% <multi> <real> <large/none> <robust>
% Benchmark MOP proposed by Zitzler, Deb, and Thiele
% Test problem for robust multi-objective optimization
% delta --- 0.04 --- Maximum disturbance degree
% H     ---   50 --- Number of disturbances

%------------------------------- Reference --------------------------------
% E. Zitzler, K. Deb, and L. Thiele, Comparison of multiobjective
% evolutionary algorithms: Empirical results, Evolutionary computation,
% 2000, 8(2): 173-195.
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
            obj.M = 2;
            if isempty(obj.D); obj.D = 80; end
            obj.D        = ceil(max(obj.D-30,1)/5)*5 + 30;
            obj.encoding = 4 + zeros(1,obj.D);
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            u      = zeros(size(PopDec,1),1+(size(PopDec,2)-30)/5);
            u(:,1) = sum(PopDec(:,1:30),2);
            for i = 2 : size(u,2)
                u(:,i) = sum(PopDec(:,(i-2)*5+31:(i-2)*5+35),2);
            end
            v           = zeros(size(u));
            v(u<5)      = 2 + u(u<5);
            v(u==5)     = 1;
            PopObj(:,1) = 1 + u(:,1);
            g           = sum(v(:,2:end),2);
            h           = 1./PopObj(:,1);
            PopObj(:,2) = g.*h;
        end
        %% Generate points on the Pareto front
        function R = GetOptimum(obj,N)
            R(:,1) = 1 : 31;
            R(:,2) = (obj.D-30)./5./R(:,1);
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