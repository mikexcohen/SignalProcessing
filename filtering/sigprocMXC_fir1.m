%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Filtering
%      VIDEO: FIR filters with fir1
% Instructor: sincxpress.com
%
%%

clear

srate   = 1024; % hz
nyquist = srate/2;
frange  = [20 45];
order   = round( 5*srate/frange(1) );

% filter kernel
filtkern = fir1(order,frange/nyquist);

% compute the power spectrum of the filter kernel
filtpow = abs(fft(filtkern)).^2;
% compute the frequencies vector and remove negative frequencies
hz      = linspace(0,srate/2,floor(length(filtkern)/2)+1);
filtpow = filtpow(1:length(hz));




figure(4), clf
subplot(131)
plot(filtkern,'linew',2)
xlabel('Time points')
title('Filter kernel (fir1)')
axis square



% plot amplitude spectrum of the filter kernel
subplot(132), hold on
plot(hz,filtpow,'ks-','linew',2,'markerfacecolor','w')

plot([0 frange(1) frange frange(2) nyquist],[0 0 1 1 0 0],'ro-','linew',2,'markerfacecolor','w')

% dotted line corresponding to the lower edge of the filter cut-off
plot([1 1]*frange(1),get(gca,'ylim'),'k:')

% make the plot look nicer
set(gca,'xlim',[0 frange(1)*4])%,'ylim',[-.05 1.05])
xlabel('Frequency (Hz)'), ylabel('Filter gain')
legend({'Actual';'Ideal'})
title('Frequency response of filter (fir1)')
axis square


subplot(133), hold on
plot(hz,10*log10(filtpow),'ks-','linew',2,'markersize',10,'markerfacecolor','w')
plot([1 1]*frange(1),get(gca,'ylim'),'k:')
set(gca,'xlim',[0 frange(1)*4],'ylim',[-80 2])
xlabel('Frequency (Hz)'), ylabel('Filter gain (dB)')
title('Frequency response of filter (fir1)')
axis square


%% effect of order parameter

orders = round( linspace( (1*srate/frange(1)) / (srate/1000), ...
                   (15*srate/frange(1)) / (srate/1000) ,10) );

fkern = cell(size(orders));
fkernX = zeros(length(orders),1000);
hz = linspace(0,srate,1000);

figure(5), clf
for oi=1:length(orders)
    
    % create filter kernel
    fkern = fir1(orders(oi),frange/nyquist);
    n(oi) = length(fkern);

    % take its FFT
    fkernX(oi,:) = abs(fft(fkern,1000)).^2;
    
    % show in plot
    subplot(211), hold on
    plot((1:n(oi))-n(oi)/2,fkern+.01*oi,'linew',2)
end
xlabel('Time (ms)')
title('Filter kernels (fir1)')



subplot(223), hold on
plot(hz,fkernX,'linew',2)
plot([0 frange(1) frange frange(2) nyquist],[0 0 1 1 0 0],'ro-','linew',2,'markerfacecolor','w')
set(gca,'xlim',[0 100])
xlabel('Frequency (Hz)'), ylabel('Attenuation')
title('Frequency response of filter (fir1)')


subplot(224)
plot(hz,10*log10(fkernX),'linew',2)
set(gca,'xlim',[0 100])
xlabel('Frequency (Hz)'), ylabel('Attenuation (log)')
title('Frequency response of filter (fir1)')

%% done.
