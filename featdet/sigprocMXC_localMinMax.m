%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Feature detection
%      VIDEO: Local maxima and minima
% Instructor: sincxpress.com
%
%%

% signal is sinc plus linear trend
time   = linspace(-4*pi,16*pi,1000);
signal = sin(time)./time + linspace(1,-1,length(time));


% plot the signal
figure(1), clf, hold on
plot(time,signal,'k','linew',2)
xlabel('Time'), ylabel('Amp. (a.u.)')
% adjust axis limits
set(gca,'xlim',time([1 end]),'ylim',[min(signal) max(signal)]*1.1)


% find global maximum
[maxval,maxidx] = max(signal);
plot(time(maxidx),maxval,'ko','linew',2,'markersize',15,'markerfacecolor','g')

%% "hack" method for local extrema

% "local" minimum is the "global" minimum in a restricted range
range4max = [0 5];
rangeidx  = dsearchn(time',range4max');

[maxLval,maxLidx] = min(signal(rangeidx(1):rangeidx(2)));
% plot it (note the -1 offset!)
plot(time(maxLidx+rangeidx(1)-1),maxLval,'ko','linew',2,'markersize',15,'markerfacecolor','r')

%% local minima/maxima

% find local maxima and plot
peeks1 = find(diff(sign(diff(signal)))<0)+1;
plot(time(peeks1),signal(peeks1),'ro','linew',2,'markersize',10,'markerfacecolor','y')

% try again using detrended signal
peeks2 = find(diff(sign(diff( detrend(signal) )))<0)+1;
plot(time(peeks2),signal(peeks2),'bs','linew',2,'markersize',10,'markerfacecolor','b')

% in the signal processing toolbox:
[~,peeks3] = findpeaks(signal);
plot(time(peeks3),signal(peeks3),'gp','linew',2,'markersize',10,'markerfacecolor','b')

%% done.
