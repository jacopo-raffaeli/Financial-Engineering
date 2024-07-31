function delta = total_delta(datesSet,ratesSet, structured_leg_dates, maturities, strikes, flat_vol, maturity, ttm, delta_t, parameters, upfront)

curve_shift = 1e-4;

N = 4;

ratesSet.depos = ratesSet.depos + curve_shift;
ratesSet.futures = ratesSet.futures + curve_shift;
ratesSet.swaps = ratesSet.swaps + curve_shift;

[dates, discounts_new] = bootstrap(datesSet, ratesSet);

zRates_new = zeroRates(dates,discounts_new);
discount_spot_new = exp(-interp1(dates,zRates_new,structured_leg_dates).*yearfrac(datesSet.settlement,structured_leg_dates,2));
discount_fwd_new = discount_spot_new(2:end)./discount_spot_new(1:end-1);
libor_fwd_new = (1./delta_t).*((1./discount_fwd_new) - 1);

spot_vol_surf_new = Spot_volatility_surface(maturities, strikes, flat_vol, structured_leg_dates, maturity, N, ttm, delta_t, libor_fwd_new, discounts_new);

upfront_new = upfront_value(parameters, delta_t, ttm(2:end), strikes, spot_vol_surf_new, discounts_new, libor_fwd_new);

delta = upfront_new - upfront;

end