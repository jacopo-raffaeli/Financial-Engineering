% runES1
%
% GROUP 14
%

clear;
clc;
close all;

%% Settings
formatData='dd/mm/yyyy';
load('cSelect20230131_B.mat')
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

%% parameters
% yearfrac formats
act360 = 2;
act365 = 3;
thirty360 = 6;

% Number of MC simulations
N = 1e7;

%% upfron 2 years

settlement_date  = datenum(datetime(2008,2,19));
maturity=2; 
coupons_2Y=[0.06; 0.02];

% compute payments date
payment_dates_2Y = finddates(datesSet.settlement, 3:3:(maturity*12),1)'; %(tolgo la settlment)

%find coupon payments date
coupon_payment_dates_2Y= finddates(datesSet.settlement, 12:12:(maturity*12),1)'; %(tolgo la settlment)


certificate = struct ('setDate', settlement_date, 'maturity',payment_dates_2Y(end) ,'paymentDates', payment_dates_2Y , 'strike', 3200, ...
    'spol', 0.013, 'coupon', coupons_2Y,'Coupon_paymentDates', coupon_payment_dates_2Y , 'flagYearfrac_coupon', 6);

%alpha, sigma, k e eta found in calibration of assigment 5.4
parameters_NIG=[1/2, 0.104950, 1.316058, 12.732630]'; 
parameters_VG=[0, 0.1385, 1.7705, 4.6170]';

%compure the upfront with three model (NIG, VG, Black)
[upfront_NIG] = certificatePricing(cSelect, dates, discounts,certificate, parameters_NIG, N, 1);
[upfront_VG] = certificatePricing(cSelect, dates, discounts,certificate, parameters_VG, N, 3);
[upfront_black] = certificatePricing(cSelect, dates, discounts,certificate, parameters_NIG, N, 2);

%percentage error
percentage_error_black = abs((upfront_black - upfront_NIG) ./ upfront_NIG) * 100;
percentage_error_VG = abs((upfront_VG - upfront_NIG) ./ upfront_NIG) * 100;

%% upfront 3 years
settlement_date  = datenum(datetime(2008,2,19));
maturity=3; 
coupons_3Y=[0.06; 0.06; 0.02];

% compute payments date
payment_dates_3Y = finddates(datesSet.settlement, 3:3:(maturity*12),1)'; %(tolgo la settlment)

%find coupon payments date
coupon_payment_dates_3Y= finddates(datesSet.settlement, 12:12:(maturity*12),1)'; %(tolgo la settlment)

certificate = struct ('setDate', settlement_date, 'maturity',payment_dates_3Y(end) ,'paymentDates', payment_dates_3Y , 'strike', 3200, ...
    'spol', 0.013, 'coupon', coupons_3Y,'Coupon_paymentDates', coupon_payment_dates_3Y , 'flagYearfrac_coupon', 6);

%alpha, sigma, k e eta found in calibration of assigment 5.4
parameters_NIG=[1/2, 0.104950, 1.316058, 12.732630]';
parameters_VG=[0, 0.1385, 1.7705, 4.6170]';

%compure the upfront with NIG model
[upfront_3Y_NIG] = certificatePricing_3Y( dates, discounts,certificate, parameters_NIG, N,1);
[upfront_3Y_VG] = certificatePricing_3Y( dates, discounts,certificate, parameters_VG, N,2);

percentage_error_VG3y = abs((upfront_3Y_VG - upfront_3Y_NIG) ./ upfront_3Y_NIG) * 100;
