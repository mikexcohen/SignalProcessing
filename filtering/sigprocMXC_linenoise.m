%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Filtering
%      VIDEO: Remove electrical line noise and its harmonics
% Instructor: sincxpress.com
%
%%

% load data
load lineNoiseData.mat

% time vector
pnts = length(data);
time = (0:pnts-1)/srate;

% compute power spectrum and frequencies vector
pwr = abs(fft(data)/pnts).^2;
hz  = linspace(0,srate,pnts);


%%% plotting
figure(1), clf
% time-domain signal
subplot(211)
plot(time,data,'k')
xlabel('Time (s)'), ylabel('Amplitude')
title('Time domain')

% plot power spectrum
subplot(212)
plot(hz,pwr,'k')
set(gca,'xlim',[0 400],'ylim',[0 2])
xlabel('Frequency (Hz)'), ylabel('Power')
title('Frequency domain')

%% narrowband filter to remove line noise

frex2notch = [ 50 150 250 ];

% initialize filtered signal
datafilt = data;

% loop over frequencies
for fi=1:length(frex2notch)
    
    % create filter kernel using fir1
    frange  = [frex2notch(fi)-.5 frex2notch(fi)+.5];
    order   = round( 150*srate/frange(1) );
    
    % filter kernel
    filtkern = fir1( order,frange/(srate/2),'stop' );
    
    % visualize the kernel and its spectral response
    figure(2)
    subplot(length(frex2notch),2,(fi-1)*2+1)
    xlabel('Time points'), ylabel('Filter amplitude')
    
    plot(filtkern)
    subplot(length(frex2notch),2,(fi-1)*2+2)
    plot(linspace(0,srate,10000),abs(fft(filtkern,10000)).^2)
    set(gca,'xlim',[frex2notch(fi)-30 frex2notch(fi)+30])
    xlabel('Frequency (Hz)'), ylabel('Filter gain')
    
    
    % recursively apply to data
    datafilt = filtfilt(filtkern,1,datafilt);
    
end

%%% plot the signal
figure(3), clf
subplot(211), hold on
plot(time,data,'k')
h = plot(time,datafilt);
set(h,'color',[1 .9 1]*.8)
xlabel('Time (s)')
legend({'Original';'Notched'})



% compute the power spectrum of the filtered signal
pwrfilt = abs(fft(datafilt)/pnts).^2;

% plot power spectrum
subplot(212), cla, hold on
plot(hz,pwr,'k')
h = plot(hz,pwrfilt);
set(h,'color',[1 .7 1]*.6)
set(gca,'xlim',[0 400],'ylim',[0 2])
xlabel('Frequency (Hz)'), ylabel('Power')
title('Frequency domain')

%% done.
