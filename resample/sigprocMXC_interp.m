%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Resampling, interpolating, extrapolating
%      VIDEO: Interpolating
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

% plot the original data
figure(1), clf
subplot(221)
plot(time,data,'go','markersize',15,'markerfacecolor','m')

% amplitude spectrum
figure(2), clf
plot(linspace(0,1,npnts),abs(fft(data/npnts)),'go-','markerfacecolor','m','linew',4,'markersize',8)
xlabel('Frequency (a.u.)')

%% interpolation

% new time vector for interpolation
N = 47;
newTime = linspace(time(1),time(end),N);

% different interpolation options
interpOptions = {'linear';'next';'nearest';'spline'};
interpColors  = 'brkm';
interpShapes  = 'sd^p';

for methodi=1:length(interpOptions)
    
    %% using griddedInterpolant
    
    % define interpolation object
    F = griddedInterpolant(time,data,interpOptions{methodi});
    
    % query that object at requested time points
    newdata = F(newTime);
    
    %% using interp1 (same as above)
    
    newdata = interp1(time,data,newTime,interpOptions{methodi});
    
    %% plots
    
    figure(1)
    subplot(2,2,methodi), hold on
    plot(newTime,newdata,'ks-','markersize',10,'markerfacecolor','w')
    plot(time,data,'go','markersize',15,'markerfacecolor','m')
    
    % make the axis a bit nicer
    set(gca,'xlim',[0 max(time(end),newTime(end))])
    title([ '''' interpOptions{methodi} '''' ]) % 4 single quotes here to get a single quote of text!
    axis square
    
    figure(2), hold on
    plot(linspace(0,1,N),abs(fft(newdata/N)),[ interpColors(methodi) interpShapes(methodi) '-' ],'markerfacecolor',interpColors(methodi))
    
end
 
% adjust spectral plot
figure(2)
set(gca,'xlim',[0 .5])
legend(cat(1,'original',interpOptions))

%% done.
