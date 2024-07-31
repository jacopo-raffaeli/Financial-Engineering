function db_coarse_grained = course_grained_bucket_sens(cg_buckets, datesSet,ratesSet, N, structured_leg_dates, maturities, strikes, flat_vol, maturity, ttm, delta_t, parameters, upfront)
% Compute coarse grained delta-bucket sensitivities, as a difference beetween the new
% upfront obtained with the uptdated vol surface and the old one
%
% INPUT
% cg_buckets:           buckets of interest (2y 5y 10y 15y 20y)
% datesSet:             struct of the dates of market Data
% ratesSet:             struct of the rates of market Data
% N:                    number of caplets per year
% structured_leg_dates: structured leg settlement date & payment dates
% maturities:           swap maturities ( [(1:10) 12 15 20 25 30]' )
% strikes:              strikes from  eur3m cap flat-vol current
% flat_vol:             matrix of cap flat-volatilities
% maturity:             structured leg maturity
% ttm:                  year fraction between settlement dates and structured_leg_dates
% delta_t:              time intervals between consecutive dates in structured_leg_dates
% parameters:           "limits" of couponds payed by Party B
% upfront:              upfront value 
%
% OUTPUT
% db_coarse_grained:    coarse grained delta-bucket sensitivities

% define the parallel curve shift
curve_shift = 1e-4;
Act360 = 2;

% inizialize the delta-bucket sensitivities vector
db_coarse_grained = [];

l = length(cg_buckets)-1;

for ii = 1:l

    ratesSet_jolly = ratesSet;

    if ii == 1
        ratesSet_jolly.depos = ratesSet.depos + curve_shift;
        ratesSet_jolly.futures = ratesSet.futures + curve_shift;
    end
    
    ratesSet_jolly.swaps = ratesSet.swaps + curve_shift.*Weights(ii, cg_buckets, datesSet,0);
    
    [datesSet_complete, ratesSet_complete] = complete_set(datesSet, ratesSet_jolly);
    [dates, discounts_new] = bootstrap(datesSet_complete, ratesSet_complete);

    % Spot discounts on the settlement date & payment dates
    zRates_new = zeroRates(dates,discounts_new);
    discount_spot_new = exp(-interp1(dates,zRates_new,structured_leg_dates).*yearfrac(datesSet.settlement,structured_leg_dates,Act360));
    
    % Forward Libor rates on the payment dates
    discount_fwd_new = discount_spot_new(2:end)./discount_spot_new(1:end-1);
    libor_fwd_new = (1./delta_t).*((1./discount_fwd_new) - 1);
    
    % Bootstrap the spot volatility surface
    spot_vol_surf_new = Spot_volatility_surface(maturities, strikes, flat_vol, structured_leg_dates, maturity, N, ttm, delta_t, libor_fwd_new, discounts_new);
    
    upfront_new = upfront_value(parameters, delta_t, ttm(2:end), strikes, spot_vol_surf_new, discounts_new, libor_fwd_new);
    
    db_coarse_grained = [db_coarse_grained; upfront_new - upfront];

end

end