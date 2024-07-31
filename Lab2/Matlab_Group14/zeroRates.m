function zRates = zeroRates(dates, discounts)
% Compute the zero rates from the bootstrapped discount with ACT/365

% INPUT
% dates:             vector of dates
% discounts:         vector of discounts

% OUTPUT
% zRates:            vector of zeroRates


%difference of each date and t0=dates(1)
delta = yearfrac(dates(1),dates(2:end),3);

% Computing the zero rate, we set the first one to 0 
zRates = [0, -(log(discounts(2:end)))./(delta)];

end