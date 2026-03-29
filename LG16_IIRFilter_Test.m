%% LBYDISP1 Final Project
clc; clear; close all;

%% 1. Import Audio

% make sure to download .wav file
[x, Fs] = audioread('NewsReportSignal-1.wav');
t = (0:length(x)-1)/Fs;

% plot figure
figure;
plot(t, x);
title('Noisy Signal (Time Domain)');
xlabel('Time (s)');
ylabel('Amplitude');

% play NewsReportSignal-1.wav
% sound(x, Fs);




%% 2. Apply Filters


% A. Adaptive Filter



% B. IIR Filter

% cutoff frequencies for human voice
f_lower = 300;
f_upper = 3400;

% normalize frequencies (nyquist frequency = Fs/2)
Fn = [f_lower f_upper] / (Fs/2);

% use Butterworth Filter
order = 6;  % filter order
[b, a] = butter(order, Fn, 'bandpass');

% apply filter and play filtered sound
x_iir = filter(b, a, x);
sound(x_iir, Fs);




%% 3. Comparison of Results
