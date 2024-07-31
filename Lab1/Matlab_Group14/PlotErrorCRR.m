function [M,errCRR]=PlotErrorCRR(F0,K,B,T,sigma)
% Plots the CRR error comparing it with 1/M
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility 

flag = 1;
m = 1:10;
M = 2.^m;
errCRR = zeros(1,length(M));
Blk_price = EuropeanOptionClosed(F0,K,B,T,sigma,flag);
for i=1:length(M)
    optionPrice = EuropeanOptionCRR(F0,K,B,T,sigma,M(i),flag);
    errCRR(i) = abs(optionPrice - Blk_price);
end

figure();
loglog(M,errCRR,'--',M,1./M,'LineWidth',2);
title('CRR error trend');
legend("Error","1/M");
end

