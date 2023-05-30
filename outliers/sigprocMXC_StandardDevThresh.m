%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Outlier detection
%      VIDEO: Outliers via standard deviation threshold
% Instructor: sincxpress.com
%
%%

%%% signal is log-normal noise
N = 10000;
time = (1:N)/N;
signal  = exp( .5*randn(N,1) );

% add some random outiers
nOutliers = 50;
randpnts = randi(N,[nOutliers,1]);
signal(randpnts) = rand(nOutliers,1) * range(signal)*10;

% show the signal
figure(1), clf, hold on
plot(time,signal,'ks-','markerfacecolor','k')


% auto-threshold based on mean and standard deviation
threshold = mean(signal)+3*std(signal);
plot(time([1 end]),[1 1]*threshold,'k--')

%% interpolate outlier points

% remove supra-threshold points
outliers = signal > threshold;


% and interpolate missing points
F = griddedInterpolant(time(~outliers),signal(~outliers));
signalR = signal;
signalR(outliers) = F(time(outliers));

% and plot the new results
plot(time,signalR,'ro-')

%% done.
