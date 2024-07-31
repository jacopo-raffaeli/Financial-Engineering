function R = R_IRB(PD)
% Regulatory correlation function determined by the issuer one-year PD 
% according to the IRB formula for large corporates

% INPUT
% PD:           Default probability

% OUTPUT
% R     

% Parameters (Given in the slides)
R_min = 0.12;
R_max = 0.24;
k = 50;

% Compute R using the large corporate formula
R = R_min*((1-exp(-k*PD))/(1-exp(-k))) + R_max*((exp(-k*PD))/(1-exp(-k)));

end

