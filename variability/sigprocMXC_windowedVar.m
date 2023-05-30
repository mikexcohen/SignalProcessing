%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Variability
%      VIDEO: Total and windowed variance and RMS
% Instructor: sincxpress.com
%
%%

% generate signal with varying variability
n = 2000;
p = 20; % poles for random interpolation

% amplitude modulator
ampmod = interp1(rand(p,1)*30,linspace(1,p,n),'nearest')';
ampmod = ampmod + mean(ampmod)/3*sin(linspace(0,6*pi,n))';

% signal and modulated noise plus quadratic
signal = ampmod .* randn(size(ampmod));
signal = signal + linspace(-10,20,n)'.^2;


% plot the signal
figure(1), clf
plot(signal)

%% compute windowed variance and RMS

% window size (NOTE: actual window is halfwin*2+1)
halfwin = 25; % in points

[var_ts,rms_ts] = deal( zeros(n,1) );

for ti=1:n
    
    % boundary points
    low_bnd = max(1,ti-halfwin);
    upp_bnd = min(n,ti+halfwin);
    
    % signal segment
    tmpsig = signal(low_bnd:upp_bnd);
    
    % compute variance and RMS in this window
    var_ts(ti) = var(tmpsig);
    rms_ts(ti) = sqrt(mean( tmpsig.^2 ));
end


% and plot
figure(2), clf, hold on

plot(var_ts,'r','linew',2)
plot(rms_ts,'b','linew',2)
legend({'Variance';'RMS'})

%% done.
