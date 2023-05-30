%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Wavelet analysis
%      VIDEO: Time-frequency analysis of brain signals
% Instructor: sincxpress.com
%
%%

% load in data
load data4TF.mat

% plot the signal
figure(1), clf
subplot(411)
plot(timevec,data,'linew',1)
set(gca,'xlim',timevec([1 end]))
xlabel('Time (s)'), ylabel('Voltage (\muV)')
title('Time-domain signal')

%% create complex Morlet wavelets

% wavelet parameters
nfrex = 50; % 50 frequencies
frex  = linspace(8,70,nfrex);
fwhm  = .2; % full-width at half-maximum in seconds

% time vector for wavelets
wavetime = -2:1/srate:2;


% initialize matrices for wavelets
wavelets = zeros(nfrex,length(wavetime));

% create complex Morlet wavelet family
for wi=1:nfrex
    % Gaussian
    gaussian = exp( -(4*log(2)*wavetime.^2) / fwhm^2 );
    
    % complex Morlet wavelet
    wavelets(wi,:) = exp(1i*2*pi*frex(wi)*wavetime) .* gaussian;
end

% show the wavelets
figure(2), clf
subplot(411)
plot(wavetime,real(wavelets(10,:)), wavetime,imag(wavelets(10,:)))
xlabel('Time')
legend({'Real';'Imaginary'})

subplot(4,1,2:4)
contourf(wavetime,frex,real(wavelets),40,'linecolor','none')
xlabel('Time (s)'), ylabel('Frequency (Hz)')
title('Real part of wavelets')

%% run convolution using spectral multiplication

% convolution parameters
nconv = length(timevec) + length(wavetime) - 1; % M+N-1
halfk = floor(length(wavetime)/2);

% Fourier spectrum of the signal
dataX = fft(data,nconv);

% initialize time-frequency matrix
tf = zeros(nfrex,length(timevec));


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
    convres = ifft( waveX.*dataX );
    % trim the "wings"
    convres = convres(halfk:end-halfk);
    
    % extract power from complex signal
    tf(fi,:) = abs(convres).^2;
end

%% plot the results

figure(1)
subplot(4,1,[2 3 4])
contourf(timevec,frex,tf,40,'linecolor','none')
xlabel('Time (s)'), ylabel('Frequency (Hz)')
set(gca,'clim',[0 1e3])
title('Time-frequency power')
colormap hot

%% done.
