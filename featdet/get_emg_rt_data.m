
load /home/mxc/apples/raw/pp24_ready.mat

rts = zeros(200,1);
emg = zeros(200,EEG.pnts);

for i=1:200
    
    [~,loc0] = min(abs(cell2mat(EEG.epoch(i).eventlatency)));
    rts(i) = EEG.epoch(i).eventlatency{loc0+1};
    
    emg(i,:) = EEG.data(64+EEG.epoch(i).eventtype{loc0+1},:,i);
    
end

% for i=1:200
%     plot(EEG.times,emg(i,:))
%     pause(.1)
% end

timevec = EEG.times;
save EMGRT.mat rts emg timevec





