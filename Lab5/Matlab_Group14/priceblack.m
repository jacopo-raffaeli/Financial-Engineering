function black_price=priceblack(F0, K, delta_time, discount1, cSelect)
% Compute the price of a digital option according to the Black model using
% closed formula

% INPUT 
% F0: forward price
% K: strike price ATM
% delta time: time to maturity
% discount1: discount at maturity
% cSelet: set of data

% OUTPUT
% black_price: price of digital option

% Extract data
sigma1=cSelect.surface;
strike=cSelect.strikes;

% Interpolate the sigma
sigma=interp1(strike,sigma1, K, 'spline');

% Compute the price via black formula
d2 = log(F0/K)./sqrt(delta_time*sigma^2) - 1/2.*sqrt(delta_time*sigma^2);
black_price = discount1*normcdf(d2);

end