function vega_cap_15y = vega_cap_15_years(maturities, strikes, flat_vol, structured_leg_dates, maturity, N, ttm, delta_t, L, discounts, strike_15y, spot_vol_surf)
% Compute the vega sensitivity of the 15 year cap as the difference between
% the 15y cap obtained with a shift of 1bp on the volatility surface and the original one
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
% strike_15y:           strike ATM 15y (equal to mid rate swap 15y)                 
% spot_vol_surf:        spot volatilities surface
% ratesSet:             struct of the rates of market Data
% datesSet:             struct of the dates of market Data

% OUTPUT
% vega_cap_15y:          vega of the 15y cap

% define the parallel curve shift
curve_shift = 1e-2;

% Bootstrap the spot volatility surface
spot_vol_surf_new = Spot_volatility_surface(maturities, strikes, flat_vol + curve_shift, structured_leg_dates, maturity, N, ttm, delta_t, L, discounts);
    
% interpolating in strike_15y (query points)
spot_vol_15y = spline(strikes,spot_vol_surf,strike_15y)./100;
spot_vol_15y_new = spline(strikes,spot_vol_surf_new,strike_15y)./100;

% computing the cap at 15y
cap15y = Bachelier_Cap(ttm(3:end), delta_t(2:end), discounts(3:end), L(2:end), strike_15y, spot_vol_15y(2:end));
cap15y_new = Bachelier_Cap(ttm(3:end), delta_t(2:end), discounts(3:end), L(2:end), strike_15y, spot_vol_15y_new(2:end));

vega_cap_15y = cap15y_new - cap15y;

end