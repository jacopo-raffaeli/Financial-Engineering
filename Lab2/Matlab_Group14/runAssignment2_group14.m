% runAssignment2
% group 14, AY2023-2024
% Computes Euribor 3m bootstrap with a single-curve model
tic
clear all;
close all;
clc;
format short

%% Settings

formatData='dd/mm/yyyy'; %Pay attention to your computer settings 

%% Read market data

% This fuction works on Windows OS. Pay attention on other OS.
tic
[datesSet, ratesSet] = readExcelData('MktData_CurveBootstrap', formatData);
toc

%% Bootstrap

% Dates includes SettlementDate as first date
tic
[dates, discounts]=bootstrap(datesSet, ratesSet); 
toc

%% Compute Zero Rates

% Computing the zero rates from the discounts
tic
zRates = 100*zeroRates(dates, discounts);
toc

%% Plot Results

% Converting the dates from a numeric format to the 'dd/mm/yyyy' one
tic
dates_representation = datetime(dates, 'ConvertFrom', 'datenum');

% Discount curve
figure(1)
plot(dates_representation,discounts,'-or',LineWidth = 1);
dateformat = 'dd/MM/yyyy';
xtickformat(dateformat);
xlabel('Dates');
ylabel('Discounts');
title('Bootstrap Discounts')

% Zero-rates

figure(2)
plot(dates_representation,zRates,'-ob',LineWidth = 1);
dateformat = 'dd/MM/yyyy';
xtickformat(dateformat);
xlabel('Dates');
ylabel('Zero rates');
title('Bootstrap Zero rates')
toc

%% DV01, DV01_z, BPV, Macaulay Duration

tic
% Computing the sensitivities DV01, DV01_z, BPV for a portfolio composed 
% only by one single swap, a 6y plain vanilla IR swap vs Euribor 3m with a 
% fixed rate 2.8173% and a Notional of €10 Mln.

% Fixing the settlement date
setDate = datesSet.settlement;

% Fixing the fixed leg dates, in our context they are equal to the 19 of
% february of the 6 years after 2008, aside for the case in where such
% dates are a non business day (This last particular is already taken in 
% consideration in the excel file).
% The dates we are interested in are "19 Feb" from 2009 to 2014 those are
% respectively in position 8 and from 13 to 17.
fixedLegPaymentDates = [dates(8), dates(13:17)];

% Define the fixed rate
fixedRate = 2.8173/100;

% Define the basic shift of 1bp
shift = 0.01/100;

% Creating a struct with the shifted rates
ratesSet_DV01.depos = ratesSet.depos + shift;
ratesSet_DV01.futures = ratesSet.futures + shift;
ratesSet_DV01.swaps = ratesSet.swaps + shift;

% Bootstrap with shifted rates
[~, discounts_DV01] = bootstrap(datesSet, ratesSet_DV01);
[DV01, BPV, DV01_z] = sensSwap(setDate,fixedLegPaymentDates,fixedRate,dates,discounts,discounts_DV01);
couponPaymentDates = fixedLegPaymentDates;
MacD = sensCouponBond(setDate, couponPaymentDates, fixedRate, dates, discounts);
toc
toc