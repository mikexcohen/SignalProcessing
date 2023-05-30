%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Filtering
%      VIDEO: FIR filters with firls
% Instructor: sincxpress.com
%
%%

srate   = 1024; % hz
nyquist = srate/2;
frange  = [20 45];
transw  = .1;
order   = round( 5*srate/frange(1) );

shape   = [ 0 0 1 1 0 0 ];
frex    = [ 0 frange(1)-frange(1)*transw frange frange(2)+frange(2)*transw nyquist ] / nyquist;

% filter kernel
filtkern = firls(order,frex,shape);

% compute the power spectrum of the filter kernel
filtpow = abs(fft(filtkern)).^2;
% compute the frequencies vector and remove negative frequencies
hz      = linspace(0,srate/2,floor(length(filtkern)/2)+1);
filtpow = filtpow(1:length(hz));




figure(1), clf
subplot(131)
plot(filtkern,'linew',2)
xlabel('Time points')
title('Filter kernel (firls)')
axis square



% plot amplitude spectrum of the filter kernel
subplot(132), hold on
plot(hz,filtpow,'ks-','linew',2,'markerfacecolor','w')
plot(frex*nyquist,shape,'ro-','linew',2,'markerfacecolor','w')


% make the plot look nicer
set(gca,'xlim',[0 frange(1)*4])
xlabel('Frequency (Hz)'), ylabel('Filter gain')
legend({'Actual';'Ideal'})
title('Frequency response of filter (firls)')
axis square


subplot(133), hold on
plot(hz,10*log10(filtpow),'ks-','linew',2,'markersize',10,'markerfacecolor','w')
plot([1 1]*frange(1),get(gca,'ylim'),'k:')
set(gca,'xlim',[0 frange(1)*4],'ylim',[-50 2])
xlabel('Frequency (Hz)'), ylabel('Filter gain (dB)')
title('Frequency response of filter (firls)')
axis square

%% effects of the filter kernel order

% range of orders
ordersF = ( 1*srate/frange(1)) / (srate/1000);
ordersL = (15*srate/frange(1)) / (srate/1000);

orders = round( linspace(ordersF,ordersL,10) );


% initialize
fkernX = zeros(length(orders),1000);
hz = linspace(0,srate,1000);

figure(2), clf
for oi=1:length(orders)
    
    % create filter kernel
    fkern = firls(orders(oi),frex,shape);
    n(oi) = length(fkern);

    % take its FFT
    fkernX(oi,:) = abs(fft(fkern,1000)).^2;
    
    % show in plot
    subplot(211), hold on
    plot((1:n(oi))-n(oi)/2,fkern+.01*oi,'linew',2)
end
xlabel('Time (ms)')
set(gca,'ytick',[])
title('Filter kernels with different orders')


subplot(223), hold on
plot(hz,fkernX,'linew',2)
plot(frex*nyquist,shape,'k','linew',4)
set(gca,'xlim',[0 100])
xlabel('Frequency (Hz)'), ylabel('Attenuation')
title('Frequency response of filter (firls)')


subplot(224)
plot(hz,10*log10(fkernX),'linew',2)
set(gca,'xlim',[0 100])
xlabel('Frequency (Hz)'), ylabel('Attenuation (log)')
title('Frequency response of filter (firls)')

%% effects of the filter transition width

% range of transitions
transwidths = linspace(.01,.4,10);


% initialize
fkernX = zeros(length(transwidths),1000);
hz = linspace(0,srate,1000);

figure(3), clf
for ti=1:length(transwidths)
    
    % create filter kernel
    frex  = [ 0 frange(1)-frange(1)*transwidths(ti) frange(1) frange(2) frange(2)+frange(2)*transwidths(ti) nyquist ] / nyquist;
    fkern = firls(400,frex,shape);
    n(ti) = length(fkern);

    % take its FFT
    fkernX(ti,:) = abs(fft(fkern,1000)).^2;
    
    % show in plot
    subplot(211), hold on
    plot((1:n(ti))-n(ti)/2,fkern+.01*ti,'linew',2)
end
xlabel('Time (ms)')
set(gca,'ytick',[])
title('Filter kernels with different transition widths')


subplot(223), hold on
plot(hz,fkernX,'linew',2)
plot(frex*nyquist,shape,'k','linew',4)
set(gca,'xlim',[0 100])
xlabel('Frequency (Hz)'), ylabel('Attenuation')
title('Frequency response of filter (firls)')


subplot(224)
plot(hz,10*log10(fkernX),'linew',2)
set(gca,'xlim',[0 100])
xlabel('Frequency (Hz)'), ylabel('Attenuation (log)')
title('Frequency response of filter (firls)')

%% done.
