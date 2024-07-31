function vega_cap_5y = vega_cap_5_years(maturities, strikes, flat_vol, structured_leg_dates, maturity, N, ttm, delta_t, L, discounts, strike_5y, spot_vol_surf)
% Compute the vega sensitivity of the 5 year cap as the difference between
% the 5y cap obtained with a shift of 1bp on the volatility surface and the original one
%
% INPUT
% maturities:           swap maturities ( [(1:10) 12 15 20 25 30]' )
% strikes:              strikes from  eur3m cap flat-vol current
% flat_vol:             matrix of cap flat-volatilities
% structured_leg_dates: structured leg settlement date & payment dates
% maturity:             structured leg maturity
% N:                    number of caplets per year
% ttm:                  year fraction between settlement dates and structured_leg_dates
% delta_t:              time intervals between consecutive dates in structured_leg_dates
% L:                    forward Libor rates on the payment dates
% discounts:            discount factor B(0,dates) 
% strike_5y:            strike ATM 5y (equal to mid rate swap 5y)                 
% spot_vol_surf:        spot volatilities surface
% ratesSet:             struct of the rates of market Data
% datesSet:             struct of the dates of market Data

% OUTPUT
% vega_cap_5y:          vega of the 5y cap

% define the parallel curve shift
curve_shift = 1e-2;

% Bootstrap the spot volatility surface
spot_vol_surf_new = Spot_volatility_surface(maturities, strikes, flat_vol + curve_shift, structured_leg_dates, maturity, N, ttm, delta_t, L, discounts);

% interpolating in strike_5y (query points)
spot_vol_5y = spline(strikes,spot_vol_surf,strike_5y)./100;
spot_vol_5y_new = spline(strikes,spot_vol_surf_new,strike_5y)./100;

% computing the cap at 5y
cap5y = Bachelier_Cap(ttm(3:21), delta_t(2:20), discounts(3:21), L(2:20), strike_5y, spot_vol_5y(2:20));
cap5y_new = Bachelier_Cap(ttm(3:21), delta_t(2:20), discounts(3:21), L(2:20), strike_5y, spot_vol_5y_new(2:20));

vega_cap_5y = cap5y_new - cap5y;

end