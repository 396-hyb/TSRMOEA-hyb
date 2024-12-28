classdef RMOEA < ALGORITHM
% <multi> <real/integer> <robust>
% Robust multi-objective evolutionary algorithm with decision variable assortment

%------------------------------- Reference --------------------------------
% J. Liu, Y. Liu, Y. Jin, and F. Li, A decision variable assortment-based
% evolutionary algorithm for dominance robust multiobjective optimization,
% IEEE Transactions on Systems, Man, and Cybernetics: Systems, 2022, 52(5):
% 3360-3375.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        function main(Algorithm,Problem)

            %% Generate random population
            Population = Problem.Initialization();

            %% Optimization
            while Algorithm.NotTerminated(Population)
                p1 = Problem.M;
                p2 = Problem.D;
                p3 = Problem.N;
                p4 = Problem.delta;
                p5 = Problem.maxFE;
                p6 = class(Problem);
                f = RMOEA_main(p1,p2,p3,p4,p5,p6);
                % f = 1;
                % disp(num2str(f));
                disp(f);
                Problem.FE = Problem.maxFE;
            end
        end
    end
end