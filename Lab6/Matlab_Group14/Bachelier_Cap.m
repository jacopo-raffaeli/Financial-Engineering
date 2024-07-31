function price_Cap = Bachelier_Cap(ttm, delta_t, discounts, L, strike, volatility)
% Compute the price of a Cap exploiting Bachelier formula
%
% INPUT
% ttm:          year fraction between settlement dates and structured_leg_dates
% delta_t:      time intervals between consecutive dates in structured_leg_dates
% discounts:    discounts B(0,dates)
% L:            forward Libor rates on the payment dates
% strike:       strikes from  eur3m cap flat-vol current
% volatility:   spot volatility vector
%
% OUTPUT
% price_Cap:    Cap price

price_Cap = sum(Bachelier_Caplet(discounts, L, delta_t, ttm, strike, volatility));

end

