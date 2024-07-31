function Bond_dirty_price = PV_risky_bond_Z(z, cf_schedule, ZC_curve)
% % Compute the bond dirty price based on the z spread for the
% 4 corp. bonds

% INPUT
%
% z    :                     z-spread for the bond
% cf_schedule:              Table of cash flows of corp. bonds with 
%                           XX rating and Yy maturity
% ZC_curve:                 Table of zero-coupon rates

% OUTPUT
%
% Bond_dirty_price:         Bond dirty price computed with the z-spread

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

% Check if the bond has 1yr maturity or 2yr maturity and compute the
% respective price
if length(cf_schedule(:,1)) == 2
    Bond_dirty_price = sum(cf_schedule(:,2).*B(2:3).*exp(-z.*T(2:3)));
elseif length(cf_schedule(:,1)) == 4
    Bond_dirty_price = sum(cf_schedule(:,2).*B(2:5).*exp(-z.*T(2:5)));
end

end

