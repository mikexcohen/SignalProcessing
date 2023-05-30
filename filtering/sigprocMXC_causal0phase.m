%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Filtering
%      VIDEO: Causal and zero-phase-shift filters
% Instructor: sincxpress.com
%
%%

clear

% create a simple signal
signal = [ zeros(1,100) cos(linspace(pi/2,5*pi/2,10)) zeros(1,100) ];
n = length(signal);

% plot it and its power spectrum
figure(1), clf
subplot(221)
plot(1:n,signal,'ko-')
set(gca,'xlim',[0 n+1])
title('Original signal')
xlabel('Time points (a.u.)')


subplot(222)
plot(linspace(0,1,n),abs(fft(signal)),'ko-','markerfacecolor','w')
set(gca,'xlim',[0 .5])
xlabel('Frequency (norm.)'), ylabel('Energy')
title('Frequency-domain signal representation')

%% apply a low-pass causal filter

% note: frequency listed as fraction of Nyquist (not sampling rate!)
fkern = fir1(50,.6,'low');
fsignal = filter(fkern,1,signal);
subplot(234)
plot(1:n,signal, 1:n,fsignal)
set(gca,'xlim',[0 n+1]), axis square
xlabel('Time (a.u.)')
legend({'Original';'Forward filtered'})


% flip the signal backwards
fsignalFlip = fsignal(end:-1:1);
% and show its spectrum
subplot(222), hold on
plot(linspace(0,1,n),abs(fft(fsignal)),'r','linew',3)



% filter the flipped signal
fsignalF = filter(fkern,1,fsignalFlip);
subplot(235)
plot(1:n,signal, 1:n,fsignalF)
set(gca,'xlim',[0 n+1]), axis square
xlabel('Time (a.u.)')
legend({'Original';'Backward filtered'})


% finally, flip the double-filtered signal
fsignalF = fsignalF(end:-1:1);
subplot(236)
plot(1:n,signal, 1:n,fsignalF)
set(gca,'xlim',[0 n+1]), axis square
xlabel('Time (a.u.)')
legend({'Original';'Zero-phase filtered'})

subplot(222)
plot(linspace(0,1,n),abs(fft(fsignalF)),'mo','markersize',7,'markerfacecolor','w','linew',2)
legend({'Original';'Forward filtered';'Zero-phase-shift'})


%% done.
