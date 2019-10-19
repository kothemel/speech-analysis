
%% SPEECH PROCESSING AND SYTHESIS PROJECT
% PART A
% Themelis Konstantinos (kothemel@gmail.com), Kapodistria Aggeliki (agkapodi@gmail.com)


clear;
%% A-1 - Record voice signal

% % Uncomment this to record a new voice

% pause(1);
% recObj = audiorecorder(16000,8,1);
% 
% disp('Start speaking.')
% recordblocking(recObj, 3);
% disp('End of Recording.');
% 
% data = getaudiodata(recObj);
% 
% audiowrite('voicename.wav', data, 16000);

[y,Fs] = audioread('voicename_female.wav');

% Plot the waveform
figure('name', 'Recorded voice');
plot(y);

%% A-2 - Spectogram computation using hamming window

Tw = [0.010, 0.100];
Ts = Tw(1)/2;

% Seconds to samples
windowSize = [Tw(1)*Fs, Tw(2)*Fs];
windowOverlap = Ts * Fs;

N = length(y);
T = (0:N-1)*1/Fs;
wideWindow = hamming(windowSize(1));
narrowWindow = hamming(windowSize(2));

% Plot input and then the spectograms
nfft = [2^nextpow2(windowSize(1)), 2^nextpow2(windowSize(2))];
figure(2);
spectrogram(y,wideWindow,windowOverlap,nfft(1),Fs,'yaxis');
figure(3);
spectrogram(y,narrowWindow,windowOverlap,nfft(2),Fs,'yaxis');

%% A3 - Voiced, unvoiced and silence detection

window  = 0.010 * Fs;
overlap = 0.005 * Fs;

input_window = buffer(y, window, overlap,'nodelay')';
numOfWindows = size(input_window,1);

% Flags for classifying each frame
% 0 for silence
% 1 for unvoiced
% 2 for voiced

E = zeros(1,numOfWindows);
ZCR = zeros(1,numOfWindows);
decision = zeros(1,numOfWindows);
pitch = zeros(1,numOfWindows);

voiced=0;
for k=1:numOfWindows
    x = input_window(k,:);
    E(k) = energy(x);
    ZCR(k) = zcr(x);
    decision(k)=detectVUS (E(k), ZCR(k));
    
    if decision(k)==2
        voiced=voiced+1;
        pitch(k) = calcPitch(x, Fs);
    end
end

% % Uncomment this to print the number of voiced frames
% voiced

voiced = zeros(1,length(decision));
unvoiced = zeros(1,length(decision));
silence =  zeros(1,length(decision));

for k=1:length(decision)
    if decision(k) == 0
        voiced(k) = NaN;
        unvoiced(k) = NaN;
    elseif decision(k) == 1
        unvoiced(k) = 1;
        voiced(k) = NaN;
        silence(k) = NaN;
    else
        voiced(k) = 2;
        unvoiced(k) = NaN;
        silence(k) = NaN;
    end
end

figure(4);
subplot(3,1,1);
t = (0:length(y)-1)*1/Fs;
plot(t,y);
title('Input Signal');
xlabel('t (sec)');

subplot(3,1,2);
plot(E,'-');
title('Energy');
xlabel('Frame');

subplot(3,1,3);
plot(ZCR, '-');
title('Zero-Crossing Rate');
xlabel('Frame');

figure(5);

subplot(3,1,1);
t = (0:length(y)-1)*1/Fs;
plot(t,y);
title('Input Signal');
xlabel('t (sec)');

n = 1:length(decision);
subplot(3,1,2);
plot(n, silence, 'b', n, unvoiced, 'y+', n, voiced, 'r*')
axis([1 600 0 4]);
title('Voiced-Unvoiced-Silence Detection');
xlabel('Frames');
ylabel('Classification');
legend('silence','unvoiced', 'voiced');

%% A-4 - Pitch Detection


for k=1:length(pitch)
    if pitch(k)==0
        pitch(k)=NaN;
    end
end

subplot(3,1,3)
plot(pitch,'b*');
title('Pitch detection');
xlim([1 600]);
xlabel('Frames');
ylabel('Frequency (Hz)');

%% A-5 - LPC

input = audioread('voicename_female.wav');

window_size = 0.030 * Fs;
window_overlap = 0.005 * Fs;

input_window = buffer(input,window_size,window_overlap,'nodelay')';
numOfWindows = size(input_window,1);

E = zeros(1,numOfWindows);
ZCR    = zeros(1,numOfWindows);
decision    = zeros(1,numOfWindows);

for j=1:numOfWindows
    x = input_window(j,:);
    E(j) = sum(x.^2);
    ZCR(j)    = zcr(x);
    decision(j)    = detectVUS(E(j),ZCR(j));
end

voicedFrame = zeros(window_size,1);
unvoicedFrame = zeros(window_size,1);


% Isolate a voiced frame
for j=1:numOfWindows
    if (decision(j) == 2)
        voicedFrame = input_window(j,:);
        break;
    end
end

% Isolate an unvoiced frame
for j=1:numOfWindows
    if (decision(j) == 1)
        unvoicedFrame = input_window(j,:);
        break;
    end
end


% LPC on voiced part
[lpc8,  error8, H_trans8]    = LPC(voicedFrame,  8);
[lpc12, error12, H_trans12]  = LPC(voicedFrame, 12);
[lpc16, error16, H_trans16]  = LPC(voicedFrame, 16);

% LPC on unvoiced part
[lpc8u,  error8u,  H_trans8u]   = LPC(unvoicedFrame,  8);
[lpc12u, error12u, H_trans12u]  = LPC(unvoicedFrame, 12);
[lpc16u, error16u, H_trans16u]  = LPC(unvoicedFrame, 16);

figure('name', 'LPC - Voiced');
t = (0:length(voicedFrame)-1)*1/Fs;
subplot(3,1,1);
plot(t,voicedFrame)
title('Voiced frame');
xlabel('t (sec)');
ylabel('Amplitude');

subplot(3,1,2);
% Plot the DFT
DFT(voicedFrame, Fs);

subplot(3,1,3);
plot(t, error8, t, error12, t, error16, t, abs(H_trans8),t, abs(H_trans12),t, abs(H_trans16));
title('Prediction Error');
xlabel('t (sec)');
ylabel('Amplitude');
legend('8','12','16','allpole8','allpole12','allpole16','Location', 'EastOutside');


figure('name', 'LPC - Unvoiced');
t = (0:length(unvoicedFrame)-1)*1/Fs;
subplot(3,1,1);
plot(t,unvoicedFrame)
title('Unvoiced frame');
xlabel('t (sec)');
ylabel('Amplitude');

subplot(3,1,2);
% Plot the DFT
DFT(unvoicedFrame, Fs);

subplot(3,1,3);
plot(t, error8u, t, error12u, t, error16u,t,abs(H_trans8u),t, abs(H_trans12u),t, abs(H_trans16u));
title('Prediction Error');
xlabel('t (sec)');
ylabel('Amplitude');
legend('8','12','16', 'allpole8','allpole12','allpole16', 'Location', 'EastOutside');


