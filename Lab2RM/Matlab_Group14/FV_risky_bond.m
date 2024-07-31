function FV = FV_risky_bond(cf_schedule, Q, ZC_curve, Recovery)
% Calculate the forward value of the bond under each simulated rating in a year's time
    
% INPUT:
% cf_schedule:        Cash flow schedule for the IG bond over 2 years
% Q:                        Transition matrix (issuer's rating transition 
%                           probabilities)
% ZC_curve:                 Zero-coupon yield curve
% Recovery:                 Recovery rate for the bond

% OUTPUT
% FV
    
% Compute the ZC_curve values for 1yr, 1yr6m, 2yr via bootstrap and the 
% relative discounts
ZC_curve_cf_schedule = interp1(ZC_curve(:,1), ZC_curve(:,2), cf_schedule(2:4,1));
discounts = exp(-ZC_curve_cf_schedule.*cf_schedule(2:4,1));

% Compute the forward discounts from 1 yr to 1yr6m and 2yr 
fw_discounts = discounts(2:3)./discounts(1);

% Compute hazard rates from 1 yr to 1yr6m and 2yr survival probabilities for 
% IG and HY grade bonds
h = -log(1-Q(1:2,3));
T = [1.5, 2] - 1; 
survProbs_1yr6m = exp(-h.*T(1));
survProbs_2yr = exp(-h.*T(2));

% Compute the 1yr to 1yr6m for IG and HY grade bonds and the transition
% probability from IG to HY and viceversa from 1yr6m and 2yr
defProbs_1yr6m = 1-survProbs_1yr6m;
transProbs_1yr6m_2yr = survProbs_1yr6m - survProbs_2yr;

% Compute the forward values at 1yr
FV = zeros(3,1);
% FV IG bond
FV(1) = sum([survProbs_1yr6m(1); survProbs_2yr(1)].*(cf_schedule(3:4,2).*fw_discounts)) + 100*Recovery*sum([defProbs_1yr6m(1); transProbs_1yr6m_2yr(1)].*fw_discounts);
% FV HY bond
FV(2) = sum([survProbs_1yr6m(2); survProbs_2yr(2)].*(cf_schedule(3:4,2).*fw_discounts)) + 100*Recovery*sum([defProbs_1yr6m(2); transProbs_1yr6m_2yr(2)].*fw_discounts);
% FV default
FV(3) = 100*Recovery;

end