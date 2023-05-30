%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Wavelet analysis
%      VIDEO: What are wavelets?
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
csw = cos(2*pi*freq*timevec); % cosine wave
fwhm = .5; % full-width at half-maximum in seconds
gaussian = exp( -(4*log(2)*timevec.^2) / fwhm^2 ); % Gaussian

% Morlet wavelet
MorletWavelet = csw .* gaussian;

% amplitude spectrum
MorletWaveletPow = abs(fft(MorletWavelet)/npnts);



figure(1), clf

% time-domain plotting
subplot(421)
plot(timevec,MorletWavelet,'k','linew',2)
set(gca,'ylim',[-1 1.1],'xlim',timevec([1 end]))
xlabel('Time (sec.)'), ylabel('Amplitude')
title('Morlet wavelet in time domain')

% frequency-domain plotting
subplot(422)
plot(hz,MorletWaveletPow(1:length(hz)),'k','linew',2)
set(gca,'xlim',[0 freq*3])
xlabel('Frequency (Hz)'), ylabel('Amplitude')
title('Morlet wavelet in frequency domain')

%% Haar wavelet

% create Haar wavelet
HaarWavelet = zeros(npnts,1);
HaarWavelet(dsearchn(timevec',0):dsearchn(timevec',.5)) = 1;
HaarWavelet(dsearchn(timevec',.5):dsearchn(timevec',1-1/fs)) = -1;

% amplitude spectrum
HaarWaveletPow = abs(fft(HaarWavelet)/npnts);


% time-domain plotting
subplot(423)
plot(timevec,HaarWavelet,'k','linew',2)
set(gca,'ylim',[-1.1 1.1],'xlim',timevec([1 end]))
xlabel('Time (sec.)'), ylabel('Amplitude')
title('Haar wavelet in time domain')

% frequency-domain plotting
subplot(424)
plot(hz,HaarWaveletPow(1:length(hz)),'k','linew',2)
set(gca,'xlim',[0 freq*3])
xlabel('Frequency (Hz)'), ylabel('Amplitude')
title('Haar wavelet in frequency domain')


%% Mexican hat wavelet

% the wavelet
s = .4;
MexicanWavelet = (2/(sqrt(3*s)*pi^.25)) .* (1- (timevec.^2)/(s^2) ) .* exp( (-timevec.^2)./(2*s^2) );

% amplitude spectrum
MexicanPow = abs(fft(MexicanWavelet)/npnts);


% time-domain plotting
subplot(425)
plot(timevec,MexicanWavelet,'k','linew',2)
set(gca,'ylim',[-1 1]*1.5,'xlim',timevec([1 end]))
xlabel('Time (sec.)'), ylabel('Amplitude')
title('Mexican wavelet in time domain')

% frequency-domain plotting
subplot(426)
plot(hz,MexicanPow(1:length(hz)),'k','linew',2)
set(gca,'xlim',[0 freq*3])
xlabel('Frequency (Hz)'), ylabel('Amplitude')
title('Mexican wavelet in frequency domain')

%% Difference of Gaussians (DoG)
% (approximation of Laplacian of Gaussian)

% define sigmas
sPos = .1;
sNeg = .5;

% create the two GAussians
gaus1 = exp( (-timevec.^2) / (2*sPos^2) ) / (sPos*sqrt(2*pi));
gaus2 = exp( (-timevec.^2) / (2*sNeg^2) ) / (sNeg*sqrt(2*pi));

% their difference is the DoG
DoG = gaus1 - gaus2;


% amplitude spectrum
DoGPow = abs(fft(DoG)/npnts);


% time-domain plotting
subplot(427)
plot(timevec,DoG,'k','linew',2)
set(gca,'ylim',[-1.1 4],'xlim',timevec([1 end]))
xlabel('Time (sec.)'), ylabel('Amplitude')
title('DoG wavelet in time domain')

% frequency-domain plotting
subplot(428)
plot(hz,DoGPow(1:length(hz)),'k','linew',2)
set(gca,'xlim',[0 freq*3])
xlabel('Frequency (Hz)'), ylabel('Amplitude')
title('DoG wavelet in frequency domain')

%% done.
