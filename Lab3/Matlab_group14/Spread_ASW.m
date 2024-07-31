function spread_asw = Spread_ASW(face_value, defaultable_price, coupons, discounts, settlement_date, coupon_dates)
% Compute the Asset Swap Spread Over Euribor3m for an asset swap package
% based on a defaultable bond with annual coupon equal paid on the same
% swap dates.

% INPUT 
%
% face_value:                  Bond face value
% defaultable_price:           Defaultable bond price (The one actually 
%                              present in the asset swap package)
% coupons
% discounts:                   Discounts obtained from the bootstrap
%                              in the coupon dates
% settlement_date
% coupon_dates


% OUTPUT
%
% spread_asw                      

% Compute the year fraction using the convention 1 = 30/360 
delta = yearfrac([settlement_date; coupon_dates(1:end-1)], coupon_dates(1:end), 1);

% Compute the price of the risk-free coupon (same parameters of the defaultable
% one without taking into account credit risk)
risk_free_price = face_value*(sum(coupons.*delta.*discounts) + discounts(3));

% Compute the BPV using the same delta (the assignment specify that the dates 
% of the fee leg and the fixed leg are the same)
BPV = sum(delta.*discounts);

% Compute the spread over the asset swap
spread_asw = ((risk_free_price - defaultable_price)/BPV);

end

