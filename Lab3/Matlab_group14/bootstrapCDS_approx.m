function [datesCDS, survProbs, intensities] = bootstrapCDS_approx(datesDF, discounts, datesCDS, spreadsCDS, recovery)
% Compute the survival probabilities and the intensities from the CDS
% spreads values neglecting the accrual term
 
% INPUT 
%
% datesDF:                  Dates of the discount factors
% discounts
% datesCDS:                 Dates of the CDS spreads (from 1yr up to 50yr)
% spreadsCDS:               Spread values in the given dates 
% recovery:                 recovery value for the obligor

% OUTPUT
%
% datesCDS:                 Dates of the CDS spreads (from 1yr up to 50yr)
% survProbs:                Survival probabilities 
% intensities

% Select only the needed discount factor in discounts (i.e. the ones from
% 1yr up to 7yr)

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

% Compute the year fraction using the convention 1 = 30/360 
delta1 = yearfrac([datesDF(1); datesCDS(1:end-1)], datesCDS(1:end), 1);

% Compute the year fraction using the convention 3 = ACT/365 
delta3 = yearfrac([datesDF(1); datesCDS(1:end-1)], datesCDS(1:end), 1);

% Compute the Loss Given Default (LGD)
LGD = 1 - recovery;

% Initialize survProbs
survProbs = zeros(1, length(datesCDS));

% Set up the options for fsolve, with some experiments we found out the one
% here are the better options
options = optimoptions(@fsolve, 'Algorithm', 'levenberg-marquardt','Display', 'off');

% Compute the first value outside the loop
eqn = @(x) spreadsCDS(1)*delta1(1)*discountsCDS(1)*x - LGD*discounts(1)*(1 - x);
survProbs(1) = fsolve(eqn, 1, options);

% Compute the following values with a loop (necessary since each iteration
% uses the values computed in the previous one)
for i=2:length(datesCDS)
    eqn = @(x) spreadsCDS(i)*sum(delta1(1:i).*discountsCDS(1:i).*[survProbs(1:i-1), x]) - LGD*sum(discountsCDS(1:i).*([1, survProbs(1:i-1)] - [survProbs(1:i-1), x]));
    survProbs(i) = fsolve(eqn, survProbs(i-1), options);
end

% Convert survProbs to column vector
survProbs = survProbs';

% Compute the piecewise intensities from 1yr up to 50yr
intensities = -(log(survProbs./[1; survProbs(1:end-1)])./(delta3));

end

