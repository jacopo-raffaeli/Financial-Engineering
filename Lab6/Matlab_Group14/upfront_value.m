function upfront = upfront_value(parameters, delta_t, TTM,  strikes, spot_vol_surf, discounts, libor_fwd)
% Compute the upfront value 
%
% INPUT
% parameters:       "limits" of couponds payed by Party B
% delta_t:          time intervals between consecutive dates in structured_leg_dates
% TTM:              year fraction between settlement dates and structured_leg_dates
% strikes:          strikes from  eur3m cap flat-vol current
% spot_vol_surf:    spot volatilities surface
% discounts:        discounts B(0,dates)    
% libor_fwd:        forward Libor rates on the payment dates
%
% OUTPUT
% upfront:          upfront value

strike_5y = parameters(1);
strike_10y = parameters(2);
strike_15y = parameters(3);
fixed_spread = parameters(4);

spot_vol_5y = spline(strikes,spot_vol_surf,strike_5y)./100;
spot_vol_10y = spline(strikes,spot_vol_surf,strike_10y)./100; 
spot_vol_15y = spline(strikes,spot_vol_surf,strike_15y)./100;

cap5y = Bachelier_Cap(TTM(2:20), delta_t(2:20), discounts(3:21), libor_fwd(2:20), strike_5y-fixed_spread, spot_vol_5y(2:20));
cap10y = Bachelier_Cap(TTM(21:40), delta_t(21:40), discounts(22:41), libor_fwd(21:40), strike_10y-fixed_spread, spot_vol_10y(21:40));
cap15y = Bachelier_Cap(TTM(41:end), delta_t(41:end), discounts(42:end), libor_fwd(41:end), strike_15y-fixed_spread, spot_vol_15y(41:end));

cap = cap5y + cap10y + cap15y;
cap = sum(cap);

eqn = @(x) x + 0.03*discounts(2).*delta_t(1) + fixed_spread*sum(discounts(3:end).*delta_t(2:end)) - cap + 1*discounts(3) - 1 - 0.02*sum(discounts(2:end).*delta_t);

upfront = fzero(eqn,0);

end