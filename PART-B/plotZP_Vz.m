
% This functions uses as input the enumerator and denominator of the 
% transfer function and plots the zero-pole diagram
%
% INPUT: enum  - enumerator  of the transfer function V(z)
%        denom - denominator of the transfer function V(z)
%
% OUTPUT: none - the function plots the zero-pole diagram

function [] = plotZP_Vz(enum, denom)
    zplane(enum, denom)
    title('Zero-Poles');
end

