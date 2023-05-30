%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Resampling, interpolating, extrapolating
%      VIDEO: Resample irregularly sampled data
% Instructor: sincxpress.com
%
%%

% simulation parameters
srate    = 1324;    % Hz
peakfreq =    7;    % Hz
fwhm     =    5;    % Hz
npnts    = srate*2; % time points
timevec  = (0:npnts-1)/srate; % seconds

% frequencies
hz = linspace(0,srate,npnts);
s  = fwhm*(2*pi-1)/(4*pi); % normalized width
x  = hz-peakfreq;          % shifted frequencies
fg = exp(-.5*(x/s).^2);    % gaussian


% Fourier coefficients of random spectrum
fc = rand(1,npnts) .* exp(1i*2*pi*rand(1,npnts));

% taper with Gaussian
fc = fc .* fg;

% go back to time domain to get signal
signal = 2*real( ifft(fc) )*npnts;


%%% plot 
figure(1), clf, hold on
plot(timevec,signal,'k','linew',3)
xlabel('Time (s)')

%% now randomly sample from this "continuous" time series

% initialize to empty
sampSig = [];


% random sampling intervals
sampintervals = cumsum([ 1; ceil( exp(4*rand(npnts,1)) ) ]);
sampintervals(sampintervals>npnts) = []; % remove points beyond the data


% loop through sampling points and "measure" data
for i=1:length(sampintervals)
    
    % "real world" measurement
    nextdat = [signal(sampintervals(i)); timevec(sampintervals(i))];
    
    % put in data matrix
    sampSig = cat(2,sampSig,nextdat);
end

% more plotting
plot(sampSig(2,:),sampSig(1,:),'ro','markerfacecolor','r','markersize',12)

%% upsample to original sampling rate


% define interpolation object
F = griddedInterpolant(sampSig(2,:),sampSig(1,:),'spline');

% query that object at requested time points
newsignal = F(timevec);


% and plot
plot(timevec,newsignal,'ms','markersize',10,'markerfacecolor','m')
legend({'"Analog"';'Measured';'Upsampled'})

%% done.
