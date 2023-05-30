%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Filtering
%      VIDEO: Use filtering to separate birds in a recording
% Instructor: sincxpress.com
%
%%

[bc,fs] = audioread('XC403881.mp3');
N = length(bc);

% compute and show spectrogram
[powspect,frex,time] = spectrogram(detrend(bc(:,2)),hann(1000),100,[],fs);
figure(1), clf
imagesc(time,frex,abs(powspect).^2)
axis xy
set(gca,'clim',[0 1]*2,'ylim',frex([1 dsearchn(frex,15000)]),'xlim',time([1 end]))
xlabel('Time (sec.)'), ylabel('Frequency (Hz)')
colormap hot

%% select frequency ranges (visual inspection)

frange{1} = [1700 2600];
frange{2} = [5100 6100];

% draw boundary lines on the plot
colorz = 'wm';
hold on
for fi=1:length(frange)
    plot(get(gca,'xlim'),[1 1]*frange{fi}(1),[colorz(fi) '--' ])
    plot(get(gca,'xlim'),[1 1]*frange{fi}(2),[colorz(fi) '--' ])
end

%% compute and apply FIR filters

% initialize output matrix
filteredSig = cell(2,1);

% loop over filters
for filteri=1:length(frange)
    
    % design filter kernel
    order    = round( 10*fs/frange{1}(1) );
    filtkern = fir1(order,frange{filteri}/(fs/2));
    
    % loop over channels
    for chani=1:2
        
        % get data from this channel
        dat1chan = bc(:,chani);
        
        % zero-phase-shift filter with reflection
        sigR = [dat1chan(end:-1:1); dat1chan; dat1chan(end:-1:1)]; % reflect
        fsig = filter(filtkern,1,sigR);                 % forward filter
        fsig = filter(filtkern,1,fsig(end:-1:1));       % reverse filter
        fsig = fsig(end:-1:1);                          % reverse again for 0phase
        fsig = fsig(N+1:end-N);                         % chop off reflected parts
        
        % enter into the matrix
        filteredSig{filteri}(:,chani) = fsig;
    end
end

%% play

% original
soundsc(bc,fs)

% lower frequency range
soundsc(filteredSig{1},fs)

% higher frequency range
soundsc(filteredSig{2},fs)

%% done.
