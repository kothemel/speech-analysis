% This function calculates the energy if a given frame.
%
% INPUT: x - frame
% OUTPUT: En - energy of the frame

function En = energy(x)
    En = sum(x.^2);
end