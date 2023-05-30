%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Filtering
%      VIDEO: High-pass filters
% Instructor: sincxpress.com
%
%%

% generate 1/f noise
N  = 8000;
fs = 1000;
as = rand(1,N) .* exp(-(0:N-1)/200);
fc = as .* exp(1i*2*pi*rand(size(as)));
noise = real(ifft(fc)) * N;



%%% create frequency-domain Gaussian
hz = linspace(0,fs,N);
s  = 4*(2*pi-1)/(4*pi); % normalized width
x  = hz-30;             % shifted frequencies
fg = exp(-.5*(x/s).^2); % gaussian

fc = rand(1,N) .* exp(1i*2*pi*rand(1,N));
fc = fc .* fg;

% generate signal from Fourier coefficients, and add noise
signal = real( ifft(fc) )*N;
data = signal + noise;
time = (0:N-1)/fs;



%%% plot the data
figure(1), clf
subplot(211)
plot(time,data)
xlabel('Time (s)'), ylabel('Amplitude')
title('Data = signal + noise')


subplot(212), hold on
plot(hz,abs(fft(signal)/N).^2,'linew',2);
plot(hz,abs(fft(noise)/N).^2,'linew',2);
legend({'Signal';'Noise'})
set(gca,'xlim',[0 100])
title('Frequency domain representation of signal and noise')
xlabel('Frequency (Hz)'), ylabel('Power')

%% now for high-pass filter

% specify filter cutoff (in Hz)
filtcut = 25;

% generate filter coefficients (Butterworth)
[filtb,filta] = butter(7,filtcut/(fs/2),'high');

% test impulse response function (IRF)
impulse  = [ zeros(1,500) 1 zeros(1,500) ];
fimpulse = filtfilt(filtb,filta,impulse);
imptime  = (0:length(impulse)-1)/fs;


% plot impulse and IRF
figure(2), clf
subplot(321)
plot(imptime,impulse, imptime,fimpulse./max(fimpulse),'linew',2)
xlabel('Time (s)')
set(gca,'ylim',[-.1 .1])
legend({'Impulse';'Impulse response'})
title('Time domain filter characteristics')


% plot spectrum of IRF
subplot(322), hold on
hz = linspace(0,fs/2,3000);
imppow = abs(fft(fimpulse,2*length(hz))).^2;
plot(hz,imppow(1:length(hz)),'k','linew',1)
plot([1 1]*filtcut,get(gca,'ylim'),'r--')
set(gca,'xlim',[0 60],'ylim',[0 1])
xlabel('Frequency (Hz)'), ylabel('Gain')
title('Frequency domain filter characteristics')


% now filter the data and compare against the original
subplot(312)
fdata = filtfilt(filtb,filta,data);
plot(time,signal, time,fdata,'linew',1)
legend({'Original';'Filtered'})
xlabel('Time (s)'), ylabel('Amplitude')
title('Time domain')



%%% power spectra of original and filtered signal
signalX = abs(fft(signal)/N).^2;
fdataX  = abs(fft(fdata)/N).^2;
hz = linspace(0,fs,N);

subplot(313)
plot(hz,signalX(1:length(hz)), hz,fdataX(1:length(hz)),'linew',1);
set(gca,'xlim',[20 60])
legend({'Original';'Filtered'})
xlabel('Frequency (Hz)'), ylabel('Power')
title('Frequency domain')

%% done.
