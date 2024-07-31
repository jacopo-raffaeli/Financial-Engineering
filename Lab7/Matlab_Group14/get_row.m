function first_row = get_row(matrix,n)
% Select the n-th row of the matrix
%
% INPUT:
% matrix
% n: index of row
%
% OUTPUT:
% first_row

first_row = matrix(n, :);
end