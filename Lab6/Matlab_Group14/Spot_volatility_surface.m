function spot_vol_surf = Spot_volatility_surface(maturities, strikes, flat_vol, dates, maturity, N, ttm, delta_t, libor, discounts)
% Compute the spot volatility surface
%
% INPUT
% maturities:       swap maturities ( [(1:10) 12 15 20 25 30]' )
% strikes:          strikes from  eur3m cap flat-vol current
% flat_vol:         matrix of cap flat-volatilities
% dates:            dates of the discount factors
% maturity:         structured leg maturity
% N:                number of caplets per year
% ttm:              year fraction between settlement dates and structured_leg_dates
% delta_t:          time intervals between consecutive dates in structured_leg_dates
% libor:            forward Libor rates on the payment dates
% discounts:        discounts B(0,dates)    
%
% OUTPUT
% spot_vol_surf:    spot volatilities surface 


% Parameters
Act365 = 3;

% Initialize spot volatility surface matrix
% Rows are structured leg payment dates
rows = length(dates(2:end));

% Columns are strike prices
columns = length(strikes);
spot_vol_surf = zeros(rows, columns);

% As discussed in class the spot volatility surface up to the first year
% is assumed to be equal to the flat one from the given matrix
i_Cap1 = N*maturities(1);
spot_vol_surf(1:i_Cap1,:) = [flat_vol(1,:); flat_vol(1,:); flat_vol(1,:); flat_vol(1,:)];

% Compute the Cap at 1yr with flat volatility at 1yr outside the loop
% The cap is evaluated in all the strikes
Cap1 = arrayfun(@(strike, volatility) Bachelier_Cap(ttm(2:i_Cap1+1), delta_t(1:i_Cap1), discounts(2:i_Cap1+1), libor(1:i_Cap1), strike, volatility), strikes, flat_vol(1,:)');

for i = 1:(find(maturity == maturities) - 1)

    % Number of caplets index for both the flat cap
    i_Cap1 = N*maturities(i);
    i_Cap2 = N*maturities(i+1);

    % Compute the Cap at (i+1)yr with flat volatility at (i+1)yr
    % The cap is evaluated in all the strikes
    Cap2 = arrayfun(@(strike, volatility) Bachelier_Cap(ttm(2:i_Cap2+1), delta_t(1:i_Cap2), discounts(2:i_Cap2+1), libor(1:i_Cap2), strike, volatility), strikes, flat_vol(i+1,:)');

    % Compute approximated difference between Cap at (i)yr and (i+1)yr
    % evaluated in flat volatilities
    dC_flat = Cap2 - Cap1;

    % In the next iteration the cap at (i+1)yr became the cap at (i)yr
    Cap1 = Cap2;

    % Define the linear constraints (equal to i_Cap2-1)
    sigma_lin_constr = @(sigma2, caplet_mat) spot_vol_surf(i_Cap1,:) + (yearfrac(dates(i_Cap1), caplet_mat, Act365)./yearfrac(dates(i_Cap1), dates(i_Cap2), Act365)).*(sigma2 - spot_vol_surf(i_Cap1,:));

    % Compute exact difference between Cap at (i)yr and (i+1)yr evaluated in spot volatilities 
    % (as unknown in function of the volatility of the last caplet in the period)
    jj = i_Cap1+1:i_Cap2;
    dC_spot_old = @(sigma2) 0;
    
    for j = 1:length(jj)
        dC_spot_new = @(sigma2) dC_spot_old(sigma2) + arrayfun(@(strike, volatility) Bachelier_Cap(ttm(jj(j)+1), delta_t(jj(j)), discounts(jj(j)+1), libor(jj(j)), strike, volatility), strikes, sigma_lin_constr(sigma2, dates(jj(j)+1))');
        dC_spot_old = dC_spot_new;
    end

    % Compute the spot volatility of the last caplet in the period
    dC = @(sigma2) dC_spot_new(sigma2) - dC_flat;
    spot_vol_surf(i_Cap2,:) = fsolve(dC, spot_vol_surf(i_Cap1,:), optimset('Display','off'));

    % Compute the spot volatilities of the other N-1 caplet in the period
    spot_vol_surf((i_Cap1+1:i_Cap2-1),:) = sigma_lin_constr(spot_vol_surf(i_Cap2,:), dates(i_Cap1+1:i_Cap2-1));  
end

end

