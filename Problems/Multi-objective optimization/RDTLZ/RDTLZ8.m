classdef RDTLZ8 < PROBLEM
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
            PopObj = zeros(size(PopDec,1),obj.M);
            for m = 1 : obj.M
                PopObj(:,m) = mean(PopDec(:,(m-1)*obj.D/obj.M+1:m*obj.D/obj.M),2);
            end
            PopCon = zeros(size(PopObj,1),obj.M);
            PopCon(:,1:obj.M-1) = 1 - repmat(PopObj(:,obj.M),1,obj.M-1) - 4*PopObj(:,1:obj.M-1);
            if obj.M == 2
                PopCon(:,obj.M) = 0;
            else
                minValue = sort(PopObj(:,1:obj.M-1),2);
                PopCon(:,obj.M) = 1 - 2*PopObj(:,obj.M) - sum(minValue(:,1:2),2);
            end
            Population = SOLUTION(PopDec,PopObj,PopCon,varargin{2:end});
            obj.FE     = obj.FE + length(Population);
        end
        %% Generate points on the Pareto front
        function R = GetOptimum(obj,N)
            if obj.M == 2
                temp = (0:1/(N-1):1)';
                R    = [(1-temp)/4,temp];
            else
                temp = UniformPoint(N/(obj.M-1),3);
                temp(:,3) = temp(:,3) / 2;
                temp = temp(temp(:,1)>=(1-temp(:,3))/4 & temp(:,1)<=temp(:,2) & temp(:,3)<=1/3,:);
                R    = [repmat(temp(:,2),obj.M-1,obj.M-1),repmat(temp(:,3),obj.M-1,1)];
                for i = 1 : obj.M-1
                    R((i-1)*size(temp,1)+1:i*size(temp,1),i) = temp(:,1);
                end
                gap  = sort(unique(R(:,obj.M)));
                gap  = gap(2) - gap(1);
                temp = (1/3:gap:1)';
                R    = [R;repmat((1-temp)/4,1,obj.M-1),temp];
                R    = unique(R,'rows');
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