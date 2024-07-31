function Price = Bachelier_Caplet(discount, L, delta_t, ttm, strike, volatility)
% Compute the price of a Caplet exploiting Bachelier formula
%
% INPUT
% discount:     discounts B(0,dates)
% L:            forward Libor rates on the payment dates
% delta_t:      time intervals between consecutive dates in structured_leg_dates
% ttm:          year fraction between settlement dates and structured_leg_dates
% strike:       strikes from  eur3m cap flat-vol current
% volatility:   spot volatility vector
%
% OUTPUT
%
% price_Cap:    Caplet price

dN = (L - strike)./(sqrt(ttm).*volatility);
N = normcdf(dN);
phi = normpdf(dN);
Price = delta_t.*discount.*((L - strike).*N + sqrt(ttm).*volatility.*phi);

end