function course_grained_buckets_vega = course_grained_bucket_vega(cg_buckets, flat_dates, N, structured_leg_dates, maturities, strikes, flat_vol, maturity, ttm, delta_t, parameters, L, discounts, upfront)
% Compute coarse grained vega-bucket sensitivities, as a difference beetween the new
% upfront obtained with the uptdated vol surface and the old one
%
% INPUT
% cg_buckets:                   buckets of interest (2y 5y 10y 15y 20y)
% flat_dates                    dates flat volatilities
% N:                            number of caplets per year
% structured_leg_dates:         structured leg settlement date & payment dates
% maturities:                   swap maturities ( [(1:10) 12 15 20 25 30]' )
% strikes:                      strikes from  eur3m cap flat-vol current
% flat_vol:                     matrix of cap flat-volatilities
% maturity:                     structured leg maturity
% ttm:                          year fraction between settlement dates and structured_leg_dates
% delta_t:                      time intervals between consecutive dates in structured_leg_dates
% parameters:                   "limits" of couponds payed by Party B
% L:                            forward Libor rates on the payment dates
% discounts:                    discount factor B(0,dates) 
% upfront:                      upfront value 
%
% OUTPUT
% course_grained_buckets_vega:  coarse grained vega-bucket sensitivities


% define the parallel curve shift
curve_shift = 1e-2;

% inizialize the delta-bucket sensitivities vector
course_grained_buckets_vega = [];

l = length(cg_buckets)-1;

for ii = 1:l

    spot_vol_surf_new = Spot_volatility_surface(maturities, strikes, flat_vol + curve_shift.*Weights(ii, cg_buckets, flat_dates, 1), structured_leg_dates, maturity, N, ttm, delta_t, L, discounts);

    upfront_new = upfront_value(parameters, delta_t, ttm(2:end), strikes, spot_vol_surf_new, discounts, L);
    
    course_grained_buckets_vega = [course_grained_buckets_vega; upfront_new - upfront];

end

end