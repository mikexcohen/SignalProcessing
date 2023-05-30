%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Spectral and rhythmicity analyses
%      VIDEO: Welch's method
% Instructor: sincxpress.com
%
%%

% load data
load EEGrestingState.mat
N = length(eegdata);

% time vector
timevec = (0:N-1)/srate;

% plot the data
figure(1), clf
plot(timevec,eegdata,'k')
xlabel('Time (seconds)'), ylabel('Voltage (\muV)')

%% one big FFT (not Welch's method)

% "static" FFT over entire period, for comparison with Welch
eegpow = abs( fft(eegdata)/N ).^2;
hz = linspace(0,srate/2,floor(N/2)+1);

%% "manual" Welch's method

% window length in seconds*srate
winlength = 1*srate;

% number of points of overlap
nOverlap = round(srate/2);

% window onset times
winonsets = 1:winlength-nOverlap:N-winlength;

% note: different-length signal needs a different-length Hz vector
hzW = linspace(0,srate/2,floor(winlength/2)+1);

% Hann window
hannw = .5 - cos(2*pi*linspace(0,1,winlength))./2;

% initialize the power matrix (windows x frequencies)
eegpowW = zeros(1,length(hzW));

% loop over frequencies
for wi=1:length(winonsets)
    
    % get a chunk of data from this time window
    datachunk = eegdata(winonsets(wi):winonsets(wi)+winlength-1);
    
    % apply Hann taper to data
    datachunk = datachunk .* hannw;
    
    % compute its power
    tmppow = abs(fft(datachunk)/winlength).^2;
    
    % enter into matrix
    eegpowW = eegpowW  + tmppow(1:length(hzW));
end

% divide by N
eegpowW = eegpowW / length(winonsets);


%%% plotting
figure(2), clf, hold on

plot(hz,eegpow(1:length(hz)),'k','linew',2)
plot(hzW,eegpowW/10,'r','linew',2)
set(gca,'xlim',[0 40])
xlabel('Frequency (Hz)')
legend({'"Static FFT';'Welch''s method'})

%% MATLAB pwelch

figure(3), clf

% create Hann window
winsize = 2*srate; % 2-second window
hannw = .5 - cos(2*pi*linspace(0,1,winsize))./2;

% number of FFT points (frequency resolution)
nfft = srate*100;

pwelch(eegdata,hannw,round(winsize/4),nfft,srate);
set(gca,'xlim',[0 40])

%% done.
