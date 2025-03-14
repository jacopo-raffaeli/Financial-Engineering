% runAssignment6
% group 14, AY2023-2024
% Idda, Raffaeli, Riondato, Stillo

clear;
close all;
clc;

%% Settings
formatData='dd/mm/yyyy'; %Pay attention to your computer settings 

%% Read market data
filename='MktData_CurveBootstrap_20-2-24';

if ispc()   % Windows version
    [datesSet, ratesSet] = readExcelData(filename, formatData);
else        % MacOS version
    [datesSet, ratesSet] = readExcelDataMacOS(filename);
end

% Create the complete set of swap dates and rates
[datesSet_complete, ratesSet_complete] = complete_set(datesSet, ratesSet);

%% PARAMETERS
Act360 = 2;
Act365 = 3;

%% POINT A.
% Bootstrap to compute all discounts
[dates, discounts] = bootstrap(datesSet_complete, ratesSet_complete);

% plot the discounts and zero rates
zRates = zeroRates(dates, discounts)*100;
dates_representation = datetime(dates, 'ConvertFrom', 'datenum');
figure;
plot(dates_representation, discounts, 'color', [0, 0.75, 0], LineWidth=1, Marker= '^');
dateformat = 'dd/MM/yyyy';
xtickformat(dateformat);
xlabel('dates');
ylabel('discounts');
title('Boostrap Discounts and Zero rates');

yyaxis right;
plot(dates_representation, zRates, 'color', [0, 0, 0.75], LineWidth=1, Marker= 'diamond');
ylabel('ZeroRates', 'Color', 'black');
ytickformat('percentage');

xtickangle(45);

ax = gca; 
ax.YAxis(1).Color = 'black';
ax.YAxis(2).Color = 'black'; 

grid on;
legend('disocunts', 'zero rates');

%% POINT B.

% Read the data from the excel file
maturities = [(1:10) 12 15 20 25 30]';
strikes = readmatrix('Caps_vol_20-2-24.xlsx', 'range', 'F1:R1')';
strikes = strikes./100;
flat_vol = readmatrix('Caps_vol_20-2-24.xlsx', 'range', 'F2:R17');
flat_vol = flat_vol./100;

% Set the quantities used in the bootstrap
% Structured leg maturity
maturity = 15;

% Structured leg settlement date & payment dates
structured_leg_dates = finddates(datesSet_complete.settlement, 0:3:(maturity*12),1)';

% Spot discounts on the settlement date & payment dates
zRates = zeroRates(dates,discounts);
ttm = yearfrac(datesSet_complete.settlement,structured_leg_dates,Act365);
discount_spot = exp(-interp1(dates,zRates,structured_leg_dates).*yearfrac(datesSet_complete.settlement,structured_leg_dates,Act360));

% Forward Libor rates on the payment dates
discount_fwd = discount_spot(2:end)./discount_spot(1:end-1);
delta_t =  yearfrac(structured_leg_dates(1:end-1),structured_leg_dates(2:end),Act360);
libor_fwd = (1./delta_t).*((1./discount_fwd) - 1);

% Number of caplets per year
N = 4;

% Bootstrap the spot volatility surface
spot_vol_surf = Spot_volatility_surface(maturities, strikes, flat_vol, structured_leg_dates, maturity, N, ttm, delta_t, libor_fwd, discounts);

% Plot the flat volatility surface
[X, Y] = meshgrid(strikes, maturities);
figure(1);
surf(X, Y, flat_vol([1, 3:end], :));
title('Flat volatility surface');
xlabel('Strikes');
ylabel('Maturities');
zlabel('Flat Volatility');

% Plot the spot volatility surface
[X, Y] = meshgrid(strikes, structured_leg_dates(2:end));
figure;
surf(X, Y, spot_vol_surf);
title('Spot volatility surface');
xlabel('Strikes');
ylabel('Dates');
zlabel('Spot Volatility');
view(3);

% Compute the upfront
parameters = [0.043, 0.046, 0.051, 0.011];
upfront = upfront_value(parameters, delta_t, ttm(2:end), strikes, spot_vol_surf, discounts, libor_fwd)

%% POINT C.
% Compute Delta-bucket sensistivities
tic
db = delta_bucket_sens(datesSet,ratesSet, N, structured_leg_dates, maturities, strikes, flat_vol, maturity, ttm, delta_t, parameters, upfront);
toc

%% POINT D.
% Compute vega
vega = total_vega(structured_leg_dates, N, maturities, strikes, flat_vol, maturity, ttm, delta_t, parameters, upfront, discounts, libor_fwd)

%% POINT E.
% Compute Vega-bucket sensitivities
tic
dv = vega_bucket(structured_leg_dates, N, maturities, strikes, flat_vol, maturity, ttm, delta_t, parameters, libor_fwd, discounts, upfront);
toc

%% POINT F.
%Compute Delta couse-grained bucket sensitivities
cg_buckets = [0 2 5 10 15];
db_course_grained = course_grained_bucket_sens(cg_buckets, datesSet,ratesSet, N, structured_leg_dates, maturities, strikes, flat_vol, maturity, ttm, delta_t, parameters, upfront);

DV01_2y = DV01_swap_cg(datesSet, ratesSet, structured_leg_dates(2:9), discounts, cg_buckets, 1);
DV01_5y = DV01_swap_cg(datesSet, ratesSet, structured_leg_dates(2:21), discounts, cg_buckets, 2);
DV01_10y = DV01_swap_cg(datesSet, ratesSet, structured_leg_dates(2:41), discounts, cg_buckets, 3);
DV01_15y = DV01_swap_cg(datesSet, ratesSet, structured_leg_dates(2:end), discounts, cg_buckets, 4);

Notional = 50e6;
eqn_15y = @(x) x*DV01_15y + Notional*db_course_grained(4);
N_15y = fzero(eqn_15y, 0);
eqn_10y = @(x) x*DV01_10y + N_15y*DV01_15y + Notional*db_course_grained(3);
N_10y = fzero(eqn_10y, 0);
eqn_5y = @(x) x*DV01_5y + N_10y*DV01_10y + N_15y*DV01_15y + Notional*db_course_grained(2);
N_5y = fzero(eqn_5y, 0);
eqn_2y = @(x) x*DV01_2y + N_5y*DV01_5y + N_10y*DV01_10y + N_15y*DV01_15y + Notional*db_course_grained(1);
N_2y = fzero(eqn_2y, 0);

%% POINT G.
% First we hedge the vega
strike_5y = mean(ratesSet.swaps(5,:));
vega_cap_5y = vega_cap_5_years(maturities, strikes, flat_vol, structured_leg_dates, maturity, N, ttm, delta_t, libor_fwd, discounts, strike_5y, spot_vol_surf);
N_cap_5y = -Notional*vega/vega_cap_5y;

% Repeat the same we did in point e.
delta_cap_5y_cg_2y = delta_cap_5_years_cg(maturities, strikes, flat_vol, structured_leg_dates, maturity, N, ttm, delta_t, libor_fwd, discounts, strike_5y, spot_vol_surf, ratesSet, datesSet,1, cg_buckets);
delta_cap_5y_cg_5y = delta_cap_5_years_cg(maturities, strikes, flat_vol, structured_leg_dates, maturity, N, ttm, delta_t, libor_fwd, discounts, strike_5y, spot_vol_surf, ratesSet, datesSet,2, cg_buckets);

eqn2_15y = @(x) x*DV01_15y + Notional*db_course_grained(4);
N2_15y = fzero(eqn2_15y, 0);
eqn2_10y = @(x) x*DV01_10y + N2_15y*DV01_15y + Notional*db_course_grained(3);
N2_10y = fzero(eqn2_10y, 0);
eqn2_5y = @(x) x*DV01_5y + N2_10y*DV01_10y + N2_15y*DV01_15y + Notional*db_course_grained(2) + N_cap_5y*delta_cap_5y_cg_5y;
N2_5y = fzero(eqn2_5y, 0);
eqn2_2y = @(x) x*DV01_2y + N2_5y*DV01_5y + N2_10y*DV01_10y + N2_15y*DV01_15y + Notional*db_course_grained(1) + N_cap_5y*delta_cap_5y_cg_2y;
N2_2y = fzero(eqn2_2y, 0);

%% POINT H.
% course-grained bucket vega
cg_buckets = [0 5 15];

filename='Caps_vol_20-2-24.xlsx';

if ispc()   % Windows version
    [~, fd] = xlsread(filename, 1, 'B20:B35');
else        % MacOS version
    [~, fd] = readExcelDataMacOS(filename);
end

flat_dates = datenum(fd, formatData);
course_grained_buckets_vega = course_grained_bucket_vega(cg_buckets, flat_dates, N, structured_leg_dates, maturities, strikes, flat_vol, maturity, ttm, delta_t, parameters, libor_fwd, discounts, upfront);

strike_15y = mean(ratesSet.swaps(13,:));
vega_cap_15y = vega_cap_15_years(maturities, strikes, flat_vol, structured_leg_dates, maturity, N, ttm, delta_t, libor_fwd, discounts, strike_5y, spot_vol_surf);

eqn3_15y = @(x) x*vega_cap_15y + Notional*course_grained_buckets_vega(2);
N3_15y = fzero(eqn3_15y, 0);
eqn3_5y = @(x) x*vega_cap_5y + N3_15y*vega_cap_15y + Notional*course_grained_buckets_vega(1);
N3_5y = fzero(eqn3_5y, 0);