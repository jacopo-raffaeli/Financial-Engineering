function [FTD_fee, FTD_fee_std_dev] = FTD_Price(FTD_settlement_date, datesDF, discounts, datesCDS, datesCDS_int, ISP_CDS_spreads, UCG_CDS_spreads, ISP_recovery, UCG_recovery, rho, N)
% Compute the price of a First To Defaut (FTD) considering UCG and ISP as 
% observed obligors 
 
% INPUT 
%
% FTD_settlement_date:      Settlement date of the FTD contract
% datesDF:                  Dates of the discount factors
% discounts
% datesCDS:                 Dates of the swaps in the CDS
% datesCDS_int:             Dates of the swaps in the CDS (only the ones 
%                           given by the assignemnt) used in the spline
%                           interpolation to get a complete set of spreads
% ISP_CDS_spreads           ISP CDS spreads values in datesCDS (only the
%                           one given by the assignment) used in the spline
%                           interpolation
% UCG_CDS_spreads           UCG CDS spreads values in datesCDS (only the
%                           one given by the assignment) used in the spline
%                           interpolation
% ISP_recovery              ISP recovery value
% UCG_recovery              UCG recovery value
% rho                       Correlation factor of ISP and UCG
% N:                        Number of standard gaussian simulation

% OUTPUT
%
% FTD_fee                   Fee of the first to default contract (expressed
%                           in bp).
% FTD_fee_std_dev           Standard deviation for the FTD fee (expressed
%                           in %)

% For 1yr (19 feb 09) we got no data in discounts, as usual we proceed to
% interpolate it from the other avaiable data
formatData='dd/mm/yyyy'; 
date_one_year = "19/02/2009";
date_one_year = datenum(date_one_year, formatData);
discount_1yr = interp1(datesDF, discounts, date_one_year);

% ismember generate a vector with logical value 1 if the elements of the 
% vector datesDF that are contained in datesCDS and 0 otherwise.
% find retrieve the indeces of the vector with logical value 1.
% In this way we are able to find the indeces of all the discount factor 
% dates that are also CDS dates, they are the same indeces of the
% discount factors we are interested in.
index = find(ismember(datesDF,datesCDS));
discountsCDS = [discount_1yr; discounts(index)];

% Since we will using MC methods we set a seed for the pseudo-random number
% generator so that we will obtain always the same realizations from the
% draws, rng will affect both rand and randn.
rng default;

% Covariance matrix of ISP and UCG
A = [1  , rho;
     rho, 1  ];

% In order to apply the Li model we need a vector u distributed according
% to the specified gaussian copula

% Compute N simulations of the standard gaussian random variable
y = randn(2,N);

% Compute N simulations of the correlated gaussian variable with zero mean
% and covariance matrix obtained via choleski factorization
mu = zeros(2,1);
E = chol(A);
x = mu + E*y;

% Compute N simulations of u distributed according to the gaussian copula
u = normcdf(x)';

% At this point, from a theoretic point of view, we should invert the
% marginal survival probability functions to compute the default times tao 
% for both the obligors. 
% However we do not have an analytic formula for the survival probability 
% functions, then, we use a complete set of survival probabilities from 1yr 
% up to 50yr both for ISP and UCG obtained from the function "bootstrapCDS"
% written in "2.Case Study: CDS Bootstrap" to operate an interpolation.
% The spreads for the ISP and UCG CDS contracts are computed by the 
% function "spline" used in "2.a" and "3.a" 
ISP_spreadsCDS = spline(datesCDS_int, ISP_CDS_spreads, datesCDS);
UCG_spreadsCDS = spline(datesCDS_int, UCG_CDS_spreads, datesCDS);
[~, ISP_survProbs, ~] = bootstrapCDS_approx(datesDF, discounts, datesCDS, ISP_spreadsCDS, ISP_recovery);
[~, UCG_survProbs, ~] = bootstrapCDS_approx(datesDF, discounts, datesCDS, UCG_spreadsCDS, UCG_recovery);


% Compute the default time for both ISP and UCG via an extrapolation
% using the survival probabilities values as x-axis and the time as y-axis
% The query points are the vectors of probabilities u(1,:), u(2,:) computed 
% according to the gaussian copula.
ISP_tao = interp1(ISP_survProbs, datesCDS, u(:,1), 'linear', 'extrap');
UCG_tao = interp1(UCG_survProbs, datesCDS, u(:,2), 'linear', 'extrap');
ISP_tao = floor(ISP_tao);
UCG_tao = floor(UCG_tao);

% Compute the year fraction for the CDS using convention 2 = actual/360
delta2 = yearfrac([FTD_settlement_date; datesCDS(1:end-1)], datesCDS(1:end), 2);

% Compute the value of the CDS spread for each simulations of the default
% time using the data of the obligor linked to the minimum default time
s = [];
for i=1:N
    if ((min(ISP_tao(i), UCG_tao(i)) > datesCDS(1)) && (min(ISP_tao(i), UCG_tao(i)) <= datesCDS(end)))
        if(ISP_tao(i) < UCG_tao(i))
            indicator = ([ISP_tao(i) > [FTD_settlement_date; datesCDS(1:end)]])';
            s(i) = ((1-ISP_recovery)*sum(discountsCDS.*(indicator(1:end-1)'-indicator(2:end)')))/sum(delta2.*discountsCDS.*[ISP_tao(i) > datesCDS]);
        else
            indicator = ([ISP_tao(i) > [FTD_settlement_date; datesCDS(1:end)]])';
            s(i) = ((1-UCG_recovery)*sum(discountsCDS.*(indicator(1:end-1)'-indicator(2:end)')))/sum(delta2.*discountsCDS.*[UCG_tao(i) > datesCDS]);
        end
    end
end


% Compute the mean of all the CDS spreads evaluated above to define the 
% approximation for the fair price (i.e. the fee) of the First To Default
% contract.
FTD_fee = mean(s)*1e4;
FTD_fee_std_dev = std(s)*1e2;

end

