function [datesSet_complete, ratesSet_complete] = complete_set(datesSet, ratesSet)
% Create the complete set of swap dates-discounts with a modified
% following convention
%
% INPUT:
% datesSet:  struct of the dates of market Data
% ratesSet:  struct of the rates of market Data
%
% OUTPUT:
% datesSet_complete: complete set of swap dates
% ratesSet_complete: complete set of swap rates

datesSet_complete = datesSet;
ratesSet_complete = ratesSet;

% Create complete set of dates-discounts
SetDate = datesSet.settlement;
years_increments = 1:50;
swap_dates_total = finddates(SetDate,years_increments,0)';

SetDate = datesSet.settlement;
years_increments = [1:12 15 20 25 30 40 50];
swap_dates = finddates(SetDate,years_increments,0)';
swap_rates = mean(ratesSet.swaps,2);
swap_rates_total = spline(swap_dates,swap_rates,swap_dates_total);

datesSet_complete.swaps = swap_dates_total;
ratesSet_complete.swaps = swap_rates_total;

end