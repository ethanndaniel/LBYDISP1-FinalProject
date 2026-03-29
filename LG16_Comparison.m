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

%sound(x_adaptive, Fs);


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

%sound(x_iir, Fs);




%% 3. Comparison of Results

% plot time domain waveforms (individual graphs)
figure;
subplot(3,1,1); plot(t, x); title('Noisy Signal');
subplot(3,1,2); plot(t, x_adaptive); title('Adaptive Output');
subplot(3,1,3); plot(t, x_iir); title('IIR Output');

% plot time domain waveforms (overlapped graph)
figure;
hold on;
plot(t, x, 'r');           % noisy signal
plot(t, x_adaptive, 'b');  % adaptive signal
plot(t, x_iir, 'g');       % IIR signal
hold off;
title('Waveform Comparison (Overlapped Graphs)');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Noisy Signal', 'Adaptive Output', 'IIR Output');

% setup frequency vector for fft
N_fft = length(x);
f = (0:N_fft-1)*(Fs/N_fft);
half_N = floor(N_fft/2);

% calculate magnitude spectrum using fast fourier transform
X_mag = abs(fft(x));
Xa_mag = abs(fft(x_adaptive));
Xi_mag = abs(fft(x_iir));

% plot frequency domain spectrums
figure;
subplot(3,1,1); plot(f(1:half_N), X_mag(1:half_N)); title('Noisy Spectrum');
subplot(3,1,2); plot(f(1:half_N), Xa_mag(1:half_N)); title('Adaptive Spectrum');
subplot(3,1,3); plot(f(1:half_N), Xi_mag(1:half_N)); title('IIR Spectrum');

% playback audio signals sequentially
%sound(x, Fs); 
%pause(length(x)/Fs + 1);
%sound(x_adaptive, Fs); 
%pause(length(x_adaptive)/Fs + 1);
%sound(x_iir, Fs); 

% calculate signal-to-noise ratio and mean squared error
snr_adapt = 10 * log10(sum(x.^2) / sum((x - x_adaptive).^2));
mse_adapt = mean((x - x_adaptive).^2);

snr_iir = 10 * log10(sum(x.^2) / sum((x - x_iir).^2));
mse_iir = mean((x - x_iir).^2);

% display performance metrics through the command window
fprintf('Adaptive -> Signal_to_Noise_Ratio: %.2f dB | Mean_Squared_Error: %e\n', snr_adapt, mse_adapt);
fprintf('IIR      -> Signal_to_Noise_Ratio: %.2f dB | Mean_Squared_Error: %e\n', snr_iir, mse_iir);
