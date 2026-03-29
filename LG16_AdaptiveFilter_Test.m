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
% checks if audio is stereo
if size(x,2) > 1
    x = mean(x, 2); % convert stereo to mono if necessary
end

% The parameters
M = 16;          % filter order / number of taps
mu = 0.01;       % step size
D = 3;           % delay

N = length(x);
w = zeros(M,1);          % initial filter coefficients
y_adapt = zeros(N,1);    % predicted signal
e_adapt = zeros(N,1);    % actual output (filtered signal)
w_history = zeros(M,N);  % weight changes (analysis)

% LMS adaptive prediction
for n = M + D : N
    % input vector (past delayed samples)
    u = x(n-D:-1:n-D-M+1);
    
    % predicted sample
    y_adapt(n) = w' * u;
    
    % error = desired - predicted (eto yung enhanced speech signal)
    e_adapt(n) = x(n) - y_adapt(n);
    
    % update weights
    w = w + mu * e_adapt(n) * u;
    
    % store weights
    w_history(:,n) = w;
end

% Adaptive filtered signal
x_adaptive = e_adapt;

% play adaptive filtered audio
sound(x_adaptive, Fs);

% B. IIR Filter





%% 3. Comparison of Results
