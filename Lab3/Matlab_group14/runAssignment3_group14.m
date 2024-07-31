% runAssignment3
% group 14, AY2023-2024
% Computes Euribor 3m bootstrap with a single-curve model

clear all;
close all;
clc;
format long

%% Settings

% Pay attention to your computer settings 
formatData='dd/mm/yyyy'; 

%% Read market data

% This fuction works on Windows OS. Pay attention on other OS.
[datesSet, ratesSet] = readExcelData('MktData_CurveBootstrap', formatData);

%% Bootstrap

% Dates includes SettlementDate as first date
[dates, discounts]=bootstrap(datesSet, ratesSet);
dates = dates';
dates_prova = datetime(dates, 'ConvertFrom', 'datenum');
discounts = discounts';
% dates = [733457	733458	733464	733486	733578	733669	733759	733849	733942	734033	734123	734188	734555	734919	735284	735649	736014	736379	736746	737110	737475	737840	738206	738573	738937	739301	739667	740032	740397	740764	741128	741493	741858	742223	742591	742955	743319	743684	744050	744415	744782	745146	745511	745876	746241	746606	746973	747337	747702	748067	748433	748800	749164	749528	749894	750259	750624	750991	751355	751720]';
% discounts = [1	0.999888623517214	0.999209236912233	0.996664082261331	0.985787288679762	0.976098359658714	0.967330317778432	0.959004956004121	0.950673880764453	0.942511147414777	0.934315253691080	0.926896692820308	0.891615154298863	0.855991160357668	0.819887102250456	0.783753947849736	0.747802679174281	0.712370658334561	0.677733837362591	0.644300588496753	0.612067369281301	0.581075571118905	0.551910196834323	0.523911414705452	0.497608738242246	0.472734633348053	0.449181319307778	0.426979703564621	0.406057937301772	0.386237139098681	0.367748914548798	0.350230940948338	0.333730111995595	0.318190352118269	0.303476421796163	0.289725424325110	0.276758055288121	0.264486506795136	0.252892525297760	0.241917939429932	0.231457443987178	0.221615068927810	0.212275864257182	0.203383561872421	0.194938017971703	0.186912028676603	0.179261338851498	0.172016784331295	0.165095522740575	0.158494279473942	0.152194100045863	0.146143745438550	0.140413849852331	0.134942506207164	0.129706968854180	0.124707452538527	0.119936319551853	0.115359940640544	0.111044212801164	0.106903534131373]';

%% Compute the discount at 1 year via interpolation
date_one_year = "19/02/2009";
date_one_year = datenum(date_one_year, formatData);
discount_1yr = interp1(dates, discounts, date_one_year);

%% Parameters

% yearfrac convention
% 1 = 30/360 
% 2 = actual/360
% 3 = actual/365

% Parameters for the bond in the asset swap package
asw_face_value = 100;
asw_price = 101;
asw_coupons = 3.9*1e-2;
asw_discounts = [discount_1yr; discounts(12:13)];
% asw_settlment = dates(1);
asw_coupon_dates = [date_one_year; dates(12:13)];

% Parameters for the ISP CDS
ISP_recovery = 0.4;
ISP_CDS_spreads = [29; 32; 35; 39; 40; 41].*(1e-4);
% ISP_CDS_settlment = dates(1);

% Parameters for the UCG CDS
UCG_recovery = 0.45;
UCG_CDS_spreads = [34; 39; 45; 46; 47; 47].*(1e-4);
% UCG_CDS_settlment = dates(1);

% Other parameters
settlement_date = dates(1);
% Dates of the swaps in the CDS (only the ones given by the assignemnt) 
% used in the spline interpolation to get a complete set of spreads (both
% for ISP and UCG)
datesCDS_int = [date_one_year; dates(12:15); dates(17)];
% We interpret a complet set of dates as 1yr to 7yr
datesCDS = [date_one_year; dates(12:17)]
% Correlation factor
rho = 0.2;
% Settlemment date value expressed in the format dd/mm/yyyy
settlement_date_format = datetime(settlement_date, 'ConvertFrom', 'datenum');
% DateCDS values expressed in the format dd/mm/yyyy
datesCDS_format = datetime(datesCDS, 'ConvertFrom', 'datenum');

%% 1.Exercise: Asset Swap
% Compute the spread over the asset swap for the given parameters

spread_asw = Spread_ASW(asw_face_value, asw_price, asw_coupons, asw_discounts, settlement_date, asw_coupon_dates);
fprintf("The spread over the ASW is = %0.*f \n\n", 4, spread_asw);

%% 2.Case Study: CDS Bootstrap

%% 2.a
% Build a complete set of CDS via a spline interpolation on the spreads.

ISP_CDS_int_spreads = spline(datesCDS_int, ISP_CDS_spreads, datesCDS);
fprintf("The interpolated spread values (1yr-7yr) for the ISP CDS are =  \n");
for i=1:length(ISP_CDS_int_spreads)
    fprintf('  %s  \t  %0.*f  bp \n', datesCDS_format(i), 2, ISP_CDS_int_spreads(i)*1e4);
end
fprintf("\n")


%% 2.b
% Build λ(t) piecewise constant for the issuer, neglecting the "accrual" 
% term.

% Compute the survival probabilities and the intensities neglecting accrual
% term
% Set the approximated function
flag = 1;
[datesCDS, ISP_survProbs_approx, ISP_intensities_approx] = bootstrapCDS(dates, discounts, datesCDS, ISP_CDS_int_spreads, ISP_recovery, flag);

%% 2.c
% Which is the impact of the "accrual" term? Show that this term is really 
% negligible.

% Compute the survival probabilities and the intensities considering accrual
% term
% Set the exact function
flag = 2;
[datesCDS, ISP_survProbs_exact, ISP_intensities_exact] = bootstrapCDS(dates, discounts, datesCDS, ISP_CDS_int_spreads, ISP_recovery, flag);

% Comparison for the result of the approximated and the exact computation

% Numerical comparison of the survival probabilities by computing the
% absolute value of the differences and the norm2
ISP_survProbs_diff_approx_exact = abs(ISP_survProbs_exact - ISP_survProbs_approx);
ISP_survProbs_norm_approx_exact = norm(ISP_survProbs_diff_approx_exact);
fprintf("The value of the norm 2 for the approximated and exact survival probabilities is = %f \n\n", ISP_survProbs_norm_approx_exact);

% Numerical comparison of the intensities by computing the absolute value 
% of the differences and the norm2
ISP_intensities_diff_approx_exact = abs(ISP_intensities_exact - ISP_intensities_approx);
ISP_intensities_norm_approx_exact = norm(ISP_intensities_diff_approx_exact);
fprintf("The value of the norm 2 for the approximated and exact intensities is = %f \n\n", ISP_intensities_norm_approx_exact);

% Graphical comparison of the approximated and the exact computation

% Graphical comparison of the survival probabilities
figure(1);
plot(datesCDS_format, ISP_survProbs_exact, '-*',datesCDS_format, ISP_survProbs_approx, '-o')
title("Exact probabilities Vs Approximated probabilities")
legend("Exact", "Approximation", "Location", "southwest");
xlabel("Years");
ylabel("Survival probability");
x_range = [datesCDS_format(1)-50, datesCDS_format(end)];
xlim(x_range);

% Graphical comparison of the intensities

figure(2);
piecewise_dates = [settlement_date_format; repelem(datesCDS_format(1:end-1), 2); datesCDS_format(end)];
piecewise_values_exact = repelem(ISP_intensities_exact(1:end), 2);
piecewise_values_approx = repelem(ISP_intensities_approx(1:end), 2);
plot(piecewise_dates,  piecewise_values_exact, 'b-', piecewise_dates, piecewise_values_approx, 'r-');
title("Exact intensities Vs Approximated intensities")
legend("Exact", "Approximation", "Location", "southeast");
xlabel("Years");
ylabel("Intensity");
x_range = [settlement_date_format-50, datesCDS_format(end)];
xlim(x_range);


%% 2.d
% Consider Jarrow-Turnbull approximation (a constant λ and continuously 
% paid CDS spread) and compare the result with the one previously obtained.

% Compute the survival probabilities and the intensities using the JT
% approximation
% Set the JT function
flag = 3;
[datesCDS, ISP_survProbs_JT, ISP_intensities_JT] = bootstrapCDS(dates, discounts, datesCDS, ISP_CDS_int_spreads, ISP_recovery, flag);

% Comparison for the result of the JT approximated and the exact computation

% Numerical comparison of the survival probabilities by computing the
% absolute value of the differences
ISP_survProbs_diff_JT_exact = abs(ISP_survProbs_exact - ISP_survProbs_JT);
ISP_survProbs_norm_JT_exact = norm(ISP_survProbs_diff_JT_exact);
fprintf("The value of the norm 2 for the JT approximated and exact survival probabilities is = %f \n\n", ISP_survProbs_norm_JT_exact);

% Numerical comparison of the intensities by computing the absolute value 
% of the differences
ISP_intensities_diff_JT_exact = abs(ISP_intensities_exact - ISP_intensities_JT);
ISP_intensities_norm_JT_exact = norm(ISP_intensities_diff_JT_exact);
fprintf("The value of the norm 2 for the JT approximated and exact intensities is = %f \n\n", ISP_intensities_norm_JT_exact);

% Graphical comparison of the three type of computation

% Graphical comparison of the survival probabilities
figure(1);
plot(datesCDS_format, ISP_survProbs_exact, '-*',datesCDS_format, ISP_survProbs_JT, '-o')
title("Exact probabilities Vs JT probabilities")
legend("Exact", "JT", "Location", "southwest");
xlabel("Years");
ylabel("Survival probability");
x_range = [datesCDS_format(1)-50, datesCDS_format(end)];
xlim(x_range);

% Graphical comparison of the intensities
figure(2);
piecewise_dates = [settlement_date_format; repelem(datesCDS_format(1:end-1), 2); datesCDS_format(end)];
piecewise_values_exact = repelem(ISP_intensities_exact(1:end), 2);
piecewise_values_JT = repelem(ISP_intensities_JT(1:end), 2);
plot(piecewise_dates,  piecewise_values_exact, 'b-', piecewise_dates, piecewise_values_JT, 'r-');
title("Exact intensities Vs JT intensities")
legend("Exact", "JT", "Location", "southeast");
xlabel("Years");
ylabel("Intensity");
x_range = [settlement_date_format-50, datesCDS_format(end)];
xlim(x_range);

%% 3.Exercise: Price First to Default

%% 3.a
% Build a complete set of CDS via a spline interpolation on the spreads.

UCG_CDS_int_spreads = spline(datesCDS_int, UCG_CDS_spreads, datesCDS);
fprintf("The interpolated spread values (1yr-7yr) for the UCG CDS are =  \n");
for i=1:length(UCG_CDS_int_spreads)
    fprintf('  %s  \t  %0.*f  bp \n', datesCDS_format(i), 2, UCG_CDS_int_spreads(i)*1e4);
end
fprintf("\n")

%% 3.b
% Price a first to default with maturity 20th of February 2012 on the 
% obligors ISP and UCG with the Limodel considering a Gaussian copula and 
% correlation rho=0.2%.

% Set a number of simulations
N = 1000000;

% Compute the fee and its standard deviation for the FTD contract
[FTD_fee, FTD_fee_std_dev] = FTD_Price(settlement_date, dates, discounts, datesCDS, datesCDS_int, ISP_CDS_spreads, UCG_CDS_spreads, ISP_recovery, UCG_recovery, rho, N);
fprintf("The fee value for the FTD contract is = %0.*f bp \n\n", 2, FTD_fee);
fprintf("The fee value standard deviation is = %0.*f percent \n\n", 2, FTD_fee_std_dev);


%% 3.c
% Plot the First to default price w.r.t. different values of the 
% correlation rho. Does the correlation parameters impact the price 
% significantly?

rho_vector = [-0.9:0.1:0.9]';

% Compute the FTD fee for different rho values
for i=1:length(rho_vector)
    [FTD_fee(i), ~] = FTD_Price(settlement_date, dates, discounts, datesCDS, datesCDS_int, ISP_CDS_spreads, UCG_CDS_spreads, ISP_recovery, UCG_recovery, rho_vector(i), N);
end

figure;
plot(rho_vector, FTD_fee, '-o')
title("Rho Vs FTD-fee")
legend("FTD-fee(rho)", "Location", "southeast");
xlabel("Rho");
ylabel("Fee");