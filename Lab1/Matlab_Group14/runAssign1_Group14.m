% Assignment_1
%  Group 14, AA2023-2024
%
%  List of functions:


clc; clear all;

%characteristics of the EU Call option to price

S0=1;       %underlying price
K=1;        %strike price
r=0.03;     %time_to_maturity-zero-rate
T=1/4;      %time_to_maturity
sigma=0.22; %volatility
flag=1;     %flag:  1 call, -1 put
d=0.06;     %dividend yield
KI=1.3;     %barrier

%% Quantity of interest

B=exp(-r*T);   %discount obtained inverting the formula of the zero rate
bp = 0.01/100; %option bid/ask for these equity options
N = 10000;     %number of step (CRR) / number of simulation (MC)

%% Pricing

F0=S0*exp(-d*T)/B; % Forward in G&C Model

% Black formula 
pricingMode = 1; % 1 ClosedFormula, 2 CRR, 3 Monte Carlo
optionPrice=EuropeanOptionPrice(F0,K,B,T,sigma,pricingMode,flag);
Blk_price = optionPrice

% CRR
N=1000; %instead of 10000 because the factorial with huge numbers gives many warnings
pricingMode = 2;
optionPrice = EuropeanOptionCRR(F0,K,B,T,sigma,N);
CRR_price = optionPrice

% MonteCarlo
N=10000;
pricingMode = 3;
optionPrice=EuropeanOptionPrice(F0,K,B,T,sigma,pricingMode,N,flag);
MC_price = optionPrice

%% CRR Convergence
M = 1; %starting with 1 step and increasing until the error in smaller than bp
CRR_err = 1; %necessary condition to enter the first time in the while cycle
PricingMode = 2;

while(CRR_err > bp)
    optionPrice = EuropeanOptionPrice(F0,K,B,T,sigma,PricingMode,M,flag);
    CRR_err = abs(optionPrice-Blk_price);
    M = M + 1;
end

CRR_M = M; %number of steps of the binomial tree that satisfies the error's condition
fprintf('Number of steps (CRR) needed to achieve the desired accuracy = %d\n',CRR_M);
fprintf('Error = %d\n\n',CRR_err);

%% MC convergence
M = 100; %number of simulations
MC_err = 1;

%cycling an increasing M to get a more precise price
while(MC_err > bp)
    [optionPrice,std_dev] = EuropeanOptionMC(F0,K,B,T,sigma,M,flag);
    MC_err = std_dev;
    M = M + 1000;
end
MC_M = M;
fprintf('Number of simulation (MC) needed to achieve the desired accuracy = %d\n',MC_M);
fprintf('Error = %d\n',MC_err);

%% Errors Rescaling 

% plot Errors for CRR varing number of steps
% Note: both functions plot also the Errors of interest as side-effect 
[M,errCRR]=PlotErrorCRR(F0,K,B,T,sigma);

% plot Errors for MC varing number of simulations N 
[M,stdEstim]=PlotErrorMC(F0,K,B,T,sigma); 

%% KI Option

%pricing the barrier Call with CRR
optionPrice = EuropeanOptionKICRR(F0,K,KI,B,T,sigma,1000);
CRR_price_Barrier = optionPrice 

%pricing the barrier Call with MonteCarlo
optionPrice = EuropeanOptionKIMC(F0,K,KI,B,T,sigma,N);
MC_price_Barrier = optionPrice

%pricing the barrier Call with Closed Formula
optionPrice=EuropeanOptionKI_Closed(F0,K,KI,B,T,sigma);
Closed_price_Barrier = optionPrice

%% KI Option Vega (it might takes from 1 to 2 minutes)

S0 = linspace(0.70, 1.5, N); %underlying pricing range
F0=S0*exp(-d*T)/B;

%vega of the Barrier option with the exact formula
flagNum=1;
vega_exact= VegaKI(F0,K,KI,B,T,sigma,N,flagNum); %computing the vega with Black Formula
PlotVega(F0,vega_exact);
legend('Vega Closed Formula');

M=20; %dividing the interval in 20 stock prices
S0 = linspace(0.70, 1.5, M); %underlying pricing range
F0=S0*exp(-d*T)/B;

%vega of the Barrier option with MC method
flagNum=3;
vega_MC= VegaKI(F0,K,KI,B,T,sigma,N,flagNum); %computing the vega with MC
PlotVega(F0,vega_MC);
legend('Vega Montecarlo');

%% Antithetic Variables

S0 = 1;
F0=S0*exp(-d*T)/B;
M = 100; %number of simulations
MC_err = 1;
%cycling an increasing M to get a more precise price (P)
while(MC_err > bp)
    [~,std_dev] = EuropeanOptionMC(F0,K,B,T,sigma,M,flag);
    MC_err = std_dev;
    M = M + 1000;
end
MC_M = M;
fprintf('Number of simulation (MC classic) needed to achieve the desired accuracy = %d\n',MC_M);


M = 100; %number of simulations
MC_antithetic_err = 1;
%cycling an increasing M to get a more precise price (P)
while(MC_antithetic_err > bp)
    [~,std_dev] = EuropeanOptionMC_Antithetic(F0,K,B,T,sigma,M,flag);
    MC_antithetic_err = std_dev;
    M = M + 10;
end
MC_antithetic_M = M;
fprintf('Number of simulation (MC antithetic) needed to achieve the desired accuracy = %d\n',MC_antithetic_M);

%% Bermudan Option Pricing

optionPrice = BermudanOptionCRR(F0,K,B,T,sigma,N);
Bermudan_Option_price = optionPrice