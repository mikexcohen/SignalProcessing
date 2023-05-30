%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Filtering
%      VIDEO: Two-stage wide-band filter
% Instructor: sincxpress.com
%
%%

clear

% define filter parameters
lower_bnd = 10; % Hz
upper_bnd = 60; % Hz

transw = .1;

samprate  = 2048; % Hz
filtorder = 8*round(samprate/lower_bnd);

filter_shape = [ 0 0 1 1 0 0 ];
filter_freqs = [ 0 lower_bnd*(1-transw) lower_bnd ...
                 upper_bnd upper_bnd+upper_bnd*transw ...
                 (samprate/2) ] / (samprate/2);

filterkern = firls(filtorder,filter_freqs,filter_shape);
hz = linspace(0,samprate/2,floor(length(filterkern)/2)+1);
filterpow = abs(fft(filterkern)).^2;



figure(1), clf
subplot(221)
plot(filterkern,'linew',2)
xlabel('Time points')
title('Filter kernel (firls)')
axis square



% plot amplitude spectrum of the filter kernel
subplot(222), hold on
plot(hz,filterpow(1:length(hz)),'ks-','linew',2,'markerfacecolor','w')

plot(filter_freqs*samprate/2,filter_shape,'ro-','linew',2,'markerfacecolor','w')

% make the plot look nicer
set(gca,'xlim',[0 upper_bnd+40])
xlabel('Frequency (Hz)'), ylabel('Filter gain')
legend({'Actual';'Ideal'})
title('Frequency response of filter (firls)')
axis square

%% generate white noise signal

N = samprate*4;
noise = randn(N,1);
timevec = (0:length(noise)-1)/samprate;

%% a better way...

%%% first apply a high-pass filter
forder = 14*round(samprate/lower_bnd);
filtkern = fir1(forder,lower_bnd/(samprate/2),'high');

% spectrum of kernel
subplot(212), hold on
hz = linspace(0,samprate/2,floor(length(filtkern)/2)+1);
filterpow = abs(fft(filtkern)).^2;
plot(hz,filterpow(1:length(hz)),'k','linew',2)


% zero-phase-shift filter with reflection
noiseR = [noise(end:-1:1); noise; noise(end:-1:1)]; % reflect
fnoise = filter(filtkern,1,noiseR);                 % forward filter
fnoise = filter(filtkern,1,fnoise(end:-1:1));       % reverse filter
fnoise = fnoise(end:-1:1);                          % reverse again for 0phase
fnoise = fnoise(N+1:end-N);                         % chop off reflected parts




%%% repeat for low-pass filter
forder = 20*round(samprate/upper_bnd);
filtkern = fir1(forder,upper_bnd/(samprate/2),'low');

% spectrum of kernel
hz = linspace(0,samprate/2,floor(length(filtkern)/2)+1);
filterpow = abs(fft(filtkern)).^2;
plot(hz,filterpow(1:length(hz)),'r','linew',2)
plot(repmat([lower_bnd upper_bnd],2,1),repmat([0; 1],1,2),'k--')
set(gca,'xlim',[0 upper_bnd*2])

% zero-phase-shift filter with reflection
noiseR = [fnoise(end:-1:1); fnoise; fnoise(end:-1:1)]; % reflect
fnoise = filter(filtkern,1,noiseR);                 % forward filter
fnoise = filter(filtkern,1,fnoise(end:-1:1));       % reverse filter
fnoise = fnoise(end:-1:1);                          % reverse again for 0phase
fnoise = fnoise(N+1:end-N);                         % chop off reflected parts


% or with the signal-processing toolbox:
% fnoise = filtfilt(filtkern,1,fnoise);

%% plotting

figure(2), clf

subplot(211)
plot(timevec,noise, timevec,fnoise)
xlabel('Time (a.u.)'), ylabel('Amplitude')
title('Filtered noise in the time domain')


% plot power spectrum
noiseX  = abs(fft(noise)).^2;
fnoiseX = abs(fft(fnoise)).^2;
hz = linspace(0,samprate,length(fnoise));

subplot(212)
plot(hz,noiseX, hz,fnoiseX)
set(gca,'xlim',[0 upper_bnd*1.5])
xlabel('Frequency (Hz)'), ylabel('Power')
title('Spectrum of filtered noise')

%% done.
