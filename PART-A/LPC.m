% This function calculates the LPC coefficients and the signal estimation.
%
% INPUT: x - signal
%        order - p-th order of the  filter
%
% OUTPUT: coef - LPC coefficients
%         error
%         allpole - all-pole transfer function


function [ coef, error, allpole ] = LPC( x, order )

    [coef, g] = lpc(x,order);
    
    coef    = (0 - coef(2:end));
    est_x   = filter(coef,1,x);
    error   = x - est_x;
    allpole = filter(sqrt(g),coef,est_x);

end

