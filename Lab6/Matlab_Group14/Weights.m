function w = Weights(k, cg_buckets, datesSet, flag)
% Compute weights for coarsed-bucket sensitivities (according to theory) 
%
% INPUT
% k: 
% cg_buckets:   set of buckets
% datesSet:     struct of the dates of market Data
% flag:         0 for point f, computes buckets of 0-2y , 2y-5y , 5y-10y , 10y-15y 
%               1 for point h, computes buckets of 0-5y , 5y-15y
%
% OUTPUT
% w:            weights

if flag == 0
    w = zeros(length(datesSet.swaps),1);
    switch k
        case 1
            for n = 1:cg_buckets(k+1)
                w(n) = 1;
            end
            w(cg_buckets(k+1):cg_buckets(k+2)) = interp1([datesSet.swaps(cg_buckets(k+1)) datesSet.swaps(cg_buckets(k+2))], [1 0], datesSet.swaps(cg_buckets(k+1):cg_buckets(k+2)));
        case 2
            w(cg_buckets(k):cg_buckets(k+1)) = interp1([datesSet.swaps(cg_buckets(k)) datesSet.swaps(cg_buckets(k+1))], [0 1], datesSet.swaps(cg_buckets(k):cg_buckets(k+1)));
            w(cg_buckets(k+1):cg_buckets(k+2)) = interp1([datesSet.swaps(cg_buckets(k+1)) datesSet.swaps(cg_buckets(k+2))], [1 0], datesSet.swaps(cg_buckets(k+1):cg_buckets(k+2)));
        case 3
            w(cg_buckets(k):cg_buckets(k+1)) = interp1([datesSet.swaps(cg_buckets(k)) datesSet.swaps(cg_buckets(k+1))], [0 1], datesSet.swaps(cg_buckets(k):cg_buckets(k+1)));
            w(cg_buckets(k+1):cg_buckets(k+2)) = interp1([datesSet.swaps(cg_buckets(k+1)) datesSet.swaps(cg_buckets(k+2))], [1 0], datesSet.swaps(cg_buckets(k+1):cg_buckets(k+2)));
        case 4
            w(cg_buckets(k):cg_buckets(k+1)) = interp1([datesSet.swaps(cg_buckets(k)) datesSet.swaps(cg_buckets(k+1))], [0 1], datesSet.swaps(cg_buckets(k):cg_buckets(k+1)));
            w(cg_buckets(k+1):end) = 1;
    end
    
elseif flag == 1
    w = zeros(length(datesSet),1);
    switch k
        case 1
            for n = 1:cg_buckets(k+1)
                w(n) = 1;
            end
            w(cg_buckets(k+1):cg_buckets(k+2)) = interp1([datesSet(cg_buckets(k+1)) datesSet(cg_buckets(k+2))], [1 0], datesSet(cg_buckets(k+1):cg_buckets(k+2)));
        case 2
            w(cg_buckets(k):cg_buckets(k+1)) = interp1([datesSet(cg_buckets(k)) datesSet(cg_buckets(k+1))], [0 1], datesSet(cg_buckets(k):cg_buckets(k+1)));
            w(cg_buckets(k+1):end) = 1;
    end
end

end