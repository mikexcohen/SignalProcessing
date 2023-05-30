%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Feature detection
%      VIDEO: Full-width at half-maximum
% Instructor: sincxpress.com
%
%%

%% Gaussian

% simulation parameters
srate = 1000;
time  = -2:1/srate:2;
fwhmA = .93; % seconds

gauswin = exp( -(4*log(2)*time.^2) / fwhmA^2 );
gauswinNorm = gauswin ./ max(gauswin); % normalize


figure(1), clf, hold on
plot(time,gauswinNorm,'k','linew',3)

% find the peak point
peakpnt = find( gauswin==max(gauswin) );


% find 50% PREpeak point
prepeak = dsearchn(gauswinNorm(1:peakpnt)',.5);


% find 50% POSTpeak point
pstpeak = dsearchn(gauswinNorm(peakpnt:end)',.5);
pstpeak = pstpeak + peakpnt - 1; % adjust


% compute empirical FWHM
fwhmE = time(pstpeak) - time(prepeak);



% plot the points
plot(time(peakpnt),gauswinNorm(peakpnt),'ko','markerfacecolor','r','markersize',15)
plot(time(prepeak),gauswinNorm(prepeak),'ko','markerfacecolor','g','markersize',15)
plot(time(pstpeak),gauswinNorm(pstpeak),'ko','markerfacecolor','g','markersize',15)

% plot line for reference
plot(time([prepeak pstpeak]),gauswinNorm([prepeak pstpeak]),'k--')
plot([1 1]*time(prepeak),[0 gauswinNorm(prepeak)],'k:')
plot([1 1]*time(pstpeak),[0 gauswinNorm(pstpeak)],'k:')
set(gca,'ylim',[0 1.05])
xlabel('Time (sec.)')

title([ 'Analytic: ' num2str(fwhmA) ', empirical: ' num2str(fwhmE) ])

%% example with asymmetric shape

% generate asymmetric distribution
[fx,x] = hist(exp(.5*randn(10000,1)),150);

% normalization necessary here!
fxNorm = fx./max(fx);

% plot the function
figure(2), clf, hold on
plot(x,fx,'ks-','linew',3,'markerfacecolor','w')


% find peak point
peakpnt = find( fxNorm==max(fxNorm) );


% find 50% PREpeak point
prepeak = dsearchn(fxNorm(1:peakpnt)',.5);


% find 50% POSTpeak point
pstpeak = dsearchn(fxNorm(peakpnt:end)',.5);
pstpeak = pstpeak + peakpnt - 1; % adjust

% compute empirical FWHM
fwhmE = x(pstpeak) - x(prepeak);



% plot the points
plot(x(peakpnt),fx(peakpnt),'ko','markerfacecolor','r','markersize',15)
plot(x(prepeak),fx(prepeak),'ko','markerfacecolor','g','markersize',15)
plot(x(pstpeak),fx(pstpeak),'ko','markerfacecolor','g','markersize',15)


% plot line for reference
plot(x([prepeak pstpeak]),fx([prepeak pstpeak]),'k--')
plot([1 1]*x(prepeak),[0 fx(prepeak)],'k:')
plot([1 1]*x(pstpeak),[0 fx(pstpeak)],'k:')

title([ 'Empirical FWHM: ' num2str(fwhmE) ])

%% an interesting aside...

% a range of standard deviations
sds = linspace(.1,.7,50);
fwhmE = zeros(size(sds));

for i=1:length(sds)
    
    % new data
    [fx,x] = hist(exp(sds(i)*randn(10000,1)),150);
    
    % normalization necessary here!
    fxNorm = fx./max(fx);
    
    % find peak point
    peakpnt = find( fxNorm==max(fxNorm) );
    prepeak = dsearchn(fxNorm(1:peakpnt)',.5);
    pstpeak = dsearchn(fxNorm(peakpnt:end)',.5);
    pstpeak = pstpeak + peakpnt - 1; % adjust
    
    % FWHM
    fwhmE(i) = x(pstpeak(1)) - x(prepeak(1));
end

% plot
figure(3), clf
plot(sds,fwhmE,'s-','markersize',15,'markerfacecolor','k')
xlabel('Stretch parameter')
ylabel('Empirical FWHM')

%% done.
