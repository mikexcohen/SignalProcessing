%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Filtering
%      VIDEO: Low-pass filters
% Instructor: sincxpress.com
%
%%

% simulation parameters
fs      = 350; % hz
timevec = (0:fs*7-1)/fs;
npnts   = length(timevec);

% generate signal
yOrig = cumsum(randn(npnts,1));
y     = yOrig + 50*randn(npnts,1) + 40*sin(2*pi*50*timevec)';

% power spectrum of signal
yX = abs(fft(y)/npnts).^2;
hz = linspace(0,fs/2,floor(npnts/2)+1);


% plot the data
figure(1), clf
subplot(211)
h = plot(timevec,y, timevec,yOrig,'linew',1);
set(h(1),'Color',[1 1 1]*.7)
set(h(2),'linew',2)
xlabel('Time (sec.)'), ylabel('Power')
title('Time domain')
legend({'Measured';'Original'})

% plot its power spectrum
subplot(212)
plot(hz,yX(1:length(hz)),'k','linew',1)
xlabel('Frequency (Hz)'), ylabel('Power')
title('Frequency domain')
set(gca,'yscale','log')

%% now for lowpass filter

fcutoff = 30;
transw  = .2;
order   = round( 7*fs/fcutoff );

shape   = [ 1 1 0 0 ];
frex    = [ 0 fcutoff fcutoff+fcutoff*transw fs/2 ] / (fs/2);

% filter kernel
filtkern = firls(order,frex,shape);

% its power spectrum
filtkernX = abs(fft(filtkern,npnts)).^2;



figure(2), clf
subplot(321)
plot((-order/2:order/2)/fs,filtkern,'k','linew',3)
xlabel('Time (s)')
title('Filter kernel')

subplot(322), hold on
plot(frex*fs/2,shape,'r','linew',1)
plot(hz,filtkernX(1:length(hz)),'k','linew',2)
set(gca,'xlim',[0 60])
xlabel('Frequency (Hz)'), ylabel('Gain')
title('Filter kernel spectrum')



%%% now apply the filter to the data
yFilt = filtfilt(filtkern,1,y);

subplot(312)
h = plot(timevec,y, timevec,yFilt,'linew',2);
set(h(1),'color',[1 1 1]*.4)
legend({'Signal';'Filtered'})
xlabel('Time (sec.)'), ylabel('Amplitude')


%%% power spectra of original and filtered signal
yOrigX = abs(fft(y)/npnts).^2;
yFiltX = abs(fft(yFilt)/npnts).^2;

subplot(313)
plot(hz,yOrigX(1:length(hz)), hz,yFiltX(1:length(hz)),'linew',2);
set(gca,'xlim',[0 fs/5],'yscale','log')
legend({'Signal';'Filtered'})
xlabel('Frequency (Hz)'), ylabel('Power (log)')

%% done.
