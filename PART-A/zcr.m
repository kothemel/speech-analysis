% This function calculates the zero-crossing rate of a given frame.
%
% INPUT: x - signal frame
%
% OUTPUT: ZCR - zero-crossing rate of the frame


function ZCR = zcr(x)
    ZCR  = sum(abs(diff(x>0)))/length(x);
end