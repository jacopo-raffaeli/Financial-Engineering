function [datesCDS, survProbs, intensities] = bootstrapCDS_JT(datesDF, datesCDS, spreadsCDS, recovery);
% Compute the survival probabilities and the intensities from the CDS
% spreas using the JT approximation 
 
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

% Compute the Loss Given Default (LGD)
LGD = 1 - recovery;

% Compute the year fraction using the convention 3 = ACT/365 
delta3 = yearfrac([datesDF(1); datesCDS(1:end-1)], datesCDS(1:end), 1);

% Compute the intensities using the JT approximation
intensities = spreadsCDS/LGD;

% Compute the survival probabilities from the intensities
survProbs = exp(-cumsum(intensities.*delta3));

end

