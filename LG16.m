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
sound(x, Fs);




%% 2. Apply Filters


% A. Adaptive Filter


% B. FIR Filter





%% 3. Comparison of Results


