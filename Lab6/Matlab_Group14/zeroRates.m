function zRates = zeroRates(dates, discounts)
% Compute zero rates at time indicated by dates
%
% INPUT:
% dates:        set of the dates
% discounts:    discount factor B(0,dates) 
%
% OUTPUT:
% zRates:       zero rates at time ti (in percentage unit, e.g. 2.13 stands for 2.13%)

% date of today is the first one
setDate=dates(1);

% compute the dates with convention act/365 for zRates
dates_yf=yearfrac(setDate, dates,3);
zRates=-1./dates_yf .*log(discounts)*100;
zRates(dates_yf==0)=0; % the zrate today is 0

zRates = zRates./100;

end