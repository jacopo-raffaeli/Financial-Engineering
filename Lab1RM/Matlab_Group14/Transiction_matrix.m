function Q = Transiction_matrix(h_IG, h_HY)
% Derive the market-implied rating transition matrix based on the
% available market data (ZC risk-free curve and risky bond prices)

% INPUT 
%
% h_IG:         hazard rate for the corp. bond ranked IG and maturity 1yr
% h_HY:         hazard rate for the corp. bond ranked HY and maturity 1yr

% OUTPUT
%
% Q:            Transiction matrix

% The following is the system of equations obtained by the first 2 rows of the
% transiction matrix 0yr-1yr and the first 2 rows of the transiction matrix
% 0yr-2yr
F = @(x) [x(1) + x(2) + (1 - exp(-h_IG)) - 1;
          x(3) + x(4) + (1 - exp(-h_HY)) - 1;
          x(1)^2 + x(2)*x(3) + x(1)*x(2) + x(2)*x(4) + x(1)*(1 - exp(-h_IG)) + x(2)*(1 - exp(-h_HY)) + (1 - exp(-h_IG)) - 1;
         
          x(3)*x(1) + x(4)*x(3) + x(3)*x(2) + x(4)^2 + x(3)*(1 - exp(-h_HY)) + x(4)*(1 - exp(-h_HY)) + (1 - exp(-h_IG)) - 1];
% Initial data for the numerical solution (arbitrary)
x0 = 0.5*ones(4,1);
% Define lower & upper bound for the numerical function so that the
% function search the solution between 0 and 1
lb = zeros(4,1);
up = ones(4,1);
q = lsqnonlin(F,x0,lb,up);

Q = [q(1), q(2), (1-exp(-h_IG));
     q(4), q(3), (1-exp(-h_HY));
     0   , 0   ,  1            ];

end

