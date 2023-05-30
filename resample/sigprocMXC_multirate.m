%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Resampling, interpolating, extrapolating
%      VIDEO: Strategies for multirate signals
% Instructor: sincxpress.com
%
%%

%% create multichannel signal with multiple sampling rates

% initialize signals, time vectors, and sampling rates
% note: hard-coded to three signals
[fs,timez,signals] = deal( cell(3,1) );


% sampling rates in Hz
fs{1} = 10;
fs{2} = 40;
fs{3} = 83;

% create signals
for si=1:3
    
    % create signal
    signals{si} = cumsum( sign(randn(fs{si},1)) );
    
    % create time vector
    timez{si} = (0:fs{si}-1)/fs{si};
end



% plot all signals
figure(1), clf, hold on

color = 'kbr';
shape = 'os^';
for si=1:3
    plot(timez{si},signals{si},[ color(si) shape(si) '-' ],'linew',1,'markerfacecolor','w','markersize',6)
end
axlims = axis;
xlabel('Time (s)')

%% upsample to fastest frequency

% in Hz
[newSrate,whichIsFastest] = max(cell2mat(fs));

% need to round in case it's not exact
newNpnts = round( length(signals{whichIsFastest}) * (newSrate/fs{whichIsFastest}) );

% new time vector after upsampling
newTime = (0:newNpnts-1) / newSrate;

%% continue on to interpolation

% initialize (as matrix!)
newsignals = zeros(length(fs),length(newTime));

for si=1:length(fs)
    
    % define interpolation object
    F = griddedInterpolant(timez{si},signals{si},'spline');
    
    % query that object at requested time points
    newsignals(si,:) = F(newTime);
end

%% plot for comparison

% plot all signals
figure(2), clf, hold onplot for comparison

% plot all signals
figure(2), clf, hold on

for si=1:3
    plot(newTime,newsignals(si,:),[ color(si) shape(si) '-' ],'linew',1,'markerfacecolor','w','markersize',6)
end

% set axis limits to match figure 1
axis(axlims)

for si=1:3
    plot(newTime,newsignals(si,:),[ color(si) shape(si) '-' ],'linew',1,'markerfacecolor','w','markersize',6)
end

% set axis limits to match figure 1
axis(axlims)

%% done.
