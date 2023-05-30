%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Resampling, interpolating, extrapolating
%      VIDEO: Extrapolating
% Instructor: sincxpress.com
%
%%

% get the landscape
signal  = [1 4 3 6 2 19];
timevec = 1:length(signal);

figure(1), clf, hold on
h = plot(timevec,signal,'ks-','markersize',8,'markerfacecolor','y');

%% two methods of extrapolation

times2extrap = -length(signal):2*length(signal);

% extrapolate using linear and spline methods.
Flin  = griddedInterpolant(timevec,signal,'linear');
Fspl  = griddedInterpolant(timevec,signal,'spline');

% query data points
extrapLin = Flin(times2extrap);
extrapSpl = Fspl(times2extrap);

%% plot them

% linear
plot(times2extrap,extrapLin,'ro-','markersize',10,'markerfacecolor','w')

% spline
plot(times2extrap,extrapSpl,'bp-','markersize',10,'markerfacecolor','w')

legend({'original';'linear';'spline'},'location','northwest')
uistack(h,'top') % put original signal on top
zoom on

%% done.
