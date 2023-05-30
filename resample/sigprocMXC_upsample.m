%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Resampling, interpolating, extrapolating
%      VIDEO: Upsampling
% Instructor: sincxpress.com
%
%%

%% low-sampling-rate data to upsample

% in Hz
srate = 10;

% just some numbers...
data  = [1 4 3 6 2 19];

% other parameters
npnts = length(data);
time  = (0:npnts-1)/srate;

% plot the original signal
figure(1), clf, hold on
plot(time,data,'ko-','markersize',15,'markerfacecolor','k','linew',3)

%% option 1: upsample by a factor

upsampleFactor = 4;
newNpnts = npnts*upsampleFactor;

% new time vector after upsampling
newTime = (0:newNpnts-1)/(upsampleFactor*srate);

%% option 2: upsample to desired frequency, then cut off points if necessary

% % in Hz
% newSrate = 37;
% 
% % need to round in case it's not exact
% newNpnts = round( npnts * (newSrate/srate) );
% 
% % new time vector after upsampling
% newTime = (0:newNpnts-1) / newSrate;

%% continue on to interpolation

% cut out extra time points
newTime(newTime>time(end)) = [];

% the new sampling rate actually implemented
newSrateActual = 1/mean(diff(newTime))



% define interpolation object
F = griddedInterpolant(time,data,'spline');

% query that object at requested time points
updataI = F(newTime);



% plot the upsampled signal
plot(newTime,updataI,'rs-','markersize',14,'markerfacecolor','r')
set(gca,'xlim',[0 max(time(end),newTime(end))])

%% using MATLAB's resample function (signal processing toolbox)

% new sampling rate in Hz
newSrate = 42;

% find p and q coefficients
[p,q] = rat( newSrate/srate);

% use resample function (sigproc toolbox)
updataR = resample(data,p,q);
 
% the new time vector
newTime = (0:length(updataR)-1)/newSrate;


% cut out extra time points
updataR(newTime>time(end)) = [];
newTime(newTime>time(end)) = [];


% and plot it
plot(newTime,updataR,'b^-','markersize',14,'markerfacecolor','b')
legend({'Original';'Interpolated';'resample'})

%% done.
