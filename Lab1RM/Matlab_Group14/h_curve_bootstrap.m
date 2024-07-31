function h_curve = h_curve_bootstrap(cf_schedule_1y, Bond_dirty_price_1y, cf_schedule_2y, Bond_dirty_price_2y, ZC_curve, R)
% Compute the hazard rate curves for IG and HY issuers assuming
% piece-wise constant hazard rate by inverting the pricing function for the
% bond dirty price (formula 13 in the slides)

% INPUT
%
% cf_schedule_1y:           Table of cash flows of corp. bonds with 
%                           XX rating and 1y maturity
% Bond_dirty_price_1y       Market bond dirty price of corp. bonds with XX 
%                           rating and 1y maturity
% cf_schedule_2y:           Table of cash flows of corp. bonds with 
%                           XX rating and 2y maturity
% Bond_dirty_price_2y       Market bond dirty price of corp. bonds with XX 
%                           rating and 2y maturity
% ZC_curve:                 Table of zero-coupon rates
% R:                        Recovery rate

% OUTPUT
%
% h_curve:                  Table of piece-wise hazard rates with XX rating

% options are used to hide the message displayed by fsolve in the command
% window
options = optimset('Display','off');

% Compute the risk-free discounts from the ZC rates and the respective
% maturities
T = ZC_curve(:,1);
B = [exp(-ZC_curve(:,2).*T)];

% Since it is not provided any market data for the ZC risk-free bond with 
% 1y maturity and 1.5yr we compute the missing ZC discount with a linear
% interpolation using the discount data already given
B_1yr     = ((T(3)-1)*B(2)+(1-T(2))*B(3))/(T(3)-T(2));
B_1yr6m   = ((T(3)-1.5)*B(2)+(1.5-T(2))*B(3))/(T(3)-T(2));

% Add the 1yr and 1.5yr discount to the discounts vector
% Add the 0yr discount (i.e 1)
% Delete the 0.25yr discount 
% Add the respective maturities
T = [0; T(2); 1; 1.5; T(3)];
B = [1; B(2); B_1yr; B_1yr6m; B(3)];

% Define an anonymous function for the bond dirty price (formula 13 in the slides)
% for a corp. bond with 1y maturity and XX rating, the 1yr hazard rate is
% taken as a variable h
fun_1yr = @(h) sum(cf_schedule_1y(:,2).*B(2:3).*exp(-h.*T(2:3))) + R*sum((exp(-h.*T(1:2))-exp(-h.*T(2:3))).*B(2:3)) - Bond_dirty_price_1y;
% Solve the function above with fsolve, we use 0 as initial data
h_1yr = fsolve(fun_1yr, 0, options);

% Define an anonymous function for the bond dirty price (formula 13 in the slides)
% for a corp. bond with 2y maturity and XX rating, the 2yr hazard rate is
% taken as a variable h while the 1yr hazard rate is the one computed above
% as h_1yr
fun_2yr = @(h) sum(cf_schedule_2y(1:2,2).*B(2:3).*exp(-h_1yr.*T(2:3))) + sum(cf_schedule_2y(3:4,2).*B(4:5).*exp(-h.*T(4:5))) + R*sum((exp(-h_1yr.*T(1:2))-exp(-h_1yr.*T(2:3))).*B(2:3)) + R*sum((exp(-h.*T(3:4))-exp(-h.*T(4:5))).*B(4:5)) - Bond_dirty_price_2y;
% Solve the function above with fsolve, we use 0 as initial data

h_2yr = fsolve(fun_2yr, 0, options);

h_curve = [1, h_1yr; 2, h_2yr];

end

