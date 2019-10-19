% This function calculates the pitch for a framed signal.
%
% INPUT: x - signal
%        freq - sampling frequency
%
% OUTPUT: pitch - fundamental frequency

function pitch = calcPitch(x,freq)

    [n,m] = size(x);
    pitch = zeros(n,1);

    for k=1:n
        c = ifft(log(abs(fft(x(k,:),m))+eps));
        [~,idx] = max(abs(c));
        pitch(k) = freq/idx;
    end

end

