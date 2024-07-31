function DV01 = DV01_swap_cg(datesSet, ratesSet, PaymentDates, discounts, buckets, flag)
% Compute the sensitivity indexes of an IRS (DV01, BPV, DVO1_z)
% 
% INPUT
% datesSet:     struct of the dates of market Data
% ratesSet:     struct of the rates of market Data
% PaymentDates: dates of the discount factors computed in bootstrap
% discounts:    df obtained by the bootstrap
% buckets:      buckets vector
% flag:         1 coarsed grained bucket at 2y
%               2 coarsed grained bucket at 5y
%               3 coarsed grained bucket at 10y
%               4 coarsed grained bucket at 15y
%
% OUTPUT
% DV01:         

curve_shift = 1e-4;

% IRS Data
setDate=datesSet.settlement; 

% build the rates set with increment
ratesSet_DV01.depos = ratesSet.depos + curve_shift;
ratesSet_DV01.futures = ratesSet.futures + curve_shift;

w = Weights(flag, buckets , datesSet, 0);
w(buckets(flag+1)+1:end) = 0;
ratesSet_DV01.swaps = ratesSet.swaps + curve_shift.*w;

%compute the discounts with the shifted rates curve
[datesSet_complete_DV01, ratesSet_complete_DV01] = complete_set(datesSet, ratesSet_DV01);
[dates, discounts_DV01]=bootstrap(datesSet_complete_DV01, ratesSet_complete_DV01);

fixedRate = mean(ratesSet.swaps(find(datesSet.swaps == PaymentDates(end)),:)); % *********

Act365 = 3;
fixedLegdates_yf_3 = yearfrac(setDate, PaymentDates, Act365);
dates_yf = yearfrac(setDate, dates, Act365);

% compute the zRates corresponding to the fixed leg for both shifted curve and real curve
zRates= zeroRates(dates, discounts);
zRates_DV01= zeroRates(dates, discounts_DV01);

% compute zero rates, then DF for both curves
zRates_fixedLeg=interp1(dates_yf,zRates,fixedLegdates_yf_3);
zRates_fixedLeg_DV01=interp1(dates_yf,zRates_DV01,fixedLegdates_yf_3);

discounts_fl= exp(-fixedLegdates_yf_3.*zRates_fixedLeg);
discounts_fl_DV01= exp(-fixedLegdates_yf_3.*zRates_fixedLeg_DV01);

% compute delta_t then BPV for both curves and date for zero rates using act/365 convention
Act30_360 = 6;

delta_t= yearfrac([setDate;PaymentDates(1:end-1)], PaymentDates, Act30_360);
BPV=sum(delta_t.*discounts_fl);
BPV_DV01=sum(delta_t.*discounts_fl_DV01);

% compute NPV for both curves and find the difference (DV01)
NPV = 1 - discounts_fl(end) - BPV*fixedRate;
NPV_DV01 = 1 - discounts_fl_DV01(end) - BPV_DV01*fixedRate;
DV01 = NPV_DV01 - NPV; 

end