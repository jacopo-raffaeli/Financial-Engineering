function optionPrice = BermudanOptionCRR(F0,K,B,T,sigma,N)
% Option price with the Cox-Ross-Rubinstein pricing method under Black model
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% pricingMode: 1 ClosedFormula, 2 CRR, 3 Monte Carlo
% N:     number of time steps (knots of CRR tree)    
% flag:  1 call, -1 put

% To simplify the computation we round N to the nearest multiple of 3, in
% this way we are sure that in some step N we will be exactly in 1 month
% and 2 month respectively, in this steps we will compare the discounted
% price with the respective payoff to establish if it is more convenient to
% early exercise the option or not (like in the computation of an american
% option)
rounding = 3;
N = rounding*round(N/rounding);
dt = T/N;
dx = sigma*sqrt(dt);
u = exp(dx);       %multiplier if the r.v goes 'up'
d = exp(-dx);      %multiplier if the r.v goes 'down'
q = (1-d)/(u-d);   %probability of the r.v going 'up'
% Allocate the space for a binomial backward tree and for the payoff
% computed respectively in 2 months and 1 month
tree = zeros(N+1,N+1);
F02m = [];
f01m = []; 

% Fill the first column of the tree with the payoff at 3 months
for i=0:N
    tree(i+1,1) = max(F0*u^(N-i)*d^(i) - K , 0);
end
% Fill the vector F02m with the payoff at 2 months
for i=0:(N-(N/3))
    F02m(i+1) = max(F0*u^((N-(N/3))-i)*d^(i) - K, 0);  
end
% Fill the vector F01m with the payoff at 1 months
for i=0:(N-(2*N/3))
    F01m(i+1) = max(F0*u^((N-(2*N/3))-i)*d^(i) - K, 0);  
end

% Computing the value of tree
for j=1:N
    for i=0:(N-j)
        % If we are in N/3 i.e. in 2 months we value the possibility of
        % early exercise
        if j == (N/3)
            tree(i+1,j+1) = max(B^(1/N)*(q*tree(i+1,j)+(1-q)*tree(i+2,j)) , F02m(i+1));
        % If we are in 2*N/3 i.e. in 1 month we value the possibility of
        % early exercise
        elseif j == (2*N/3) 
            tree(i+1,j+1) = max(B^(1/N)*(q*tree(i+1,j)+(1-q)*tree(i+2,j)) , F01m(i+1));
        % Otherwise we compute the "classic" value
        else
            tree(i+1,j+1) = B^(1/N)*(q*tree(i+1,j)+(1-q)*tree(i+2,j));
        end
    end
end
optionPrice = tree(1,N+1);

end

