%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Wavelet analysis
%      VIDEO: Time-frequency analysis with complex wavelets
% Instructor: sincxpress.com
%
%%

% data from http://www.vibrationdata.com/Solomon_Time_History.zip

equake = load('Solomon_Time_History.txt');

% more convenient
times  = equake(:,1);
equake = equake(:,2);

srate = round( 1./mean(diff(times)) );

%% plot the signal

% time domain
figure(1), clf
subplot(211)
plot(times/60/60,equake)
set(gca,'xlim',times([1 end])/60/60)
xlabel('Time (hours)')



%%%% NOTE FOR OCTAVE USERS
% Run the following line before calling the pwelch function
%prev_compat = pwelch('R12+');



% frequency domain using pwelch
subplot(212)
winsize = srate*60*10; % window size of 10 minutes
pwelch(equake,winsize,winsize/10,[],srate);
set(gca,'ylim',[-100 -70])

%% setup time-frequency analysis

% parameters (in Hz)
numFrex = 40;
minFreq =  2;
maxFreq = srate/2;
npntsTF = 1000; % this one's in points

% frequencies in Hz
frex  = linspace(minFreq,maxFreq,numFrex);


% wavelet widths (FWHM in seconds)
fwhms = linspace(5,15,numFrex)';


% time points to save
tidx = round( linspace(1,length(times),npntsTF) );


% setup wavelet and convolution parameters
wavet = (-10:1/srate:10);
halfw = floor(length(wavet)/2);
nConv = length(times) + length(wavet) - 1;

% create family of Morlet wavelets
cmw = zeros(length(wavet),numFrex);

% loop over frequencies and create wavelets
for fi=1:numFrex
    cmw(:,fi) = exp(2*1i*pi*frex(fi)*wavet) .* exp(-(4*log(2)*wavet.^2)/fwhms(fi).^2);
end
    
% plot them
figure(2), clf
imagesc(wavet,frex,abs(cmw)')
xlabel('Time (s)'), ylabel('Frequency (Hz)')
set(gca,'ydir','normal')

%% run convolution

% initialize time-frequency matrix
[tf,tfN] = deal( zeros(length(frex),length(tidx)) );

% baseline time window for normalization
basetidx = dsearchn(times,[-1000 0]');
basepow  = zeros(numFrex,1);

% spectrum of data
dataX = fft(equake,nConv);

% loop over frequencies
for fi=1:numFrex
    
    % create wavelet
    waveX = fft( cmw(:,fi),nConv );
    
    %%% note: ensure we're taking the magnitude of the peak; 
    %   I didn't explain this in the video but it ensures normalization by
    %   the magnitude and not the complex value.
    waveX = waveX./abs(max(waveX));
    
    % convolve
    as = ifft( waveX.*dataX );
    % trim
    as = as(halfw:end-halfw);
    
    % power time course at this frequency
    powts = abs(as).^2;
    
    % baseline (pre-quake)
    basepow(fi) = mean(powts(basetidx(1):basetidx(2)));
    
    tf(fi,:)  = 10*log10( powts(tidx) );
    tfN(fi,:) = 10*log10( powts(tidx)/basepow(fi) );
end

%% show time-frequency maps

% "raw" power
figure(3), clf
subplot(211)
contourf(times(tidx),frex,tf,40,'linecolor','none')
xlabel('Time'), ylabel('Frequency (Hz)')
title('Time-frequency plot')
set(gca,'clim',[-150 -70])

% pre-quake normalized power
subplot(212)
contourf(times(tidx),frex,tfN,40,'linecolor','none')
xlabel('Time'), ylabel('Frequency (Hz)')
title('Time-frequency plot')
set(gca,'clim',[-1 1]*15)

%% normalized and non-normalized power

figure(4), clf

subplot(211)
plot(frex,mean(tf,2),'ks-','linew',2,'markersize',10,'markerfacecolor','w')
xlabel('Frequency (Hz)'), ylabel('Power (10log_{10})')
title('Raw power')


subplot(212)
plot(frex,mean(tfN,2),'ks-','linew',2,'markersize',10,'markerfacecolor','w')
xlabel('Frequency (Hz)'), ylabel('Power (norm.)')
title('Pre-quake normalized power')

%% done.

