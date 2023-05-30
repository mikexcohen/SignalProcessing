%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Time-domain denoising
%      VIDEO: Remove slow trends with polynomial fitting
% Instructor: sincxpress.com
%
%%

%% polynomial intuition

order = 0;
x = linspace(-15,15,100);

y = zeros(size(x));

for i=1:order+1
    y = y + randn*x.^(i-1);
end

figure(1), clf
hold on
plot(x,y,'linew',4)
title([ 'Order-' num2str(order) ' polynomial' ])


%% generate signal with slow polynomial artifact

n = 10000;
t = (1:n)';
k = 10; % number of poles for random amplitudes
slowdrift = interp1(100*randn(k,1),linspace(1,k,n),'pchip')';
signal = slowdrift + 20*randn(n,1);


figure(2), clf, hold on
h = plot(t,signal);
set(h,'color',[1 1 1]*.6)
xlabel('Time (a.u.)'), ylabel('Amplitude')

%% fit a 3-order polynomial

% polynomial fit (returns coefficients)
p = polyfit(t,signal,3);

% predicted data is evaluation of polynomial
yHat = polyval(p,t);

% compute residual (the cleaned signal)
residual = signal - yHat;


% now plot the fit (the function that will be removed)
plot(t,yHat,'r','linew',4)
plot(t,residual,'k','linew',2)

legend({'Original';'Polyfit';'Filtered signal'})

%%

%% Bayes information criterion to find optimal order

% possible orders
orders = (5:40)';

% sum of squared errors (sse is reserved!)
sse1 = zeros(length(orders),1); 

% loop through orders
for ri=1:length(orders)
    
    % compute polynomial (fitting time series)
    yHat = polyval(polyfit(t,signal,orders(ri)),t);
    
    % compute fit of model to data (sum of squared errors)
    sse1(ri) = sum( (yHat-signal).^2 )/n;
end

% Bayes information criterion
bic = n*log(sse1) + orders*log(n);

% best parameter has lowest BIC
[bestP,idx] = min(bic);

% would continue getting smaller without adding parameters

% plot the BIC
figure(4), clf, hold on
plot(orders,bic,'ks-','markerfacecolor','w','markersize',8)
plot(orders(idx),bestP,'ro','markersize',10,'markerfacecolor','r')
xlabel('Polynomial order'), ylabel('Bayes information criterion')
zoom on

%% now repeat filter for best (smallest) BIC

% polynomial fit
polycoefs = polyfit(t,signal,orders(idx));

% estimated data based on the coefficients
yHat = polyval(polycoefs,t);

% filtered signal is residual
filtsig = signal - yHat;


%%% plotting
figure(5), clf, hold on
h = plot(t,signal);
set(h,'color',[1 1 1]*.6)
plot(t,yHat,'r','linew',2)
plot(t,filtsig,'k')
set(gca,'xlim',t([1 end]))

xlabel('Time (a.u.)'), ylabel('Amplitude')
legend({'Original';'Polynomial fit';'Filtered'})

%% done.
