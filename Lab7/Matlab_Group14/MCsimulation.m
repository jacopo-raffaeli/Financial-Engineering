function S= MCsimulation(F0, ttm, sigma,k,eta,M)
% Simulation of the Forward via NIG model

% INPUT:
% F0:       initial value of the forward 
% ttm:      vector of time to maturity
% sigma:    volatility of the model
% k:        convexity of the model
% eta:      asimmetry of the model
% M:        number of MC simulations

% OUTPUT:
% S:        value of the forward at t1 and t2

%create F vector
n=2;
F = zeros(M,n+1);
F(:,1) = F0;

for i = 1:n

    % simulating random variables
    g = randn(M,1);
    u=rand(M,1);            % uniform distribution 
    z=chi2rnd(1, M, 1);     % chi squared distribution

    % simulating G
    G_hat= 1 - k/2*(sqrt(z.^2 + 4.*z/k)- z);  
    G=G_hat;
    aux= (1 + G_hat).*u ; 
    pos= find(aux>1); 
    G(pos)= 1./G_hat(pos);

    % simulating Ft
    laplace_exp = ttm(i)/k *( 1 - sqrt ( 1 + 2*k*eta*sigma^2));
    f_t = sqrt(ttm(i))*sigma*sqrt(G).*g - (1/2 + eta)*ttm(i)*sigma^2*G - laplace_exp;
    F(:,i+1) = F(:,i).*exp(f_t);

end

% compute St
S = F(:,2:end);

end