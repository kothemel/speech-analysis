function [ Y, f ] = DFT(y,freq)

    L = length(y);
    NFFT = 2^nextpow2(L); 
    Y = fft(y,NFFT)/L;
    f = freq/2*linspace(0,1,NFFT/2+1);

    % Plot single-sided amplitude spectrum.
    plot(f,2*abs(Y(1:NFFT/2+1))) 
    title('DFT');
    xlabel('Freq (Hz)');
    ylabel('Amplitude');
    
end