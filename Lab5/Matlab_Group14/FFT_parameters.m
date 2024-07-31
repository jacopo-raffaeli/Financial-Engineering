function [x1,xN,dx,z1,zN,dz,N] = FFT_parameters(M, free, flag)
% This function take as input free parameters and returns the all the
% parameters needed for computing FFT
%
% INPUT: 
%
% M:    N = (2^M) used for creating the grid for FFT
% free: The other free parameter: dz or x1
% flag: flag = 0 --> dz
%       flag = 1 --> x1
%
% OUTPUT:
%
% x1: lower bound for the x grid
% xN: upper bound for the x grid
% dx: dimension of the x grid step
% z1: lower bound for the z grid
% zN: upper bound for the z grid
% dz: dimension of the z grid step
% N:  used for creating the grid for FFT

if (nargin < 3) % number of arguments input
    flag = 0; % default dz
end 

switch flag
    case 0
        dz = free;
        N = 2^M;
        z1 = -dz*(N-1)/2;
        zN = -z1;
        dx = 2*pi/(N*dz);
        x1 = -dx*(N-1)/2;
        xN = -x1;
    case 1
        x1 = free;
        N = 2^M;
        xN = -x1;
        dx = (xN - x1)/(N-1);
        dz = (2*pi)/(N*dx);
        z1 = -dz*(N-1)/2;
        zN = -z1;
end
