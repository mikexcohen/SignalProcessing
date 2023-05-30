%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Resampling, interpolating, extrapolating
%      VIDEO: Spectral interpolation
% Instructor: sincxpress.com
%
%%

% number of points in signal
n = 10000;

% create signal
[origsig,signal] = deal( cumsum( randn(n,1) ) );


% remove a specified window
boundaryPnts = [ 5000 6500 ];
signal(boundaryPnts(1):boundaryPnts(2)) = 0/0;


% FFTs of pre- and post-window data
fftPre = fft(signal( boundaryPnts(1)-diff(boundaryPnts)-1:boundaryPnts(1)-1) );
fftPst = fft(signal( boundaryPnts(2)+1:boundaryPnts(2)+diff(boundaryPnts)+1) );

% interpolated signal is a combination of mixed FFTs and straight line
mixeddata = detrend(ifft( ( fftPre+fftPst )/2 ));
linedata  = linspace(0,1,diff(boundaryPnts)+1)'*(signal(boundaryPnts(2)+1)-signal(boundaryPnts(1)-1)) + signal(boundaryPnts(1)-1);

% sum together for final result
linterp = mixeddata + linedata;

% put the interpolated piece into the signal
filtsig = signal;
filtsig(boundaryPnts(1):boundaryPnts(2)) = linterp;

figure(1), clf
plot(1:n,[origsig signal+5 filtsig+10])
legend({'Original';'With gap';'Filtered'})
zoom on

%% done.
