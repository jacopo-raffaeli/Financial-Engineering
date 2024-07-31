function bw_tree = compute_backward_tree(fw_tree, EEpayoff, stoch_disc, l_max, p, dt, flag_bermudan)
% Compute the backward tree by discounting back with stochastic discounts
% the final payoffs and evaluating the early exercise where needed
%
% INPUT:
% fw_tree
% EEpayoff: Payoffs in the early exercise dates
% stoch_disc
% l_max
% p: Up, Middle, Down probabilities for each level of the tree
% dt: Time step in the trre's grid
% flag_bermudan:
% == 0 Do not check the early exercise possibility
% == 1 Check the early exercise possibility
%
% OUTPUT
% bw_tree: Tree containing the discounted payoffs down to 0 considering
% also the early exercise possibility.

% Define the payoff for the last possible exercise date
final_payoff = EEpayoff(:,end);

% Define the backward tree
bw_tree = NaN(size(fw_tree));
bw_tree(:,end) = final_payoff;

% Backward tree
for jj = (size(bw_tree,2) - 1):-1:1
    % Second part of the tree (the boundaries are reached by the x process)
    if jj > l_max
        for ii = 1:size(bw_tree,1)
            xi = fw_tree(ii,jj);
            if ii == 1
                idx = ii:ii+2;
            elseif ii == size(fw_tree,1)
                idx = ii-2:ii;
            else
                idx = ii-1:ii+1;
            end
            xi1 = fw_tree(idx,jj+1);
            D = [stoch_disc(xi,xi1(1)); stoch_disc(xi,xi1(2)); stoch_disc(xi,xi1(3))];
            D = D(:,jj);
            bw_tree(ii,jj) = sum(p(:,ii).*bw_tree(idx,jj+1).*D);
        end
    else
        for ii = ((l_max - jj) + 2):(size(bw_tree,1) - ((l_max - jj) + 1))
            xi = fw_tree(ii,jj);
            idx = ii-1:ii+1;
            xi1 = fw_tree(idx,jj+1);
            D = [stoch_disc(xi,xi1(1)); stoch_disc(xi,xi1(2)); stoch_disc(xi,xi1(3))];
            D = D(:,jj);
            bw_tree(ii,jj) = sum(p(:,ii).*bw_tree(idx,jj+1).*D);
        end
    end
    if flag_bermudan == 1
        if ismember(jj, (1 + (2/dt):(1/dt):(size(bw_tree,2) - (1/dt))))
            payoff_index = find(jj == (1 + (2/dt):(1/dt):(size(bw_tree,2) - (1/dt))));
            bw_tree(:,jj) = bw_tree(:,jj).*(bw_tree(:,jj) >= EEpayoff(:,payoff_index)) + EEpayoff(:,payoff_index).*(bw_tree(:,jj) < EEpayoff(:,payoff_index));
        end
    end
end

end
