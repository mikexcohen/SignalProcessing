%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Filtering
%      VIDEO: Narrow-band filters
% Instructor: sincxpress.com
%
%%

% define filter parameters
lower_bnd = 10; % Hz
upper_bnd = 18; % Hz

lower_trans = .1;
upper_trans = .4;

samprate  = 2048; % Hz
filtorder = 4*round(samprate/lower_bnd);

filter_shape = [ 0 0 1 1 0 0 ];
filter_freqs = [ 0 lower_bnd*(1-lower_trans) lower_bnd ...
                 upper_bnd upper_bnd+upper_bnd*upper_trans ...
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
set(gca,'xlim',[0 upper_bnd+20])
xlabel('Frequency (Hz)'), ylabel('Filter gain')
legend({'Actual';'Ideal'})
title('Frequency response of filter (firls)')
axis square

%% now apply to random noise data

filtnoise = filtfilt(filterkern,1,randn(samprate*4,1));
timevec = (0:length(filtnoise)-1)/samprate;

% plot time series
subplot(2,4,5:7)
plot(timevec,filtnoise,'k','linew',2)
xlabel('Time (a.u.)'), ylabel('Amplitude')
title('Filtered noise in the time domain')


% plot power spectrum
subplot(248)
noisepower = abs(fft(filtnoise)).^2;
plot(linspace(0,samprate,length(noisepower)),noisepower,'k')
set(gca,'xlim',[0 60])
xlabel('Frequency (Hz)'), ylabel('Power')
title('Spectrum of filtered noise')

%% done.
