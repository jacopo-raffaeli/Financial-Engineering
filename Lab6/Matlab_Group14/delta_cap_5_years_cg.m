function delta_cap_5y = delta_cap_5_years_cg(maturities, strikes, flat_vol, structured_leg_dates, maturity, N, ttm, delta_t, L, discounts, strike_5y, spot_vol_surf, ratesSet, datesSet, flag, buckets)
% Compute the delta sensitivity of the 5 year cap as the difference between
% the 5y cap obtained with a shift of 1bp on the rates and the original one
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
% flag:                 1 coarsed grained bucket at 2y
%                       2 coarsed grained bucket at 5y          
% buckets:              buckets vector
%
% OUTPUT
% delta_cap_5y:         delta of the 5y cap


% define the parallel curve shift
curve_shift = 1e-4;
Act360 = 2;

ratesSet.depos = ratesSet.depos + curve_shift;
ratesSet.futures = ratesSet.futures + curve_shift;

w = Weights(flag, buckets, datesSet, 0);
w(buckets(flag+1)+1:end) = 0;
ratesSet.swaps = ratesSet.swaps + curve_shift.*w;

[datesSet_complete, ratesSet_complete] = complete_set(datesSet, ratesSet);
[dates, discounts_new] = bootstrap(datesSet_complete, ratesSet_complete);
  
% Spot discounts on the settlement date & payment dates
zRates_new = zeroRates(dates,discounts_new);
discount_spot_new = exp(-interp1(dates,zRates_new,structured_leg_dates).*yearfrac(datesSet.settlement,structured_leg_dates,Act360));
% Forward Libor rates on the payment dates
discount_fwd_new = discount_spot_new(2:end)./discount_spot_new(1:end-1);
libor_fwd_new = (1./delta_t).*((1./discount_fwd_new) - 1);

% Bootstrap the spot volatility surface
spot_vol_surf_new = Spot_volatility_surface(maturities, strikes, flat_vol, structured_leg_dates, maturity, N, ttm, delta_t, libor_fwd_new, discounts_new);

spot_vol_5y = spline(strikes,spot_vol_surf,strike_5y)./100;
spot_vol_5y_new = spline(strikes,spot_vol_surf_new,strike_5y)./100;

cap5y = Bachelier_Cap(ttm(3:21), delta_t(2:20), discounts(3:21), L(2:20), strike_5y, spot_vol_5y(2:20));
cap5y_new = Bachelier_Cap(ttm(3:21), delta_t(2:20), discounts_new(3:21), libor_fwd_new(2:20), strike_5y, spot_vol_5y_new(2:20));

delta_cap_5y = cap5y_new - cap5y;


end