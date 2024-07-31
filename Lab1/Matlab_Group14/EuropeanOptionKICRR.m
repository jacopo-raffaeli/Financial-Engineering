function optionPrice=EuropeanOptionKICRR(F0,K,KI,B,T,sigma,N)
% Barrier option Price with CRR method
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% KI     barrier
% T:     time-to-maturity
% sigma: volatility
% N:     number of knots for CRR tree 
    
dt = T/N;
dx = sigma*sqrt(dt);
u = exp(dx);            %multiplier if the r.v goes 'up'
d = exp(-dx);           %multiplier if the r.v goes 'down'
q = (1-d)/(u-d);        %probability of the r.v going 'up'
F = zeros(N+1,1);       %underlying price vector
payoff = zeros(N+1,1);  %payoff vector
optionPrice = 0;

for i=0:N
    F(i+1) = F0*u^(i)*d^(N-i);
    if (F(i+1) >= KI)
        payoff(i+1) = max(F(i+1) - K , 0);
    else
        F(i+1) = 0;
    end
    optionPrice = nchoosek(N,i)*(q^i)*((1-q)^(N-i)*payoff(i+1)) + optionPrice;
    % Turn off the warning from nchoosek caused by the high number of steps N
    warning('off','all');
end
optionPrice = B*optionPrice;

end