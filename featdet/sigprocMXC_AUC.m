%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Feature detection
%      VIDEO: Area under the curve
% Instructor: sincxpress.com
%
%%

% create signal
srate = 1000; % Hz
time  = 0:1/srate:3;
n     = length(time);
p     = 20; % poles for random interpolation

% amplitude modulator and noise level
signal = interp1(randn(p,1)*30,linspace(1,p,n),'spline')'.^2;
signal(signal<100) = 0;

figure(1), clf
plot(time,signal)

%% demarcate each lobe

% thresholded time series
threshts = logical(signal);

% find islands (in image processing toolbox!)
islands = bwconncomp( logical(signal) );

% color each island
for ii=1:islands.NumObjects
    patch(time([islands.PixelIdxList{ii}; islands.PixelIdxList{ii}(end-1:-1:1)]),[signal(islands.PixelIdxList{ii}); zeros(numel(islands.PixelIdxList{ii})-1,1)],rand(1,3));
end

%% compute AUC under each curve

auc = zeros(islands.NumObjects,1);

for ii=1:islands.NumObjects
    auc(ii) = sum( signal(islands.PixelIdxList{ii}) );
end

% scale by dt
auc = auc * mean(diff(time));



% add text on top of each curve
for ii=1:islands.NumObjects
    
    text(mean(time(islands.PixelIdxList{ii})),...
         50 + max(signal(islands.PixelIdxList{ii})),...
         num2str( round(auc(ii),2) ),...
         'HorizontalAlignment','center');
end

%% done.
