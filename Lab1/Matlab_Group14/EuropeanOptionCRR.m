function optionPrice = EuropeanOptionCRR(F0,K,B,T,sigma,N,flag)
% Option price with the Cox-Ross-Rubinstein pricing method under Black model
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% N:     number of time steps (knots of CRR tree)    
% flag:  1 call, -1 put

dt = T/N;         
dx = sigma*sqrt(dt);
u = exp(dx);       %multiplier if the r.v. goes 'up'
d = exp(-dx);      %multiplier if the r.v. goes 'down'
q = (1-d)/(u-d);   %probability of the r.v. going 'up'
F = zeros(N+1,1);  %payoff vectors
optionPrice = 0;

for i=0:N
    F(i+1) = max(F0*u^(i)*d^(N-i) - K , 0);
    optionPrice = nchoosek(N,i)*(q^i)*((1-q)^(N-i)*F(i+1)) + optionPrice;
    % Turn off the warning from nchoosek caused by the high number of steps N
    warning('off','all');
end
optionPrice = B*optionPrice; %discounted option price

end