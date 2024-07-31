function upfront = certificatePricing_3Y(dates, discounts,certificate, parameters, M, flag)
% Compute the upfront X of a certificate with maturity 3 years

% INPUT   
% dates:           Vector with dates associated to discount factors
% discounts:       Vector of discounts
% certificate:     struct of the cerificate          
% parameters       struct containing: alpha, volatility, convexity, asimmetry 
% M:               number of Montecarlo simulations
% flag :           1 for NIG, 
%                  2 for VG 

% OUTPUT:
% upfront:         value of X

%%  parameters
% yearfrac formats
act360 = 2;
act365 = 3;
thirty360 = 6;

%F0 from assignment 5
F0=2.971827292548024e+03;

% discount factors at coupon payment dates
coupon_discount = find_discount(dates, discounts, certificate.Coupon_paymentDates); 

% reset dates of the coupons
reset_date = zeros(3,1);
reset_date(1,1) = certificate.Coupon_paymentDates(1) - 2;
reset_date(2,1) = certificate.Coupon_paymentDates(2) - 2;
reset_date(3,1) = certificate.Coupon_paymentDates(3) - 2;

rng(48);

% time to maturity between reset date
ttm1 = yearfrac(certificate.setDate, reset_date(1,1), act365); 
ttm2 = yearfrac(reset_date(1,1),reset_date(2,1), act365);
ttm3 = yearfrac(reset_date(2,1),reset_date(3,1), act365);
ttmreset = [ttm1, ttm2, ttm3];

%% compute probability

% simulate forward with different method
switch(flag)
    case 1 % NIG
        S = MCsimulation(F0, ttmreset, parameters(2),parameters(3),parameters(4),M);

    case 2 %VG
        S = VGsimulation(F0, ttmreset, parameters(2),parameters(3),parameters(4),M);
    otherwise
        disp('Error')
end

S_1Y = S(:,1);
S_2Y = S(:,2);
    
% probability for the coupon
%prob_1Ycoupon = mean((S_1Y < certificate.strike));
prob_1Ycoupon = mean((S_1Y < certificate.strike & S_2Y >= certificate.strike));
prob_2Ycoupon = mean((S_1Y >= certificate.strike & S_2Y < certificate.strike));
prob_1Y2Ycoupon = mean((S_1Y < certificate.strike & S_2Y < certificate.strike));
prob_3Ycoupon = mean((S_1Y >= certificate.strike & S_2Y >= certificate.strike));


%% NPV_tot=0

% disocunt, BPV and year fract if I have third coupon
floating_discounts = find_discount(dates, discounts, certificate.paymentDates);
delta3m=yearfrac(certificate.setDate,certificate.paymentDates(1),act360)';                   %delta between settlment and first spol payment date
delta = yearfrac(certificate.paymentDates(1:end-1),certificate.paymentDates(2:end),act360)'; %delta between spol payment dates 
delta= [delta3m, delta];
BPV = delta*floating_discounts;

% disocunt, BPV and year fract if I have first coupon
floating_discounts1 = floating_discounts(1:4);
delta1 = delta(1:4);
BPV1 = delta1*floating_discounts1;

% disocunt, BPV and year fract if I have second coupon
floating_discounts2 = floating_discounts(1:8);
delta2 = delta(1:8);
BPV2 = delta2*floating_discounts2;

% year fract for the coupon in 30/360
delta_c = yearfrac([certificate.setDate; certificate.Coupon_paymentDates(1:end-1)], certificate.Coupon_paymentDates, thirty360);

% spol 
NPV_spol = certificate.spol*BPV;
NPV_spol2 = certificate.spol*BPV2;

% libor
NPV_libor = 1 - floating_discounts(end);
NPV_libor2 = 1 - floating_discounts(8);


% compute NPV for two different case
NPV_1Ycoupon= NPV_spol2 + NPV_libor2 - coupon_discount(1)*certificate.coupon(1)*delta_c(1); 
NPV_2Ycoupon = NPV_spol2 + NPV_libor2 - coupon_discount(2)*certificate.coupon(2)*delta_c(2);
NPV_1Y2Ycoupon = NPV_spol2 + NPV_libor2 - coupon_discount(2)*certificate.coupon(2)*delta_c(2) - coupon_discount(1)*certificate.coupon(1)*delta_c(1);
NPV_3Ycoupon = NPV_spol + NPV_libor - coupon_discount(3)*certificate.coupon(3)*delta_c(3);

% upfront via NPV_tot=0
upfront =  NPV_1Ycoupon*prob_1Ycoupon + NPV_2Ycoupon* prob_2Ycoupon + NPV_1Y2Ycoupon* prob_1Y2Ycoupon + NPV_3Ycoupon*prob_3Ycoupon;

end