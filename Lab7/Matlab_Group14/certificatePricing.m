function upfront=certificatePricing(underlying,dates, discounts,certificate, parameters, M, flag)
% Compute the upfront X of a certificate with maturity 2 years

% INPUT
% underlying:      struct of the underlying     
% dates:           Vector with dates associated to discount factors
% discounts:       Vector of discounts
% certificate:     struct of the cerificate          
% parameters       struct containing: alpha, volatility, convexity, asimmetry 
% M:               number of Montecarlo simulations
% flag :           1 for NIG, 
%                  2 for Black, 
%                  3 for VG

% OUTPUT:
% upfront:         value of X

%%  parameters

% yearfrac formats
act360 = 2;
act365 = 3;
thirty360 = 6;

%F0 from assignment 5
F0=2.971827292548024e+03;

%discount factors at coupon payment dates: 
coupon_discount = find_discount(dates, discounts, certificate.Coupon_paymentDates); 

% Reset dates of the coupons:
reset_date = zeros(2,1);
reset_date(1,1) = certificate.Coupon_paymentDates(1) - 2;
reset_date(2,1) = certificate.maturity-2;

rng(48);

%time to maturity between reset date
ttm1 = yearfrac(certificate.setDate, reset_date(1,1), act365); 
ttm2 = yearfrac(reset_date(1,1),reset_date(2,1), act365);
ttmreset = [ttm1, ttm2];

%% compute probability

% simulate forward with different method
switch(flag)
    case 1 % NIG
        S = MCsimulation(F0, ttmreset, parameters(2),parameters(3),parameters(4),M);

    case 2  % Black Model
        vol = underlying.surface;
        K = underlying.strikes;
        S = Blacksimulation(F0, ttmreset, vol,certificate.strike,M,K);

    case 3 %VG
        S = VGsimulation(F0, ttmreset, parameters(2),parameters(3),parameters(4),M);
    otherwise
        disp('Error')
end

S_1Y = S(:,1);
    
%probability for the coupon
prob_1Ycoupon = mean((S_1Y < certificate.strike));  
prob_2Ycoupon = mean((S_1Y >= certificate.strike));

%% NPV_tot=0

%disocunt, BPV and year fract if I have second coupon
floating_discounts = find_discount(dates, discounts, certificate.paymentDates);
delta3m=yearfrac(certificate.setDate,certificate.paymentDates(1),act360)';                   %delta between settlment and first spol payment date
delta = yearfrac(certificate.paymentDates(1:end-1),certificate.paymentDates(2:end),act360)'; %delta between spol payment dates 
delta= [delta3m, delta];
BPV = delta*floating_discounts;

%disocunt and year fract if I have first coupon
floating_discounts1 = floating_discounts(1:4);
delta1 = delta(1:4);
BPV1 = delta1*floating_discounts1;

%year fract for the coupon in 30/360
delta_c = yearfrac([certificate.setDate; certificate.Coupon_paymentDates(1:end-1)], certificate.Coupon_paymentDates, thirty360);

%spol 
NPV_spol = certificate.spol*BPV;
NPV_spol1 = certificate.spol*BPV1;

%libor
NPV_libor = 1 - floating_discounts(end);
NPV_libor1 = 1 - floating_discounts(4);


%compute NPV for two different case
NPV_1Ycoupon = NPV_spol1 + NPV_libor1 - coupon_discount(1)*certificate.coupon(1)*delta_c(1);
NPV_2Ycoupon = NPV_spol + NPV_libor - coupon_discount(2)*certificate.coupon(2)*delta_c(2);

% upfront via NPV_tot=0
upfront =  NPV_1Ycoupon*prob_1Ycoupon+  NPV_2Ycoupon*prob_2Ycoupon;

end