function  [datesCDS, survProbs, intensities] = bootstrapCDS(datesDF, discounts, datesCDS, spreadsCDS, recovery, flag)
% Compute the survival probabilities and the intensities from the CDS
% spreads values with the method given by flag
 
% INPUT 
%
% datesDF:                  Dates of the discount factors
% discounts
% datesCDS:                 Dates of the CDS spreads (from 1yr up to 50yr)
% spreadsCDS:               Spread values in the given dates 
% recovery:                 recovery value for the obligor
% flag:                     Choose how to compute the intensities:
%                           flag = 1 (approx);
%                           flag = 2 (exact);
%                           flag = 3 (JT).

% OUTPUT
%
% datesCDS:                 Dates of the CDS spreads (from 1yr up to 50yr)
% survProbs:                Survival probabilities 
% intensities

if flag ==1
    % Neglected accrual appoximation
    [datesCDS, survProbs, intensities] = bootstrapCDS_approx(datesDF, discounts, datesCDS, spreadsCDS, recovery);
elseif flag == 2
    % Exact computation
    [datesCDS, survProbs, intensities] = bootstrapCDS_exact(datesDF, discounts, datesCDS, spreadsCDS, recovery);
elseif flag == 3
    % JT approximation
    [datesCDS, survProbs, intensities] = bootstrapCDS_JT(datesDF, datesCDS, spreadsCDS, recovery);
else
    % Invalid flag value
    fp("Flag value not recognized.")
end

end

