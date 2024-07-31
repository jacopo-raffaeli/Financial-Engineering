function C = Compute_Price(M, free, flag, moneyness, method_flag, eta, kappa, dev_sigma, delta_t, a, B_0_t, F0)
% This function compute the price both with fft method and quadrature
% method

% INPUT: 
%
% M:    N = (2^M) used for creating the grid for FFT
% free: The other free parameter: dz or x1
% flag: flag = 0 --> dz
%       flag = 1 --> x1
% Moneyness
% method_flag: method_flag = 0 --> FFT
%              method_flag = 1 --> Quadrature
% delta_t
% kappa:                        Volatility of the volatility  
% delta_t
% a
% dev_sigma
% eta:                          Simmetry
%
% OUTPUT:
%
% I: Approximated integral (Evaluated in the moneyness)

if nargin < 4
    method_flag = 0;    % default FFT
end

% Compute all the needed parameters from M and the selected free one
[x1,xN,dx,z1,zN,dz,N] = FFT_parameters(M, free, flag);

% Define Laplace exponent as an anonymous function
logL = @(w) (delta_t/kappa)*((1-a)/a)*(1 - (1 + w*kappa*(dev_sigma^2)/(1-a)).^a);

% Define characteristic function as an anonymous function
phi = @(s) exp(-1i*s*logL(eta)).*exp(logL(1i*(0.5+eta).*s + 0.5*s.^2));

switch method_flag
    case 0
        I = FFT_integral(x1, xN, dx, z1, zN, dz, N, moneyness, delta_t, kappa, a, dev_sigma, eta);
    case 1
        I = Quadrature_Integral(x1, xN, moneyness, delta_t, kappa, a, dev_sigma, eta);
end

% Compute price (Imaginary part is negligible)
C = B_0_t*F0.*(1 - (exp(-0.5*moneyness)/(2*pi)).*I);
C = real(C);

end

