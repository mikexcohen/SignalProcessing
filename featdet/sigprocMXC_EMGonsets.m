%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Feature detection
%      VIDEO: Detect muscle movements from EMG recordings
% Instructor: sincxpress.com
%
%%

% load data
load EMGRT.mat
N = length(rts);

% example trials
trials2plot = [ 4 23 ];


%%% a few plots to get an idea of the data
figure(1), clf

% RTs (button presses)
subplot(221)
plot(rts,'s-','markerfacecolor','w')
xlabel('Trials'), ylabel('Reaction times (ms)')
set(gca,'xlim',[0 N+1])


% histogram of RTs
subplot(222)
histogram(rts,40)
xlabel('Reaction times (ms)'), ylabel('Count')

subplot(212)
[~,sidx] = sort(rts,'descend');
plot(timevec,bsxfun(@plus,emg(sidx,:),(1:200)'*1500),'k')
xlabel('Time (ms)')
set(gca,'ytick',[])
axis tight



figure(2), clf

% two example trials
for i=1:2
    subplot(2,1,i), hold on
    
    % plot EMG trace
    plot(timevec,emg(trials2plot(i),:),'r','linew',1)
    
    % overlay button press time
    plot([1 1]*rts(trials2plot(i)),get(gca,'ylim'),'k--','linew',1)
    
    xlabel('Time (ms)')
    legend({'EMG';'Button press'})
end

%% detect EMG onsets

% define baseline time window for normalization
baseidx = dsearchn(timevec',[-500 0]');

% pick z-threshold
zthresh = 100;

% initialize outputs
emgonsets = zeros(N,1);

for triali=1:N
    
    % convert to energy via TKEO
    tkeo = emg(triali,2:end-1).^2 - emg(triali,1:end-2) .* emg(triali,3:end);
    
    % convert to zscore from pre-0 activity
    tkeo = ( tkeo-mean(tkeo(baseidx(1):baseidx(2))) ) ./ std(tkeo(baseidx(1):baseidx(2)));
    
    % find first suprathreshold point
    tkeoThresh = tkeo>zthresh;
    tkeoThresh(timevec<0) = 0;
    tkeoPnts = find(tkeoThresh);
    
    % grab the first suprathreshold point
    emgonsets(triali) = timevec( tkeoPnts(1)+1 );
end


%% more plots

% back to the EMG traces...
figure(2)
for i=1:2
    subplot(2,1,i)
    plot([1 1]*emgonsets(trials2plot(i)),get(gca,'ylim'),'b--','linew',2)
    legend({'EMG';'Button press';'EMG onset'})
end


% plot onsets by RTs
figure(3), clf

subplot(211), hold on
plot(emgonsets,'ks','markerfacecolor','k','markersize',10)
plot(rts,'bo','markerfacecolor','b','markersize',10)
xlabel('Trial'), ylabel('Time (ms)')
legend({'EMG onsets';'Button times'})


subplot(212)
plot(rts,emgonsets,'bo','markerfacecolor','b','markersize',5)
xlabel('Button press time')
ylabel('EMG onset time')
axis square


%% done.
