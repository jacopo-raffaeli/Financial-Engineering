function discounts_curves = compute_forward_curves(dates, discounts, a, sigma)
% Exploit the Lemma 2's corollary in order to compute the spot discounts
% between a t_alpha and all the following t_i for i = {alpha + 1, ..., omega}
% and for t_alpha = {2,...,9}
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
T = finddates(t0, 2:10, 0); %%%%%%% SISTEMARE TIME STEP ULTIMO ANNO

% Initialize the discounts curves matrix
discounts_curves = zeros(length(T), length(T)-1);
% Initialize the time matrixes
t_a = zeros(length(T), length(T)-1);
t_w = zeros(length(T), length(T)-1);
tao = zeros(length(T), length(T)-1);
t_0 = zeros(length(T), length(T)-1);

% Find the discounts in the grid's dates (to ininzialize the curves)
init_spot_discounts = find_discount(dates, discounts, T);
for ii = 1: size(discounts_curves,1)
    init_fwd_discounts = init_spot_discounts(ii+1:end)./init_spot_discounts(ii);
    discounts_curves(ii,ii:end) = init_fwd_discounts;
    t_a_ii = (ii + 1)*ones(1,length(ii+1:length(T)));
    t_a(ii,ii:end) = t_a_ii;
    t_w_ii = (ii:length(T)-1) + 2;
    t_w(ii,ii:end) = t_w_ii;
    % if ii >= 2
    %     discounts_curves(ii,ii-1) = 1;
    % end
end

% Define the time difference matrix
tao = t_w - t_a;

% Find the spot discount curves in function of the values of the OU process x
% using the previously computed datas as initial data
sigma_function = @(s,t) (sigma/a)*(1 - exp(-a*(t - s)));
sigma_integrand = @(u,a,w)  sigma_function(u,w).^2 - sigma_function(u,a).^2; 
exponential = @(x) exp(-((x*sigma_function(0,tao))/sigma) - ...
    0.5*arrayfun(@(a,w,lb,up) integral(@(u) sigma_integrand(u,a,w), lb, up), t_a, t_w, t_0, t_a));
discounts_curves = @(x) discounts_curves.*exponential(x);


end