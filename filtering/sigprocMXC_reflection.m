%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Filtering
%      VIDEO: Avoid edge effects with reflection
% Instructor: sincxpress.com
%
%%

clear

% create a signal
N  = 500;
hz = linspace(0,1,N);
gx = exp( -(4*log(2)*(hz-.1)/.1).^2 )*N/2;
signal = real(ifft( gx.*exp(1i*rand(1,N)*2*pi) )) + ...
         randn(1,N);

% plot it and its power spectrum
figure(1), clf
subplot(311)
plot(1:N,signal,'k')
set(gca,'xlim',[0 N+1])
title('Original signal')
xlabel('Time points (a.u.)')


subplot(324)
plot(hz,abs(fft(signal)).^2,'k','markerfacecolor','w')
set(gca,'xlim',[0 .5])
xlabel('Frequency (norm.)'), ylabel('Energy')
title('Frequency-domain signal representation')

%% apply a low-pass causal filter

% generate filter kernel
order = 150;
fkern = fir1(order,.6,'low');

% zero-phase-shift filter
fsignal = filter(fkern,1,signal); % forward
fsignal = filter(fkern,1,fsignal(end:-1:1)); % reverse
fsignal = fsignal(end:-1:1); % flip forward


% plot the original signal and filtered version
subplot(323), hold on
plot(1:N,signal,'k')
plot(1:N,fsignal,'m')
set(gca,'xlim',[0 N+1])
xlabel('Time (a.u.)')
title('Time domain')
legend({'Original';'Filtered, no reflection'})


% power spectra
subplot(324), hold on
plot(hz,abs(fft(fsignal)).^2,'m')
title('Frequency domain')
legend({'Original';'Filtered, no reflection'})

%% now with reflection by filter order

% reflect the signal
reflectsig = [ signal(order:-1:1) signal signal(end:-1:end-order+1) ];

% zero-phase-shift filter on the reflected signal
reflectsig = filter(fkern,1,reflectsig);
reflectsig = filter(fkern,1,reflectsig(end:-1:1));
reflectsig = reflectsig(end:-1:1);

% now chop off the reflected parts
fsignal = reflectsig(order+1:end-order);

% try again with filtfilt
%fsignal1 = filtfilt(fkern,1,signal);

% and plot
subplot(325), hold on
plot(1:N,signal,'k')
plot(1:N,fsignal,'m')
set(gca,'xlim',[0 N+1])
xlabel('Time (a.u.)')
title('Time domain')
legend({'Original';'Filtered, with reflection'})

% spectra
subplot(326), hold on
plot(hz,abs(fft(signal)).^2,'k')
plot(hz,abs(fft(fsignal)).^2,'m')
legend({'Original';'Filtered, with reflection'})
set(gca,'xlim',[0 .5])
xlabel('Frequency (norm.)'), ylabel('Energy')
title('Frequency domain')

%% done.
