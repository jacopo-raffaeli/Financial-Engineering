function vega= VegaKI(F0,K,KI,B,T,sigma,N,flagNum)
%computing Vega

% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% KI:    barrier
% T:     time-to-maturity
% sigma: volatility
% N:     number of    
% flagNum: flagNum=1 Exact, flagNum=2 CRR, flagNum=3 MC

delta=0.01; %volatility delta

if flagNum== 1
    d1=log(F0/KI)/(sigma*(sqrt(T))); 
    vega=B*F0 * sqrt(T) .* (exp(-(d1.^2)/2)/sqrt(2*pi))*delta; %Black Formula
end

if flagNum== 3
    M=length(F0);
    sigmaeps=sigma+delta;
    for i = 1:M
        vega_temporaneo=zeros(1,N);
        
        % Calculate vega using finite difference method
        for j=1:N
            CP= EuropeanOptionKIMC(F0(i),K,KI,B,T,sigma,N);
            CP_eps = EuropeanOptionKIMC(F0(i),K,KI,B,T,sigmaeps,N);
            vega_temporaneo(j)=(CP_eps-CP)/delta;
    
        end
        vega(i) = mean(vega_temporaneo);
    end
end

end