
%% SPEECH PROCESSING AND SYTHESIS PROJECT
% PART B
% Themelis Konstantinos (kothemel@gmail.com), Kapodistria Aggeliki (agkapodi@gmail.com)


% Signal concatenation
final_signal = [s_ao  s_iy  s_uh  s_eh];
k = audioplayer(final_signal, 16000);
play(k);

% Plot the final signal and create a .wav file
n=1:length(final_signal);
figure('name', 'Final Signal');
plot(n, final_signal)
audiowrite('final_signal.wav', final_signal, 16000);
