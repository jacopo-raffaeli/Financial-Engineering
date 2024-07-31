function S=Blacksimulation(F0, ttm, vol,strikes,M,K)
% simulation of the Forward via Black  model

% INPUT:
% F0:       forward initial value
% ttm:      time to maturity (vector)
% vol:      volatility surface of the underlying (vector)
% strikes:  strikes of certificate
% M:        number of MC simulations
% K:        strike of underlying (vector)

% OUTPUT:
% S:        value of the forward at t1

g = randn(M,1);

%interpolation to find volatility
blk_vol = interp1(K, vol, strikes,'spline');

% Simulating Ft
f_t= -0.5*blk_vol^2*ttm(1) + blk_vol*sqrt(ttm(1))*g;
F1 = F0.*exp(f_t);
S = F1;

end