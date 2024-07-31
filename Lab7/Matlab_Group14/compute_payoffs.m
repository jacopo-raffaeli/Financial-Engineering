function  payoffs = compute_payoffs(discounts_curves, nodes, K_swaption)
% Compute the swaption payoffs in each one of the year (2,...9) where it is
% possible to activate the early exercise, to do so we use the discounts
% curves found previously
%
% INPUT:
% discounts_curves: See compute_forward_curves
% nodes: Forward tree with all the nodes of the X OU process
% K_swaption: Strike price of the swaption
%
% OUTPUT:
% 
% payoffs: Swaption payoffs in the early exercise dates

% Define the strike for the put on a coupon bond equivalent to the payer
% swaption
K_put = 1;

% Initialize the swap matrix
swap = zeros(size(nodes,1),size(nodes,2) - 2);

flag = 0;
% Swaption payoff
if flag == 0
    % Compute the swap rate in all the nodes (apart from the last year)
    for jj = (size(nodes,2) - 1):-1:2
        for ii = 1:size(nodes,1)
            node = nodes(ii,jj);
            curves = discounts_curves(node);
            needed_curve = curves(jj-1,:);
            swap(ii,jj-1) = (1 - needed_curve(end))/(sum(needed_curve));
            swap(ii,jj-1) = sum(needed_curve)*(swap(ii,jj-1) - K_swaption);
        end
    end
    % Compute the payoffs
    payoffs = max(0 , swap);
% Put on coupon bond payoff
else
    % Compute the swap rate in all the nodes (apart from the last year)
    for jj = (size(nodes,2) - 1):-1:2
        for ii = 1:size(nodes,1)
            node = nodes(ii,jj);
            curves = discounts_curves(node);
            needed_curve = curves(jj-1,:);
            swap(ii,jj-1) = K_swaption*sum(needed_curve) + 1*needed_curve(end);
        end
    end
    % Compute the payoffs
    payoffs = max(0 , K_put - swap);
end

end
