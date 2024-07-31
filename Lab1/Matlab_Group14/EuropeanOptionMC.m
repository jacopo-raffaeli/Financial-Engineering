function [call_price,std_dev] = EuropeanOptionMC(F0,K,B,T,sigma,N,flag)
% Option Price with MonteCarlo pricing method
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% N:     number of simulations in MC   
% flag:  1 call, -1 put

% Generate random numbers for stock price simulation
g = randn(N, 1);

% Calculate terminal stock prices
FT = F0 * exp((- 0.5 * sigma^2) * T + sigma * sqrt(T) * g);
payoff = max(FT - K, 0); %  call option payoff
call_price = B* mean(payoff); % Discounted expected payoff
var = (1/(N*(N-1)))*(sum((payoff-call_price).^2)); % Standard error estimation
std_dev = sqrt(var);

end
