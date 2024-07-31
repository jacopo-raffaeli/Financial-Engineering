function [C, error,IC] = MC_price(N, kappa, F0, moneyness, delta_t, a, eta, dev_sigma, B_0_t)
% This function compute the price according to MC method

% INPUT
%
% N:            Number of simulation
% F0
% moneyness
% delta_t
% kappa:        Volatility of the volatility  
% delta_t
% a
% dev_sigma
% eta:          Simmetry
% B_0_t:        Discount 1 year
%
% OUTPUT
%
% C:            Price
% error:        Errore between the first four empirical and theoretical
%               moments of the IG
% IC:           Confidence Interval

rng("default")
g = randn(N,1);

% Compute IG(1,kappa) samples
u = rand(N,1);
z = chi2rnd(1,N,1);
IG = 1 - (kappa/2)*(sqrt((z.^2) + 4*z/kappa) - z);
index = find((1 + IG).*u > 1);
IG(index) = 1./IG(index);

% Check inverse gaussian samples correctness
empirical_moments = mean(IG.^(1:4))';
theoretical_moments = [1; 1/kappa; 3/sqrt(1/kappa); 15/(1/kappa)];
error = abs(empirical_moments - theoretical_moments);

% Strike price from moneyness
K = F0*exp(-moneyness);

logL = @(w) (delta_t/kappa)*((1-a)/a)*( 1 - (1 + w*kappa*(dev_sigma^2)/(1-a)).^a );

f_t = sqrt(delta_t)*dev_sigma*sqrt(IG).*g - (0.5 + eta)*delta_t*(dev_sigma^2).*IG - logL(eta);
F_t = F0*exp(f_t);

payoff = max(F_t - K, 0);
C = B_0_t*mean(payoff);

C_std = std(C)/sqrt(N);
IC_low = (C - norminv(1-0.05/2)*C_std)';
IC_up = (C + norminv(1-0.05/2)*C_std)';
IC = [IC_low IC_up];
end

