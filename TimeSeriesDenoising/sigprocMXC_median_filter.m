%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Time-domain denoising
%      VIDEO: Median filter to remove spike noise
% Instructor: sincxpress.com
%
%%

% create signal
n = 2000;
signal = cumsum(randn(n,1));


% proportion of time points to replace with noise
propnoise = .05;

% find noise points
noisepnts = randperm(n);
noisepnts = noisepnts(1:round(n*propnoise));

% generate signal and replace points with noise
signal(noisepnts) = 50+rand(size(noisepnts))*100;


% use hist to pick threshold
figure(1), clf
histogram(signal,100)
zoom on

% visual-picked threshold
threshold = 40;


% find data values above the threshold
suprathresh = find( signal>threshold );

% initialize filtered signal
filtsig = signal;

% loop through suprathreshold points and set to median of k
k = 20; % actual window is k*2+1
for ti=1:length(suprathresh)
    
    % find lower and upper bounds
    lowbnd = max(1,suprathresh(ti)-k);
    uppbnd = min(suprathresh(ti)+k,n);
    
    % compute median of surrounding points
    filtsig(suprathresh(ti)) = median(signal(lowbnd:uppbnd));
end

% plot
figure(2), clf
plot(1:n,signal, 1:n,filtsig, 'linew',2)
zoom on

%% done.

