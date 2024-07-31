function D_i_i1 = stochastic_discounts(dates, discounts, a, sigma, dt, mu_hat, sigma_hat)
% Compute the stochastic discounts for all the nodes of the forward tree
% exploiting the approxiamted relation given in Lemma 2
%
% INPUT:
% dates
% discounts
% a: HW model parameter
% sigma_ HW model parameter
% dt: Time step of the tree's grid
% mu_hat
% sigma_hat
%

% Compute all the tree dates
t0 = dates(1);
ti = t0 + round(365*((0 + dt):dt:10));

% Compute B_t0_ti via bootstrap
B_0_i = interp1(dates, discounts, ti);

% Compute B_t0_ti_ti+1
B_0_i_i1 = B_0_i(2:end)./B_0_i(1:end-1);

% C0mpute the time grid steps
steps = (0 + dt):dt:10;

% Define the needed anonymous function to exploit the Lemma 2 relations
% between discounts
sigma_function = @(s,t) (sigma/a)*(1 - exp(-a*(t - s)));
sigma_integrand = @(u,a,w)  sigma_function(u,w).^2 - sigma_function(u,a).^2; 
exponential = @(x) exp((-x*sigma_function(0,dt)/sigma) - ...
    0.5*arrayfun(@(a,w,up) integral(@(u) sigma_integrand(u,a,w), 0, up), steps(2:end), steps(2:end) + dt, steps(2:end)));

% Exploit the relation to compute the discounts between two consecutive
% time steps in function of the value of the OU process
B_i_i1 = @(x) B_0_i_i1.*exponential(x);
B_i_i1 = @(x) [B_0_i(1) B_i_i1(x)];

% Compute sigma hat star
sigma_hat_star = (sigma/a)*sqrt(dt - 2*((1 - exp(-a*dt))/(a)) + ((1 - exp(-2*a*dt))/(2*a)));

% Exploit the  approximated relation of Lemma 1 to compute the stochastic 
% discounts between two consecutive time steps in function of the value of 
% the OU process
D_i_i1 = @(xi,xi1) B_i_i1(xi)*exp(-0.5*sigma_hat_star^2 - (sigma_hat_star/sigma_hat)*(exp(-a*dt)*(xi1 - xi) + mu_hat*xi1));

end

