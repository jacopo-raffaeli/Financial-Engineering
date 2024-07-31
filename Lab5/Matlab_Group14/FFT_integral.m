function I = FFT_integral(x1, xN, dx, z1, zN, dz, N, moneyness, delta_t, kappa, a, dev_sigma, eta)
% This function compute the integral according to the FFT method

% INPUT
% [x1, xN, dx, z1, zN, dz, N]:  FFT parameters
% moneyness
% delta_t
% kappa:                        Volatility of the volatility  
% delta_t
% a
% dev_sigma
% eta:                          Simmetry
%
% OUTPUT
% I:                            Approximated integral

% Create the grids
x = x1:dx:xN;
z = z1:dz:zN;

% Define Laplace exponent as an anonymous function
logL = @(w) (delta_t/kappa)*((1-a)/a)*(1 - (1 + w*kappa*(dev_sigma^2)/(1-a)).^a);

% Define characteristic function as an anonymous function
phi = @(s) exp(-1i*s*logL(eta)).*exp(logL(1i*(0.5+eta).*s + 0.5*s.^2));

% Define the integrand function as an anonymous function
f = @(csi) phi(-csi-0.5*1i)./(csi.^2 + 0.25);

% fj are the discrete approximation of the integrand function used by fft()
% to approximate the integral
fj = exp(-1i.*(0:(N-1))*dx*z1).*f(x);

% Compute the integral according to the fft method
I = dx*exp(-1i*x1*z).*fft(fj);

% Evaluate the approximated integral in the moneyness vector
I = interp1(x,I,moneyness);

end

