%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Time-domain denoising
%      VIDEO: Remove linear trend
% Instructor: sincxpress.com
%
%%

% create signal with linear trend imposed
n = 2000;
signal = cumsum(randn(1,n)) + linspace(-30,30,n);

% linear detrending
detsignal = detrend(signal);

% plot signal and detrended signal
figure(1), clf
plot(1:n,signal, 1:n,detsignal,'linew',3)
legend({ ['Original (mean=' num2str(mean(signal)) ')' ];[ 'Detrended (mean=' num2str(mean(detsignal)) ')' ]})

%% done.
