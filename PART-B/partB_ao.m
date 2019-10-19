
%% SPEECH PROCESSING AND SYTHESIS PROJECT
% PART B
% Themelis Konstantinos (kothemel@gmail.com), Kapodistria Aggeliki (agkapodi@gmail.com)

clear all;
prompt = 'Enter Np (40 or 80): ';
pitch = input(prompt);


%% B-1 Stimulation signal

% sampling rate
Fs = 10000;
Ts = 1/Fs;
samples=1:1000;


p_notsym = zeros(1,length(samples)); %p_notsym (not symbolic)
for i=1:length(samples)
    temp=0;
    for l=1:1000
        temp = temp + (0.9999^l)*(delta(i-pitch*l));
    end
    p_notsym(i) = temp;
end

figure(1);
% Plot the stimulated signal p(n)
subplot(3,1,1);
plot(samples, p_notsym);
xlabel('n');
ylabel('p(n)');
title('Stimulated signal');

% Compute spectrum using DFT
N = length(p_notsym);
pdft = fft(p_notsym);
pdft = pdft(1:N/2+1);
psdx = (1/(2*pi*N)) * abs(pdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(p_notsym):Fs/2;

% Plot spectrum using DFT
subplot(3,1,2);
plot(freq, 10*log10(psdx))
grid on
title('Spectrum using DFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency')


% Plot zero-pole diagram
num = 1;
denom = [1, zeros(1,79),-1*0.9999];
subplot(3,1,3);
zplane(num,denom);
title('Zero-Poles');


%% B-2 Glottal Pulse

% define discrete-time signal
g = zeros(1,length(samples));
for iter=1:length(samples)
    g(iter) = glotal_pulse(iter);
end

figure(2);
subplot(2,1,1);
plot(samples, g);
xlabel('n');
ylabel('g(n)');
title('Glottal pulse');


% Compute spectrum using DFT
gdft = fft(g);
gdft = gdft(1:N/2+1);
gsdx = (1/(2*pi*N)) * abs(gdft).^2;
gsdx(2:end-1) = 2*gsdx(2:end-1);
freq = 0:Fs/length(g):Fs/2;

% Plot spectrum using DFT
subplot(2,1,2);
plot(freq, 10*log10(gsdx))
grid on
title('Spectrum Using DFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency')


%  Plot zero-pole diagram - ZERO POLES DIAGRAM MISSING - NOT WORKING
% syms n;
% gp_1 = 0.5*(1-cos(pi*(n+1)/25));
% gp_2 = cos(0.5*pi*(n-24)/10);
% gp_3 = 0;

% gp_z1 = ztrans(gp_1);
% gp_z2 = ztrans(gp_2);
% gp_z3 = 0;

% zplane(gp_z1);
% hold on;
% zplane(hp_z2);
% zplane(hp_z3);
% zplane(gp_z1);


%% B-3 Vocal Tract


K = 3;
F = [570, 840, 2410];
Bw = 60;
sigma_k = 30;

[V, enum, denom] = createZVocalTract(F);

n=1:length(V);
figure(3);

subplot(3,1,1);
plot(n, V);
title('Vocal tract for ao');
xlabel('n');
ylabel('V(n)');

% Compute spectrum using DFT
vdft = fft(V);
vdft = vdft(1:length(V)/2+1);
vsdx = (1/(2*pi*length(V))) * abs(vdft).^2;
vsdx(2:end-1) = 2*vsdx(2:end-1);
freq = 0:Fs/length(V):Fs/2;

% Plot spectrum using DFT
subplot(3,1,2);
plot(freq, 10*log10(vsdx))
grid on
title('Spectrum Using DFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency)')


% Plot zero-pole diagram
subplot(3,1,3)
plotZP_Vz(enum, denom);


%% B-4 Radiation Load

r = zeros(1,length(samples));
for i=1:length(samples)
    r(i) = delta(i) - 0.96*delta(i-1);
end

figure(4);
subplot(3,1,1);
plot(samples, r);
title('Radiation load')
xlabel('n');
ylabel('r(n)');

% Compute spectrum using DFT
subplot(3,1,2)
rdft = fft(r);
rdft = rdft(1:N/2+1);
rsdx = (1/(2*pi*N)) * abs(rdft).^2;
rsdx(2:end-1) = 2*rsdx(2:end-1);
freq = 0:Fs/length(r):Fs/2;

% Plot spectrum using DFT
plot(freq, 10*log10(rsdx))
grid on
title('Spectrum Using DFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency)')

% Plot zero-pole diagram
subplot(3,1,3)
zplane(24/25);
title('Zero-Poles');

%% B-5 - Speech signal


% Signal convolution
A = 5000;
temp = conv(p_notsym,g);
temp = conv(temp, V);
s_ao = A*conv(temp, r);


%-------------------------------------------------------------------------%
% % Uncomment this to plot the 'ao' pulse and its dft

figure('name', 'ao');
subplot(2,1,1)
n=1:length(s_ao);
plot(n,s_ao);
title('Speech Signal');

subplot(2,1,2)
sdft = fft(s_ao);
sdft = sdft(1:(length(s_ao)/2)+1);
ssdx = (1/(2*pi*length(s_ao))) * abs(sdft).^2;
ssdx(2:end-1) = 2*ssdx(2:end-1);
freq = 0:Fs/length(s_ao):Fs/2;
plot(freq, 10*log10(ssdx))
grid on
title('Spectrum Using DFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency)')

%-------------------------------------------------------------------------%
% % Uncomment this to play the 'ao'

% ao = audioplayer(s_ao, Fs);
% play(ao);

% Call the rest of phonemes and create a final signal
partB_iy;
partB_uh;
partB_eh;
partB_finalSignal;
