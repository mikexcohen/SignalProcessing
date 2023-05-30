%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Variability
%      VIDEO: Coefficient of variation
% Instructor: sincxpress.com
%
%%

% number of data points
nmeans = 100;
nstds  = 110;

% ranges of means (den.) and standard deviations (num.)
means = linspace(.1,5,nmeans);
stds  = linspace(.1,10,nstds);


% initialize matrix
cv = zeros(nmeans,nstds);

% loop over all values and populate matrix
for mi=1:nmeans
    for si=1:nstds
        % coefficient of variation
        cv(mi,si) = stds(si) / means(mi);
    end
end

% programming trick!
cv = bsxfun(@rdivide,stds,means');


% show in an image
figure(1), clf
imagesc(stds,means,cv)
set(gca,'clim',[0 30],'ydir','normal')
ylabel('Mean'), xlabel('Standard deviation')
colorbar

%% done.
