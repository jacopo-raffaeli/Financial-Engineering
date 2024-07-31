function vega = total_vega(structured_leg_dates, N, maturities, strikes, flat_vol, maturity, ttm, delta_t, parameters, upfront, discounts, L)
% Compute the total vega of the certificate
%
% INPUT
% structured_leg_dates: structured leg settlement date & payment dates
% N:                    number of caplets per year
% maturities:           swap maturities ( [(1:10) 12 15 20 25 30]' )
% strikes:              strikes from  eur3m cap flat-vol current
% flat_vol:             matrix of cap flat-volatilities
% maturity:             structured leg maturity
% ttm:                  year fraction between settlement dates and structured_leg_dates
% delta_t:              time intervals between consecutive dates in structured_leg_dates
% parameters:           "limits" of couponds payed by Party B
% upfront:              upfront value 
% discounts:            discount factor B(0,dates) 
% L:                    forward Libor rates on the payment dates
%
% OUTPUT
% vega:                 total vega

% define the parallel curve shift
curve_shift = 1e-2;

% Bootstrap the spot volatility surface
spot_vol_surf_new = Spot_volatility_surface(maturities, strikes, flat_vol + curve_shift, structured_leg_dates, maturity, N, ttm, delta_t, L, discounts);
    
upfront_new = upfront_value(parameters, delta_t, ttm(2:end), strikes, spot_vol_surf_new, discounts, L);
    
vega = upfront_new - upfront;

end