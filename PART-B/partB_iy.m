
%% SPEECH PROCESSING AND SYTHESIS PROJECT
% PART B
% Themelis Konstantinos (kothemel@gmail.com), Kapodistria Aggeliki (agkapodi@gmail.com)


%% B-1 Stimulation signal

% sampling rate
Fs = 10000;
Ts = 1/Fs;
samples=1:1000;

p_notsym = zeros(1,length(samples));
for i=1:length(samples)
    temp=0;
    for l=1:1000
        temp = temp + (0.9999^l)*(delta(i-pitch*l));
    end
    p_notsym(i) = temp;
end



%% B-2 Glottal Pulse

% define discrete-time signal
g = zeros(1,length(samples));
for iter=1:length(samples)
    g(iter) = glotal_pulse(iter);
end


%% B-3 Vocal Tract

K = 3;
F = [270, 2290, 3010];
V = createZVocalTract(F);

%% B-4 Radiation Load

r = zeros(1,length(samples));
for i=1:length(samples)
    r(i) = delta(i) - 0.96*delta(i-1);
end

%% B-5 - Speech signal


A = 5000;
temp = conv(p_notsym,g);
temp = conv(temp, V);
s_iy = A*conv(temp, r);


%-------------------------------------------------------------------------%
% % Uncomment this to plot the 'iy' pulse and its dft

figure('name', 'iy');
subplot(2,1,1)
n=1:length(s_iy);
plot(n,s_iy);
title('Speech Signal');

subplot(2,1,2)
sdft = fft(s_iy);
sdft = sdft(1:(length(s_iy)/2)+1);
ssdx = (1/(2*pi*length(s_iy))) * abs(sdft).^2;
ssdx(2:end-1) = 2*ssdx(2:end-1);
freq = 0:Fs/length(s_iy):Fs/2;
plot(freq, 10*log10(ssdx))
grid on
title('Spectrum Using DFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency)')


%-------------------------------------------------------------------------%
% % Uncomment this to play the 'iy'

% iy = audioplayer(s_iy, Fs);
% play(iy);

