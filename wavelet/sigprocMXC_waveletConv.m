%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Wavelet analysis
%      VIDEO: Convolution with wavelets
% Instructor: sincxpress.com
%
%%

%% general simulation parameters

fs = 1024;
npnts = fs*5; % 5 seconds

% centered time vector
timevec = (1:npnts)/fs;
timevec = timevec - mean(timevec); 

% for power spectrum
hz = linspace(0,fs/2,floor(npnts/2)+1);

%% Morlet wavelet

% parameters
freq = 4; % peak frequency
csw  = cos(2*pi*freq*timevec); % cosine wave
fwhm = .5; % full-width at half-maximum in seconds
gaussian = exp( -(4*log(2)*timevec.^2) / fwhm^2 ); % Gaussian

% Morlet wavelet
MorletWavelet = csw .* gaussian;

%% Haar wavelet

HaarWavelet = zeros(npnts,1);
HaarWavelet(dsearchn(timevec',0):dsearchn(timevec',.5)) = 1;
HaarWavelet(dsearchn(timevec',.5):dsearchn(timevec',1-1/fs)) = -1;

%% Mexican hat wavelet

s = .4;
MexicanWavelet = (2/(sqrt(3*s)*pi^.25)) .* (1- (timevec.^2)/(s^2) ) .* exp( (-timevec.^2)./(2*s^2) );

%% convolve with random signal

% signal
signal = detrend(cumsum(randn(npnts,1)));

% convolve signal with different wavelets
morewav = conv(signal,MorletWavelet,'same');
haarwav = conv(signal,HaarWavelet,'same');
mexiwav = conv(signal,MexicanWavelet,'same');

% amplitude spectra
morewaveAmp = abs(fft(morewav)/npnts);
haarwaveAmp = abs(fft(haarwav)/npnts);
mexiwaveAmp = abs(fft(mexiwav)/npnts);


%%% plotting
figure(2), clf

% the signal
subplot(511)
plot(timevec,signal,'k')
title('Signal')
xlabel('Time (s)'), ylabel('Amplitude')


% the convolved signals
subplot(5,1,2:3), hold on
plot(timevec,morewav,'linew',2)
plot(timevec,haarwav,'linew',2)
plot(timevec,mexiwav,'linew',2)

xlabel('Time (sec.)'), ylabel('Amplitude')
legend({'Morlet';'Haar';'Mexican'})


% spectra of convolved signals
subplot(5,1,4:5), hold on
plot(hz,morewaveAmp(1:length(hz)),'linew',2)
plot(hz,haarwaveAmp(1:length(hz)),'linew',2)
plot(hz,mexiwaveAmp(1:length(hz)),'linew',2)

set(gca,'xlim',[0 40],'yscale','lo')
xlabel('Frequency (Hz.)'), ylabel('Amplitude')

%% done.
