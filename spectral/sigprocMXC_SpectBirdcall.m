%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Spectral and rhythmicity analyses
%      VIDEO: Spectrogram of birdsong
% Instructor: sincxpress.com
%
%%

% load in birdcall (source: https://www.xeno-canto.org/403881)
[bc,fs] = audioread('XC403881.mp3'); % in Octave, import the wav version

% let's hear it!
soundsc(bc,fs)


% create a time vector based on the data sampling rate
n = length(bc);
timevec = (0:n-1)/fs;

% plot the data from the two channels
figure(1), clf
subplot(211)
plot(timevec,bsxfun(@plus,bc,[.2 0]))
xlabel('Time (sec.)')
title('Time domain')
set(gca,'ytick',[],'xlim',timevec([1 end]))

% compute the power spectrum
hz = linspace(0,fs/2,floor(n/2)+1);
bcpow = abs(fft( detrend(bc(:,1)) )/n).^2;

% now plot it
subplot(212)
plot(hz,bcpow(1:length(hz)),'linew',2)
xlabel('Frequency (Hz)')
title('Frequency domain')
set(gca,'xlim',[0 8000])

%% now for a time-frequency analysis

% use MATLAB's spectrogram function (in the signal processing toolbox)
[powspect,frex,time] = spectrogram(detrend(bc(:,2)),hann(1000),100,[],fs);

% Octave uses the following line instead of the above line
%[powspect,frex,time] = specgram(detrend(bc(:,2)),1000,fs,hann(1000));


% show the time-frequency power plot
figure(3), clf
imagesc(time,frex,abs(powspect).^2)
axis xy
xlabel('Time (sec.)'), ylabel('Frequency (Hz)')
set(gca,'clim',[0 1]*2,'ylim',frex([1 dsearchn(frex(:),15000)]),'xlim',time([1 end]))
colormap hot

%% done.
