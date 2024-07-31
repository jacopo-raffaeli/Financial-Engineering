function [DV01, BPV, DV01_z] = sensSwap(setDate,fixedLegPaymentDates,fixedRate,dates,discounts,discounts_DV01)
% Evaluating all the principal sensitivities measure for a for a portfolio 
% composed only by one single swap, a 6y plain vanilla IR swap vs Euribor 3m

% INPUT 
% setDate:              date in which the contract is set
% fixedLegPaymentDates: payments dates for the fixed leg
% fixedRate:            fixed rate 
% dates:                complete set of dates
% discounts:            complete set of discounts
% discounts_DV01:       complete set of shifted discounts

% OUTPUT
% DV01:                 sensitivity to the parallel shift of market rates
%                       of 1bp
% DV01_z:               sensitivity to the parallel shift of zero rates
%                       of 1 bp
% BPV:                  NPV of 1bp

% Value of 1bp
shift = 0.01/100;

% Computing the year-fraction for the fixed leg date
% 1 == 30/360 convention
delta = yearfrac([setDate,fixedLegPaymentDates(1:end-1)], fixedLegPaymentDates, 1);

% Defining the respective discounts
% The rates we are interested are the corresponding of the dates "19 Feb" 
% from 2009 to 2014, those are respectively in position 8 and from 13 to 17.
discountsPaymentDates = [discounts(8),discounts(13:17)];
discountsPaymentDates_DV01 = [discounts_DV01(8),discounts_DV01(13:17)];

%% Computing DV01 parallel shift

% Computing the NPV fixed leg with discounts
NPV_fixed = fixedRate*sum(discountsPaymentDates.*delta);

% Computing the NPV floating leg with discounts

% Note: floating leg are computed in act/360, however by theoric
% computation (telescopic sum) the final value does not depend on the year
% fraction.
NPV_floating = 1 - discountsPaymentDates(end);

% Computing the NPV with shifted discounts
NPV_fixed_DV01 = fixedRate*sum(discountsPaymentDates_DV01.*delta);

% Computing the NPV floating leg with shifted discounts
NPV_floating_DV01 = 1 - discountsPaymentDates_DV01(end);

% Computing the DV01
DV01 = abs((NPV_fixed - NPV_floating) - (NPV_fixed_DV01 - NPV_floating_DV01));

%% Computing DV01 parallel shift with zero rates

% Computing zero rates 
zRates = zeroRates(fixedLegPaymentDates, discountsPaymentDates);

% Computing shifted discounts rate by inverting the formula and not by
% another bootstrap
discountsPaymentDates_DV01_z = discountsPaymentDates.*exp(-shift*yearfrac(setDate, fixedLegPaymentDates, 1));

% Computing the NPV fixed leg with discounts
NPV_fixed_z = fixedRate*sum(discountsPaymentDates.*delta);

% Computing the NPV floating leg with discounts
NPV_floating_z = 1 - discountsPaymentDates(end);

% Computing the NPV with shifted discounts
NPV_fixed_DV01_z = fixedRate*sum(discountsPaymentDates_DV01_z.*delta);

% Computing the NPV floating leg with shifted discounts
NPV_floating_DV01_z = 1 - discountsPaymentDates_DV01_z(end);

% Computing the DV01_z
DV01_z = abs((NPV_fixed_z - NPV_floating_z) - (NPV_fixed_DV01_z - NPV_floating_DV01_z));

%% Computing BPV of the 6y IRS;

% Computing the BPV
BPV = abs(shift*sum(discountsPaymentDates.*delta));

end