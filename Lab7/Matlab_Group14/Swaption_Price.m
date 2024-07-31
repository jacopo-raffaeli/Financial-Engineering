function [price_tree_bermudan, price_jamshidian_EU] = Swaption_Price(N, a, sigma, ttm, strike, dates, discounts, flag_bermudan)
% Pricing a swaption via a trinomial tree approach
%
% INPUT:
% N: Number of time steps
% a: Speed of mean reversion of the HW model
% sigma: Volatility of the HW model
% ttm: Time to Maturity of the bermudan option
% strike: Strike price of the swaption
% dates
% discounts
%
% OUTPUT:
% price: Price of the swaption

% Trinomial tree parameters
dt = ttm/N;
mu_hat = 1 - exp(-a*dt);
sigma_hat = sigma*sqrt((1 - exp(-2*a*dt))/(2*a));
dx = sqrt(3)*sigma_hat;

% As discussed in class we take l_max as small as possible (and so l_min as
% big as possible) in order to build a subtle tree.
l_max = ceil((1-sqrt(2/3))/mu_hat);
l_min = -l_max;
l = l_max:-1:l_min;

% Trinomial forward tree simulation (OU process simulation)
forward_tree = compute_forward_tree(l_max, dx ,N);

% Compute the spot discounts curves applying Lemma 2 corollary
discounts_curves = compute_forward_curves(dates, discounts, a, sigma);

% Select only the nodes of the tree in the early exercise dates (i.e years
% from 2 to 10) [Bermudan Swaption]
forward_tree_payoff = forward_tree(:,[1, (N/10*2+1):N/10:end]);

% Compute the payoffs in the early exercise dates
payoffs = compute_payoffs(discounts_curves, forward_tree_payoff, strike);

% Compute the stochastic discounts
stoch_disc = stochastic_discounts(dates, discounts, a, sigma, dt, mu_hat, sigma_hat);

% Trinomial tree probabilities
p = zeros(size(l,2),3);
% Case A (standard l_min < l < l_max)
pA_d = 0.5*((1/3) + l(2:end-1)*mu_hat + (l(2:end-1)*mu_hat).^2);
pA_m = (2/3) - (l(2:end-1)*mu_hat).^2;
pA_u = 0.5*((1/3) - l(2:end-1)*mu_hat + (l(2:end-1)*mu_hat).^2);
p(2:end-1,:) = [pA_u', pA_m', pA_d'];
% % Case B (l = l_min)
pB_d = 0.5*((7/3) + 3*l_min*mu_hat + (l_min*mu_hat).^2);
pB_m = (-1/3) - 2*l_min*mu_hat - (l_min*mu_hat).^2;
pB_u = 0.5*((1/3) + l_min*mu_hat + (l_min*mu_hat).^2);
p(end,:) = [pB_u, pB_m, pB_d];
% % Case C (l = l_max)
pC_d = 0.5*((1/3) - l_max*mu_hat + (l_max*mu_hat).^2);
pC_m = (-1/3) + 2*l_max*mu_hat - (l_max*mu_hat).^2;
pC_u = 0.5*((7/3) - 3*l_max*mu_hat + (l_max*mu_hat).^2);
p(1,:) = [pC_u, pC_m, pC_d];

% Compute the backward tree
bw_tree = compute_backward_tree(forward_tree(:,(1:(end - (1/dt)))), payoffs, stoch_disc, l_max, p', dt, flag_bermudan);

% Compute the swaption price
price_tree_bermudan = bw_tree(find(l == 0),1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% JAMSHIDIAN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% In order to check the tree correctness we price a vanilla swaption with
% exercise date 2 years
% We already have the discounts curves.
% We compute numerically X* and then we plug in it
discounts_curves1 = compute_forward_curves1(dates, discounts, a, sigma);
coupon_sum = @(x) sum(discounts_curves1(x));
eqn = @(x) 1 - strike*coupon_sum(x) - 1*get_ld(discounts_curves1(x),1);
X_star = fzero(eqn,0);
B_star = get_row(discounts_curves1(X_star),1);

% Compute the needed discounts via bootstrap
t0 = dates(1);
T = finddates(t0, 0:10, 0);
init_spot_discounts = find_discount(dates, discounts, T);
fwd_discounts = init_spot_discounts(2:end)./init_spot_discounts(1);
sigma_function = @(s,t) (sigma/a)*(1 - exp(-a*(t - s)));
sigma_integrand = @(t,w)  (sigma_function(t,w) - sigma_function(t,0)).^2;
P_ai = zeros(1,size(B_star,2));
r = -log(init_spot_discounts(1))/2;
for ii = 1:size(B_star,2)
    V2 = 0.5*integral(@(t) sigma_integrand(t,ii+2), 0, 2);
    % d1 = log(fwd_discounts(ii)/B_star(ii))./sqrt(V2*2) + 0.5*sqrt(V2*2);
    % d2 = log(fwd_discounts(ii)/B_star(ii))./sqrt(V2*2) - 0.5*sqrt(V2*2);
    % % Exploit the PC parity to compute the ZC put prices
    % P_ai(ii) = init_spot_discounts(1)*(B_star(ii)*normcdf(-d2) - fwd_discounts(ii)*normcdf(-d1));
    [~,P_ai(ii)] = blkprice(fwd_discounts(ii),B_star(ii),r,2,sqrt(V2));
end
price_jamshidian_EU = strike*sum(P_ai) + 1*P_ai(end); 


end