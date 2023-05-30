%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Resampling, interpolating, extrapolating
%      VIDEO: Dynamic time warping
% Instructor: sincxpress.com
%
%%

%% create signals

% different time vectors
tx = linspace(0,1.5*pi,400);
ty = linspace(0,8*pi,100);

% different signals
x = sin(tx.^2); % chirp
y = sin(ty);    % sine wave


% show them
figure(1), clf
subplot(311), hold on
plot(tx,x,'bs-','linew',1,'markerfacecolor','b')
plot(ty,y,'rs-','linew',1,'markerfacecolor','w','markersize',5)
xlabel('Time (rad.)')
title('Original')

%% distance matrix

% initialize distance matrix (dm) and set first element to zero
dm = nan(length(x),length(y));
dm(1) = 0;

for xi=2:length(x)
    for yi=2:length(y)
        cost = abs(x(xi)-y(yi)).^1;
        dm(xi,yi) = cost + min([ dm(xi-1,yi) dm(xi,yi-1) dm(xi-1,yi-1) ]);
    end
end

figure(2), clf
surf(dm), shading interp
colormap hot
view([90 -90])
rotate3d on
xlabel('x'), ylabel('y')

%%

% find minimum for each y
minpath = zeros(2,length(x));
for xi=1:size(dm,1)
    [minpath(1,xi),minpath(2,xi)] = min(dm(xi,:));
end


figure(1)
subplot(312), hold on
plot(tx,x,'bs-','linew',1,'markerfacecolor','b')
plot(tx,y(minpath(2,:)),'rs','linew',1,'markerfacecolor','w','markersize',5)
xlabel('Time (rad.)')
title('Warped')

%% using MATLAB's dtw function

% in the signal-processing toolbox!
[d2,warpx,warpy] = dtw(x,y);

figure(1)
subplot(313), hold on
plot(tx(warpx),x(warpx),'bs-','linew',1,'markerfacecolor','b')
plot(tx(warpx),y(warpy),'rs','linew',1,'markerfacecolor','w','markersize',5)
xlabel('Time (rad.)')
title('MATLAB dtw function')

%%
