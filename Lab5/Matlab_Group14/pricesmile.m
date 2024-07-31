function smile_price=pricesmile(F0,K, delta_time, discount1, cSelect)
% Compute the price of a digital option considering the smile in 
% the curve of the implied volatility

% INPUT 
% F0: forward price
% K: strike price ATM
% delta time: time to maturity
% discount1: discount at maturity
% cSelet: set of data

% OUTPUT
% smile_price: price of digital option

% Extract data
sigmasmile=cSelect.surface;
strike=cSelect.strikes;

% Find sigma with spline interpolation
sigma=interp1(strike,sigmasmile, K, 'spline');

% Compute the price via black formula
black_price=priceblack(F0,K, delta_time, discount1, cSelect);

% Calculate the vega
d1 = log(F0/K)./sqrt(delta_time*sigma^2) + 1/2.*sqrt(delta_time*sigma^2);
vega = F0*discount1*sqrt(delta_time)*1/sqrt(2*pi)*exp(-d1^2/2);

% Calculate the slope
index = find(sigma >= sigmasmile, 1);  
slope = (sigmasmile(index)-sigmasmile(index-1))/(strike(index)-strike(index-1));  

% Compute the price considering the slope
smile_price = black_price-slope*vega;

end