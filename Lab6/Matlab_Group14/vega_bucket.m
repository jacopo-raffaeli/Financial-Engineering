function dv = vega_bucket(structured_leg_dates, N, maturities, strikes, flat_vol, maturity, ttm, delta_t, parameters, libor_fwd, discounts, upfront)
% Compute the delta-bucket sensitivities, shifting of 1bp the flat
% volatility for each bucket
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
% libor_fwd:            forward Libor rates on the payment dates
% discounts:            discount factor B(0,dates) 
% upfront:              upfront value 
%
% OUTPUT
% dv:                   vega-bucket sensitivities

% define the parallel curve shift
curve_shift = 1e-2;

% inizialize the delta-bucket sensitivities vector
l = size(flat_vol);
dv = zeros(l);

for ii = 1:l(1)
    for jj = 1:l(2)
        flat_vol_jolly = flat_vol;
        flat_vol_jolly(ii, jj) = flat_vol_jolly(ii, jj) + curve_shift;
        
        spot_vol_surf_new = Spot_volatility_surface(maturities, strikes, flat_vol_jolly, structured_leg_dates, maturity, N, ttm, delta_t, libor_fwd, discounts);
    
        upfront_new = upfront_value(parameters, delta_t, ttm(2:end), strikes, spot_vol_surf_new, discounts, libor_fwd);
    
        dv(ii,jj) = upfront_new - upfront;
    end

end

end