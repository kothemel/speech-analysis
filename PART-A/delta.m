% This function calculates the dirac function for.
%
% INPUT: n - number of samples
% OUTPUT: y = dirac(n)

function y = delta(n)

    y = 0; 
    
    if n == 0
        y = 1;
    end
end