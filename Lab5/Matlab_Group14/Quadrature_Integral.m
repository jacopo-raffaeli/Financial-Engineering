function I = Quadrature_Integral(x1, xN, moneyness, delta_t, kappa, a, dev_sigma, eta)
% This function comput the integral according to the Quadrature method and
% then the price

% INPUT
% [x1, xN]:                     Quadrature parameters
% moneyness
% delta_t
% kappa:                        Volatility of the volatility  
% delta_t
% a
% dev_sigma
% eta:                          Simmetry
%
% OUTPUT
% I:         Approximated integral

% Define Laplace exponent as an anonymous function
logL = @(w) (delta_t/kappa)*((1-a)/a)*(1 - (1 + w*kappa*(dev_sigma^2)/(1-a)).^a);

% Define characteristic function as an anonymous function
phi = @(s) exp(-1i*s*logL(eta)).*exp(logL(1i*(0.5+eta).*s + 0.5*s.^2));

% Define the integrand function (Considering the exponential term referred
% to the Fourier transform
g = @(csi, s) exp(-1i*csi.*s).*phi(-csi-0.5*1i)./((csi.^2 + 0.25));

% Compute the quadrature approximation considering csi as a variable and s
% fixed, and then evaluate the approxiamtion in the moneyness vector
I = arrayfun(@(s) quadgk(@(csi) g(csi,s), x1, xN), moneyness);

end

