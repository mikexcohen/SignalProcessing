%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Feature detection
%      VIDEO: Recover signal from noise amplitude
% Instructor: sincxpress.com
%
%%

%% create the signal

% create signal
srate = 1000; % Hz
time  = 0:1/srate:3;
n     = length(time);
p     = 20; % poles for random interpolation

% amplitude modulator and noise level
ampmod = interp1(rand(p,1)*30,linspace(1,p,n),'nearest')';
signal = ampmod .* randn(size(ampmod));

% plot
figure(1), clf
subplot(211)
plot(time,signal, time,ampmod,'linew',2)
xlabel('Time (s)'), ylabel('Amplitude (a.u.)')
legend({'Signal';'Source'})

%% options for identifying the original signal


subplot(212)


% rectify and lowpass filter
rectsig = abs(signal);
k = 9;
rectsig = filtfilt(ones(1,k)/k,1,rectsig);
plot(time,rectsig, time,ampmod,'linew',2)
legend({'Estimated';'True'})



% TKEO
tkeosig = signal;
tkeosig(2:end-1) = signal(2:end-1).^2 - signal(1:end-2).*signal(3:end);
plot(time,tkeosig, time,ampmod,'linew',2)
legend({'Estimated';'True'})



% magnitude of Hilbert transform
maghilb = abs(hilbert( signal ));

% running mean-filter
k = 9;
maghilb = filtfilt(ones(1,k)/k,1,maghilb);
plot(time,maghilb, time,ampmod,'linew',2)
legend({'Estimated';'True'})



% running-variance
k = 9;
runningVar = zeros(n,1);
for i=1:n
    startp = max(1,i-round(k/2));
    endp = min(round(k/2)+i,n);
    runningVar(i) = std(signal(startp:endp));
end
plot(time,runningVar, time,ampmod,'linew',2)
legend({'Estimated';'True'})



%%% plot all options
figure(2), clf, hold on
plot(time,rectsig,'b','linew',2)
% plot(time,tkeosig,'m','linew',2)
plot(time,maghilb,'k','linew',2)
plot(time,runningVar,'g','linew',2)
plot(time,ampmod,'r','linew',2)

set(gca,'ylim',[-1 max(ampmod)*2])
% legend({'Rectify';'TKEO';'Hilbert';'Variance';'Ground truth'})
legend({'Rectify';'Hilbert';'Variance';'Ground truth'})
xlabel('Time (sec.)')

%% compare the different algorithms to ground truth

% rectify
r2rect = corrcoef(ampmod,rectsig);
r2rect = r2rect(2)^2;

% TKEO
r2tkeo = corrcoef(ampmod,tkeosig);
r2tkeo = r2tkeo(2)^2;

% Hilbert
r2hilb = corrcoef(ampmod,maghilb);
r2hilb = r2hilb(2)^2;

% running variance
r2varr = corrcoef(ampmod,runningVar);
r2varr = r2varr(2)^2;


% now plot
figure(3), clf
bar([ r2rect r2hilb r2tkeo r2varr ])
set(gca,'xtick',1:4,'xticklabel',{'Rectify';'Hilbert';'TKEO';'Variance'})
ylabel('R^2 fit to truth')
title('Comparison of methods')

%% done.
