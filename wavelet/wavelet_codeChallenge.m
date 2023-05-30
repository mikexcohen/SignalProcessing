clear

% signal is random noise
srate = 2048;
signal = smooth( randn(srate*6,1),3 );

clf
plot(signal)
plot(abs(fft(signal)))

%% FIR filter

% define filter parameters
lower_bnd = 10; % Hz
upper_bnd = 15; % Hz

tw = .1;

samprate  = 2048; % Hz
filtorder = 4*round(samprate/lower_bnd);

filter_shape = [ 0 0 1 1 0 0 ];
filter_freqs = [ 0 lower_bnd*(1-tw) lower_bnd ...
                 upper_bnd upper_bnd+upper_bnd*tw ...
                 (samprate/2) ] / (samprate/2);

filterkern = firls(filtorder,filter_freqs,filter_shape);

signalFIR = filtfilt(filterkern,1,signal);

%% wavelet

timevec = -1:1/srate:1;
freq = (lower_bnd+upper_bnd)/2;

csw = cos(2*pi*freq*timevec); % cosine wave
fwhm = .25; % full-width at half-maximum in seconds
gaussian = exp( -(4*log(2)*timevec.^2) / fwhm^2 ); % Gaussian

% Morlet wavelet
mw = csw .* gaussian/(2*pi*30);

signalMW = conv(signal,mw,'same');


% nc = length(mw)+length(signal)-1;
% kh = floor(length(mw)/2)+1;
% signalMW2 = ifft( fft(signal',nc).*fft(miwav,nc) );
% signalMW2 = signalMW2(kh:end-kh+1);



% plotting

%%

N = length(signal);

tv = (0:N-1)/srate;

clf
subplot(311)
plot(tv,signal)
xlabel('Time (s)')
title('Original signal')

subplot(312), cla; hold on
plot(tv,signalFIR)
plot(tv,signalMW)
xlabel('Time (s)')
title('Filtered signals')
legend({'FIR';'MW'})

subplot(313), cla, hold on
hz = linspace(0,srate,N);
plot(hz,abs(fft(signalFIR/N)))
plot(hz,abs(fft(signalMW/N)))
set(gca,'xlim',[0 20])
legend({'FIR';'MW'})
title('Amplitude spectra')
xlabel('Frequency (Hz)')

%%




