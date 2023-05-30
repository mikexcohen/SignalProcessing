

% window size as percent of total signal length
pct_win = linspace(.1,20,40); % in percent, not proportion!

rmsz = zeros(length(pct_win),n);

for p=1:length(pct_win)
    
    % convert to indices
    k = round(n * pct_win(p)/2/100);
    
    
    for ti=1:n
        
        % boundary points
        low_bnd = max(1,ti-k);
        upp_bnd = min(n,ti+k);
        
        % signal segment (and mean-center!)
        tmpsig = signal(low_bnd:upp_bnd);
        tmpsig = tmpsig - mean(tmpsig);
        
        % compute RMS in this window
        rmsz(p,ti) = sqrt(sum( tmpsig.^2 ));
    end
    
end

%

figure(3), clf
subplot(511)
plot(log(rms_ts),'s-')

subplot(5,1,2:5)
contourf(1:n,pct_win,log(rmsz),40,'linecolor','none')
ylabel('Window size (%)'), xlabel('Time')
set(gca,'clim',[1 4.5])


