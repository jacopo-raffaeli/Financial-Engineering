function [M,stdEstim]=PlotErrorMC(F0,K,B,T,sigma)
% Plots the Montecarlo error comparing it with 1/sqrt(M)
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility 

flag = 1;
m = 1:20;
M = 2.^m;
stdEstim = zeros(1,length(M));
for i=1:length(M)
    [~,std_dev] = EuropeanOptionMC(F0,K,B,T,sigma,M(i),flag);
    stdEstim(i) = std_dev;
end
figure();
loglog(M,stdEstim,'--',M,1./sqrt(M),'LineWidth',2);
title('MonteCarlo error trend');
legend("Error","1/sqrt(M)");

end

