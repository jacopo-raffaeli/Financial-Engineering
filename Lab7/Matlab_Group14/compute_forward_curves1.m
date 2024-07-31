function discounts_curves = compute_forward_curves1(dates, discounts, a, sigma)
% Exploit the Lemma 2's corollary in order to compute the spot discounts
% between a t_alpha and all the following t_i for i = {alpha + 1, ..., omega}
% and for t_alpha = 0
%
% INPUT:
% dates
% discounts
% a: HW model parameter
% sigma: HW model parameter
%
% OUTPUT:
% 
% discount_curves: Matrix where each row is the discount curve for a
%                  certain t_alpha and the columns are the spot discounts 
%                  B_talpha_ti

% Setting the time grid for discounts
t0 = dates(1);
T = finddates(t0, 0:10, 0); 

% Initialize the discounts curves matrix
discounts_curves = zeros(1, length(T)-1);
% Initialize the time matrixes
t_a = zeros(1, length(T)-1);
t_w = zeros(1, length(T)-1);
tao = zeros(1, length(T)-1);
t_0 = zeros(1, length(T)-1);

% Find the discounts in the grid's dates (to ininzialize the curves)
init_spot_discounts = find_discount(dates, discounts, T);
discounts_curves = init_spot_discounts(2:end)/init_spot_discounts(1);
t_w = 1:10;

% Define the time difference matrix
tao = t_w - t_a;

% Find the spot discount curves in function of the values of the OU process x
% using the previously computed datas as initial data
sigma_function = @(s,t) (sigma/a)*(1 - exp(-a*(t - s)));
sigma_integrand = @(u,a,w)  sigma_function(u,w).^2 - sigma_function(u,a).^2; 
exponential = @(x) exp(-((x*sigma_function(0,tao))/sigma));
discounts_curves = @(x) discounts_curves.*exponential(x);


end