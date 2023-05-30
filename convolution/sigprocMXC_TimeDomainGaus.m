%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Convolution
%      VIDEO: Convolution with time-domain Gaussian (smoothing filter)
% Instructor: sincxpress.com
%
%%

%% create the signal

% create signal
srate = 1000; % Hz
time  = 0:1/srate:3;
n     = length(time);
p     = 15; % poles for random interpolation

% noise level, measured in standard deviations
noiseamp = 5;

% amplitude modulator and noise level
ampl   = interp1(rand(p,1)*30,linspace(1,p,n));
noise  = noiseamp * randn(size(time));
signal = ampl + noise;

% subtract mean to eliminate DC
signal = signal - mean(signal);

%% create Gaussian kernel

% full-width half-maximum: the key Gaussian parameter
fwhm = 25; % in ms

% normalized time vector in ms
k = 100;
gtime = 1000*(-k:k)/srate;

% create Gaussian window
gauswin = exp( -(4*log(2)*gtime.^2) / fwhm^2 );

% then normalize Gaussian to unit energy
gauswin = gauswin / sum(gauswin);

%% filter as time-domain convolution

% initialize filtered signal vector
filtsigG = signal;

% implement the running mean filter
for i=k+1:n-k-1
    % each point is the weighted average of k surrounding points
    filtsigG(i) = sum( signal(i-k:i+k).*gauswin );
end

%% now repeat in the frequency domain

% compute N's
nConv = n + 2*k+1 - 1;

% FFTs
dataX = fft(signal,nConv);
gausX = fft(gauswin,nConv);

% IFFT
convres = ifft( dataX.*gausX );

% cut wings
convres = convres(k+1:end-k);

% frequencies vector
hz = linspace(0,srate,nConv);


%% plots


%%% time-domain plot

figure(1), clf, hold on

% lines
plot(time,signal,'r')
plot(time,filtsigG,'k*-')
plot(time,convres,'bo')

% frills
xlabel('Time (s)'), ylabel('amp. (a.u.)')
legend({'Signal';'Time-domain';'Spectral multiplication'})
title('Gaussian smoothing filter')





%%% frequency-domain plot

figure(2), clf

% plot Gaussian kernel
subplot(511)
plot(hz,abs(gausX).^2,'k','linew',2)
set(gca,'xlim',[0 30])
ylabel('Gain')
title('Power spectrum of Gaussian')


% raw and filtered data spectra
subplot(5,1,[2:5]), hold on
plot(hz,abs(dataX).^2,'rs-','markerfacecolor','w','markersize',13,'linew',2)
plot(hz,abs(dataX.*gausX).^2,'bo-','linew',2,'markerfacecolor','w','markersize',8)

% frills
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
legend({'Signal';'Convolution result'})
title('Frequency domain')
set(gca,'xlim',[0 25])

%% done.
