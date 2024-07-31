function forward_tree = compute_forward_tree(l_max, dx, N)
% Simulate the OU X process with a trinomial tree
% 
% INPUT: 
% l_max:
% dx: Step between two levels in the X OU process
% N: Number of steps
%
% OUTPUT:
%
% forward_tree


% Initialize the forward tree by fixing its dimensions
forward_tree = NaN(2*l_max + 1,(N+1));

% Start index
central_index = ceil(length(forward_tree(:,1))/2);
forward_tree(central_index,:) = 0;

% explore tree
l = 1;
for jj = 2:N+1
    for ii = 1:l
        forward_tree(central_index-ii,jj) = forward_tree(central_index,jj) + ii*dx;
        forward_tree(central_index+ii,jj) = forward_tree(central_index,jj) - ii*dx;
    end
    l = l+1;
    if l > l_max
        l = l_max;
    end
end

% Plot the forward tree
figure;
imagesc(forward_tree);

% Choose your preferred colormap (e.g., 'parula')
cmap = colormap('turbo'); 

% Insert white color at the beginning
cmap = [[1, 1, 1]; cmap]; 
colormap(cmap);

% Adjust the color limits to show NaN as white
% Adjust the limits according to your preference
clim([min(forward_tree(:,end))-N/10, max(forward_tree(:,end))+N/10]); 

min_val = min(forward_tree(:,end));
max_val = max(forward_tree(:,end));

% Calculate the range of values from min to max, with 0 centered
range = max(abs(min_val), abs(max_val));
y_ticks = linspace(range, -range, 11);
set(gca, 'YTick', linspace(1,size(forward_tree, 1),11), 'YTickLabel', y_ticks);
x_ticks = 0:10;
set(gca, 'XTick', linspace(1,size(forward_tree, 2),11), 'XTickLabel', x_ticks);
% Add labels and title
xlabel('Time horizon');
ylabel('X process values');
title('Trinomial Tree Visualization (N = 100)');

% Add a colorbar and set the limits according to the matrix values
%clrbar = colorbar;
%clrbar.Limits = [min(forward_tree(:,end)); max(forward_tree(:,end))];


end
