%%
%     COURSE: Signal processing and image processing in MATLAB and Python
%    SECTION: Wavelet analysis
%      VIDEO: Time-frequency analysis with complex wavelets
% Instructor: sincxpress.com
%
%%

% create signal
srate = 1000;
time  = -3:1/srate:3;
pnts  = length(time);
freqmod = exp(-time.^2)*10+10;
freqmod = freqmod + linspace(0,10,pnts);
signal  = sin( 2*pi * ((time + cumsum(freqmod))/srate) );


% plot the signal
figure(1), clf
subplot(411)
plot(time,signal,'linew',1)
xlabel('Time (s)')
title('Time-domain signal')

%% create complex Morlet wavelets

% wavelet parameters
nfrex = 50; % 50 frequencies
frex  = linspace(3,35,nfrex);
fwhm  = .2; % full-width at half-maximum in seconds

% initialize matrices for wavelets
wavelets = zeros(nfrex,pnts);

% create complex Morlet wavelet family
for wi=1:nfrex
    % Gaussian
    gaussian = exp( -(4*log(2)*time.^2) / fwhm^2 );
    
    % complex Morlet wavelet
    wavelets(wi,:) = exp(1i*2*pi*frex(wi)*time) .* gaussian;
end

% show the wavelets
figure(2), clf
subplot(411)
plot(time,real(wavelets(10,:)), time,imag(wavelets(10,:)))
xlabel('Time')
legend({'Real';'Imaginary'})

subplot(4,1,2:4)
contourf(time,frex,real(wavelets),40,'linecolor','none')
xlabel('Time (s)'), ylabel('Frequency (Hz)')
title('Real part of wavelets')

%% run convolution using FFTs

% convolution parameters
nconv = pnts*2-1; % M+N-1
halfk = floor(pnts/2)+1;

% Fourier spectrum of the signal
sigX = fft(signal,nconv);

% initialize time-frequency matrix
tf = zeros(nfrex,pnts);


% convolution per frequency
for fi=1:nfrex
    
    % FFT of the wavelet
    waveX = fft(wavelets(fi,:),nconv);
    % amplitude-normalize the wavelet
    %%% note: ensure we're taking the magnitude of the peak; 
    %   I didn't explain this in the video but it ensures normalization by
    %   the magnitude and not the complex value.
    waveX = waveX ./ abs(max(waveX));
    
    % convolution
    convres = ifft( waveX.*sigX );
    % trim the "wings"
    convres = convres(halfk:end-halfk+1);
    
    % extract power from complex signal
    tf(fi,:) = abs(convres).^2;
end

%% plot the results

figure(1)
subplot(4,1,[2 3 4])
contourf(time,frex,tf,40,'linecolor','none')
xlabel('Time (s)'), ylabel('Frequency (Hz)')
title('Time-frequency power')

%% done.
