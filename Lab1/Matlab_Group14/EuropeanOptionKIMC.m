function optionPrice = EuropeanOptionKIMC(F0,K,KI,B,T,sigma,N)
% Barrier option price with MonteCarlo method
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% KI:    barrier value
% T:     time-to-maturity
% sigma: volatility
% N:     number of simulations in MC   

% Generate random numbers for stock price simulation
g = randn(N, 1);
payoff = zeros(N,1);
% Calculate terminal stock prices
FT = F0 * exp((- 0.5 * sigma^2) * T + sigma * sqrt(T) * g);
for i=1:length(FT)
    if FT(i) >= KI
        payoff(i) = FT(i) - K; %  call option payoff
    else
        payoff(i)=0;
    end
end
optionPrice = B* mean(payoff); % Discounted expected payoff
end
