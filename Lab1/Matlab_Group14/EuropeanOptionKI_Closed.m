function optionPrice = EuropeanOptionKI_Closed(F0,K,KI,B,T,sigma)
% Barrier option Price with Closed formula
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% KI     barrier
% T:     time-to-maturity
% sigma: volatility

d1 = (log(F0/KI)+((sigma^2)/2)*T)/(sigma*sqrt(T));
d2 = d1-sigma*sqrt(T);
optionPrice = B*(F0*normcdf(d1)-K*normcdf(d2));

end

