function MacD = sensCouponBond(setDate, couponPaymentDates, fixedRate, dates, discounts)
% Evaluating  the Macaulay Duration for  an "I.B. coupon bond" with same expiry, 
% fixed rate & reset dates of the IRS, and face value equal to IRS Notional.

% INPUT 
% setDate:              date in which the contract is set
% couponPaymentDates:   payments dates for the coupon
% fixedRate:            fixed rate 
% dates:                complete set of dates
% discounts:            complete set of discounts

% OUTPUT
% MacD:                 macaulay duration


% Computing the year-fraction for the fixed leg date
% 1 == 30/360 convention
delta = yearfrac([setDate,couponPaymentDates(1:end-1)], couponPaymentDates, 1);

% Defining the respective discounts
% The rates we are interested are the corresponding of the dates "19 Feb" 
% from 2009 to 2014, those are respectively in position 8 and from 13 to 17.
discountsPaymentDates = [discounts(8),discounts(13:17)];

% Computing the coupuns
c = fixedRate.*delta;
% We add the face value at the last coupon
c = [c(1:end-1), 1 + c(end)];
% Computing Macaulay Duration
MacD = (sum(c.*yearfrac(setDate, couponPaymentDates, 1).*discountsPaymentDates))/(sum(c.*discountsPaymentDates));

end