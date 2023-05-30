


frex = linspace(4,30,40);

SNR = zeros(length(frex),2);
srate = 1000./mean(diff(timevec));

for fi=1:length(frex)
    
    erpf = eegfilt(erp,srate,0,frex(fi));
    
    % SNR components
    snr_num = erpf(:,dsearchn(timevec',timepoint));
    snr_den = std( erpf(:,dsearchn(timevec',basetime(1)):dsearchn(timevec',basetime(2))) ,[],2);
    
    SNR(fi,:) = snr_num./snr_den;
end

clf
plot(frex,SNR,'s-','markerfacecolor','w','linew',2,'markersize',10)
xlabel('Low-pass upper-edge (Hz)'), ylabel('SNR')
legend({'Chan1';'Chan2'})
set(gca,'xlim',[3.5 30.5])
