%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Time-domain denoising
%      VIDEO: Remove artifact via least-squares template-matching
% Instructor: sincxpress.com
%
%%

% load dataset
load templateProjection.mat


% initialize residual data
resdat = zeros(size(EEGdat));

% loop over trials
for triali=1:size(resdat,2)
    
    % build the least-squares model as intercept and EOG from this trial
    X = [ ones(npnts,1) eyedat(:,triali) ];
    
    % compute regression coefficients for EEG channel
    b = (X'*X) \ (X'*EEGdat(:,triali));
    
    % predicted data
    yHat = X*b;
    
    % new data are the residuals after projecting out the best EKG fit
    resdat(:,triali) = ( EEGdat(:,triali) - yHat )';
end

%% plotting

% trial averages
figure(1), clf
plot(timevec,mean(eyedat,2), timevec,mean(EEGdat,2), timevec,mean(resdat,2),'linew',2)
legend({'EOG';'EEG';'Residual'})
xlabel('Time (ms)')


% show all trials in a map
clim = [-1 1]*20;

figure(2), clf
subplot(131)
imagesc(timevec,[],eyedat')
set(gca,'clim',clim)
xlabel('Time (ms)'), ylabel('Trials')
title('EOG')


subplot(132)
imagesc(timevec,[],EEGdat')
set(gca,'clim',clim)
xlabel('Time (ms)'), ylabel('Trials')
title('EOG')


subplot(133)
imagesc(timevec,[],resdat')
set(gca,'clim',clim)
xlabel('Time (ms)'), ylabel('Trials')
title('Residual')

%% done.
