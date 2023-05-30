%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Resampling, interpolating, extrapolating
%      VIDEO: Code challenge
% Instructor: sincxpress.com
%
%%

% slowish signal (interp1 + narrowband noise)
% GOAL: 
%  denoise and downsample to regular



% create signal
srate = 1000; % Hz
[origT,time] = deal( 0:1/srate:3 );
n     = length(time);
p     = 20; % poles for random interpolation

% amplitude modulator and noise level
ampmod = interp1(rand(p,1)*30,linspace(1,p,n),'nearest')';


peakfreq =    7;    % Hz
fwhm     =    5;    % Hz

% frequencies
hz = linspace(0,srate,n)';
s  = fwhm*(2*pi-1)/(4*pi); % normalized width
x  = hz-peakfreq;          % shifted frequencies
fg = exp(-.5*(x/s).^2);    % gaussian


% Fourier coefficients of random spectrum
fc = rand(n,1) .* exp(1i*2*pi*rand(n,1));

% taper with Gaussian
fc = fc .* fg;

% go back to time domain to get signal
greal = 2*real( ifft(fc) )*n;




[origS,signal] = deal( ampmod + greal );


figure(1), clf
plot(time,signal,'linew',3)

%%

%  add some NaNs
randnans = randperm(n);
randnans = randnans(1:round(n*.2));
signal(randnans) = nan;



%  add noise bursts
signal(290:310) = signal(290:310) + 70*randn(size(signal(290:310)));
signal(1290:1310) = signal(1290:1310) + 70*randn(size(signal(1290:1310)));


%  fake irregular time stamps
tokill = [];
for i=1:n
    if rand>.8, tokill = [tokill i]; end
end

time(tokill) = [];
signal(tokill) = [];


plot(time,signal,'ks-','linew',3)
hold on
plot(origT,origS,'r','linew',3)

save resample_codeChallenge.mat time signal origT origS


%%














