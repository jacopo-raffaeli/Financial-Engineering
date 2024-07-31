%% ASSIGNMENT 5
%
% GROUP 14
%

clear;
clc;
close all;

%% Settings
formatData='dd/mm/yyyy';
load('cSelect20230131_B.mat');

%% Read Market Data
if ispc()   % Windows version
    [datesSet, ratesSet] = readExcelData('MktData_CurveBootstrap.xls', formatData);
else        % MacOS version
    [datesSet, ratesSet] = readExcelDataMacOS('MktData_CurveBootstrap.xls');
end

%% Bootstrap

% Get dates, discount factors and rates (EURIBOR) from the market
[dates, discounts]=bootstrap(datesSet, ratesSet);
zRates = zeroRates(dates, discounts);

% Set the Settlement Date 
% Set date = "19/02/2008"
SetDate = dates(1);
% Fix date1 since it is not present in the bootstrap
Date1 = datenum(2009,02,19);

% Find the discount factors for the "fixed leg": 
% Compute the one referred to date1 by interpolation
fixed_dates = [SetDate; Date1; dates(12:14)];
Act365 = 3;
delta_t_fixed = yearfrac(fixed_dates(1:end-1),fixed_dates(2:end),Act365);
yf_Date1 = yearfrac(SetDate,Date1,Act365);
discounts_payment_fixed = [1; exp(-interp1(dates,zRates,Date1).*yf_Date1); discounts(12:14)];
% Compute the forward rates (To calculate Brownian Motion dynamics)
r_fwd = -log(discounts_payment_fixed(2:end)./discounts_payment_fixed(1:end-1))./delta_t_fixed;

% Find the discount factors for the "floating leg"
floating_dates = [SetDate finddates(SetDate,3:3:48,1)]';
Act360 = 2;
delta_t_floating = yearfrac(floating_dates(1:end-1),floating_dates(2:end),Act360); % Act/360 (See Swap Termsheet)
yf_floating = yearfrac(SetDate,floating_dates(2:end),Act360);
discounts_payment_floating = [exp(-interp1(dates,zRates,floating_dates(2:end)).*yf_floating)];

%% 1. Case Study: Certificate Price

% PARAMETERS (See the termsheet)

spol = 100e-4;
upfront = 0.02;
rho = 0.4;
sigma_1 = 0.161;
sigma_2 = 0.2;
d_ENEL = 0.025;
d_AXA = 0.027;
E1_start = 100;
E2_start = 200;
P = 0.95;

% MONTECARLO SIMULATION

% Number of simulations
N = 1e5;

% Generate correlated standard normal rv's (correlated)
% Fix the seed
% rng('default')
sigma = [1 rho; rho 1];
A = chol(sigma, 'lower');
g = randn(length(delta_t_fixed)*N, 2) * A;
g1 = g(:,1);
g2 = g(:,2);

% Initialize the stock prices dynamics
E1 = zeros(N,length(delta_t_fixed)+1);
E2 = zeros(N,length(delta_t_fixed)+1);
E1(:,1) = E1_start;
E2(:,1) = E2_start;
k=0;

% Simulate the dynamics of the stocks year by year
for ii=1:length(delta_t_fixed)
    E1(:,ii+1) = E1(:,ii).*exp( (r_fwd(ii) - d_ENEL - 0.5*(sigma_1^2))*delta_t_fixed(ii) - sigma_1*sqrt(delta_t_fixed(ii))*g1( (k*N+1) : ((k+1)*N) ) );
    E2(:,ii+1) = E2(:,ii).*exp( (r_fwd(ii) - d_AXA - 0.5*(sigma_2^2))*delta_t_fixed(ii) - sigma_2*sqrt(delta_t_fixed(ii))*g2( (k*N+1) : ((k+1)*N) ) );
    k=k+1;
end

% Computation of the basket as indicated in the Swap termsheet
S = sum((1/2)*(E1(:,2:end)./E1(:,1:end-1) + E2(:,2:end)./E2(:,1:end-1)), 2);
performance_vector = max(S-P,0);
performance = mean(performance_vector);

% Find the participation coefficient (NPV fixed = NPV floating)
eqn = @(x) upfront + discounts_payment_fixed(end)*x*performance + discounts_payment_floating(end)*1 - ...
1 - discounts_payment_floating(end)*(1-P) - sum(spol*discounts_payment_floating.*delta_t_floating);

% Solve the NPV for participation coefficient alpha
alpha=fzero(eqn, 0);

% Confidence interval for alpha
alpha_std = std(performance_vector)/sqrt(N);
alpha_IC = [alpha - norminv(1-0.05/2)*alpha_std, alpha + norminv(1-0.05/2)*alpha_std];


%% 2. Exercise: Pricing Digital Option

Notional =10^7;                      
digital_payoff = 0.05*Notional;              
S0 = cSelect.reference;       
d = cSelect.dividend;         
%ATM Spot
K = S0;                        

% Time difference with act/365 convention
delta_t = yearfrac(SetDate,Date1,Act365);

% Find discount
B_0_t = exp(-interp1(dates,zRates,Date1).*yf_Date1);

% Compute interest rate (Necessary to calculate the forward)
r = -log(B_0_t)./delta_t;

% Compute forward price
F0 = S0*exp(delta_t*(r-d));

% Calculate the price of a digital option according to the Black model
unitary_black_price = priceblack(F0, K, delta_t, B_0_t, cSelect);
black_price = digital_payoff*unitary_black_price;

%calculate the price of a digital option considering the smile in the curve of the implied volatility
unitary_smile_price = pricesmile(F0, K, delta_t, B_0_t, cSelect);
smile_price = digital_payoff*unitary_smile_price;

%% 3. Exercise: Pricing

% PARAMETERS
a = 0.5;
a_facoltativo = 2/3;
dev_sigma = 0.2;
kappa = 1;
eta = 3;
delta_t = 1;
moneyness = -0.25:0.01:0.25;
r = -log(B_0_t)/delta_t;
F0 = S0*exp(delta_t*(r-d));

M = 15;
dz_free = 0.014;
x1_free = -225;
free = x1_free;
flag = 1;

% Compute the price according to FFT method
method_flag = 0; 
C_FFT = Compute_Price(M, free, flag, moneyness, method_flag, eta, kappa, dev_sigma, delta_t, a, B_0_t, F0);


% Compute the price according to Quadrature method
method_flag = 1; 
C_Quadrature = Compute_Price(M, free, flag, moneyness, method_flag, eta, kappa, dev_sigma, delta_t, a, B_0_t, F0);

% Compute the price according to MC method
N = 1e6;
[C_MC, error, IC] = MC_price(N, kappa, F0, moneyness, delta_t, a, eta, dev_sigma, B_0_t);


%% 3. Exercise: Pricing - Facultative

% Compute the price according to FFT method
method_flag = 0; 
C_FFT_prime = Compute_Price(M, free, flag, moneyness, method_flag, eta, kappa, dev_sigma, delta_t, a_facoltativo, B_0_t, F0);

% Compute the price according to Quadrature method
method_flag = 1; 
C_Quadrature_prime = Compute_Price(M, free, flag, moneyness, method_flag, eta, kappa, dev_sigma, delta_t, a_facoltativo, B_0_t, F0);

C_FFT_err = 100*(abs(C_FFT - C_FFT_prime)./C_FFT);
C_Quadrature_err = 100*(abs(C_Quadrature - C_Quadrature_prime)./C_Quadrature);


%% PLOT WRT ALPHA = 1/2
% Plot for C_FFT
figure;
plot(moneyness, C_FFT, 'b', 'LineWidth', 2);
xlabel('Moneyness');
ylabel('FFT Price');
title('Option Prices vs. Moneyness (FFT)');
grid on;

% Plot for C_Quadrature
figure;
plot(moneyness, C_Quadrature,  'b', 'LineWidth', 2);
xlabel('Moneyness');
ylabel('Quadrature Price');
title('Option Prices vs. Moneyness (Quadrature)');
grid on;

% Plot for C_MC
figure;
plot(moneyness, C_MC,  'b', 'LineWidth', 2);
hold on 
plot(moneyness, (IC(:,2)), '--', 'Color', [0.8500, 0.3250, 0.0980]); 
plot(moneyness, (IC(:,1)), '--', 'Color', [0.8500, 0.3250, 0.0980]);
fill([moneyness, fliplr(moneyness)], [IC(:,2)', fliplr(IC(:,1)')], [0.5273, 0.8086, 0.9238], 'FaceAlpha', 0.3, 'EdgeColor', 'none');
xlabel('moneyness');
ylabel('MC Price');
title('Option Prices vs. Moneyness (MC) [N = 1000]');
legend('Price', 'Upper Bound', 'Lower Bound','Confidence Interval 95%', 'Location', 'southeast');
grid on;
hold off


%% ALPHA = 1/2 VS ALPHA = 2/3

% Plot for C_FFT
figure;
plot(moneyness, C_FFT,  'Color', [0.5273, 0.8086, 0.9238], 'LineWidth', 2);
hold on
plot(moneyness, C_FFT_prime, 'r--', 'LineWidth', 1.15);
xlabel('Moneyness');
ylabel('FFT Price');
title('FFT prices with \alpha = 1/2 and \alpha = 2/3');
legend('Price (\alpha=1/2)', 'Price (\alpha=2/3)', 'Location', 'southeast');
grid on;
hold off

% Plot for C_Quadrature
figure;
plot(moneyness, C_Quadrature, 'Color', [0.5273, 0.8086, 0.9238], 'LineWidth', 2);
hold on
plot(moneyness, C_Quadrature_prime, 'r--', 'LineWidth', 1.15);
xlabel('Moneyness');
ylabel('Quadrature Price');
title('Quadrature prices with \alpha = 1/2 and \alpha = 2/3');
legend('Price (\alpha=1/2)', 'Price (\alpha=2/3)', 'Location', 'southeast');
grid on;
hold off


%% 4. Case Study: Volatility Surface Calibration

% PARAMETERS

alpha = 1/3;
sigma_black = cSelect.surface;
K = cSelect.strikes;

% Compute black price with built-in Matlab function
price_black = blkprice(F0, K, r, delta_t, sigma_black);

% Compute moneyness
moneyness=log(F0./K);

% Compute price
method_flag = 0;
price_FFT = @(params) Compute_Price(M, free, flag, moneyness, method_flag, params(1), params(2), params(3), delta_t, alpha, B_0_t, F0)

% Compute L2 distance between prices
weight = ones(length(K),1)/length(K);
dist = @(params) sum(weight' .* abs(price_black - price_FFT(params)).^2);

%parameters for normal mean variance mixture
initial_param = [3,1,0.2]'; %nu, k, volatility

A = -eye(3);
b = zeros(3,1);
b(3) = min(weight);

%Find minimum of constrained nonlinear multivariable function using the
%built-in Matlab function fmincon
params = fmincon(@(params) dist(params), initial_param, A, b);

% Update parameters with the ones that minimize the L2 distance
eta = params(1);
asymmetry = params(2);
sigma = params(3);

% Compute price with the new parameters
price_FFT =  Compute_Price(M, free, flag, moneyness, method_flag, eta, asymmetry, sigma, delta_t, alpha, B_0_t, F0);

% Implied volatilities
vols = blkimpv(F0, K, r, delta_t, price_FFT);

% Plot implied volatility against the mean of the surface
figure;
plot(K, sigma_black,  'Color', [0.5273, 0.8086, 0.9238], 'LineWidth', 2);
hold on
plot(K,vols, 'r--', 'LineWidth', 1.15);
xlabel('Strikes');
ylabel('Implied Volatility');
title('Market Volatility vs Implied Volatility');
legend('Market Volatility','Model Volatility', 'Location', 'southwest');
grid on;
hold off









