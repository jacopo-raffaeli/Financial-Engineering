% runES2
%
% GROUP 14
%
clear; 
clc;
close all;

%% Read Market Data
formatData='dd/mm/yyyy';

if ispc()   % Windows version
    [datesSet, ratesSet] = readExcelData('MktData_CurveBootstrap.xls', formatData);
else        % MacOS version
    [datesSet, ratesSet] = readExcelDataMacOS('MktData_CurveBootstrap.xls');
end

%% Bootstrap

% Get dates, discount factors and rates (EURIBOR) from the market
[dates, discounts]=bootstrap(datesSet, ratesSet);

%% Exercise: Bermudian Option Pricing via Hull-White

% Parameters
N = 10;
a = 0.11;
sigma = 0.008;
ttm = 10;
strike = 0.05;
% flag_bermudan:
% == 0 Do not check the early exercise possibility (European swaption)
% == 1 Check the early exercise possibility (Bermudan swaption)
flag_bermudan = 1;

% a) Price swaption via trinomial tree 
[bermudan_swaption_price_tree, ~] = Swaption_Price(N, a, sigma, ttm, strike, dates, discounts, flag_bermudan);

% b) Price check
flag_bermudan = 0;
[EU_swaption_price_tree, EU_swaption_price_jamshidian] = Swaption_Price(N, a, sigma, ttm, strike, dates, discounts, flag_bermudan);

