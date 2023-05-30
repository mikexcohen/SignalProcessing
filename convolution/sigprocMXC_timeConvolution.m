%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Convolution
%      VIDEO: Time-domain convolution
% Instructor: sincxpress.com
%
%%

%% first example to build intuition

signal = [ zeros(1,30) ones(1,2) zeros(1,20) ones(1,30) 2*ones(1,10) zeros(1,30) -ones(1,10) zeros(1,40) ];
kernel = exp( -linspace(-2,2,20).^2 );
kernel = kernel./sum(kernel);

figure(1), clf
subplot(311)
plot(kernel,'k','linew',3)
set(gca,'xlim',[0 length(signal)])
title('Kernel')

subplot(312)
plot(signal,'k','linew',3)
set(gca,'xlim',[0 length(signal)])
title('Signal')


subplot(313)
plot( conv(signal,kernel,'same') ,'k','linew',3)
set(gca,'xlim',[0 length(signal)])
title('Convolution result')

%% a simple example in more detail


%% generate signal and kernel

% signal
signal = zeros(1,20);
signal(8:15) = 1;

% convolution kernel
kernel = [1 .8 .6 .4 .2];

% convolution sizes
nSign = length(signal);
nKern = length(kernel);
nConv = nSign + nKern - 1;


figure(2), clf
% plot the signal
subplot(311)
plot(signal,'o-','linew',2,'markerface','g','markersize',9)
set(gca,'ylim',[-.1 1.1],'xlim',[1 nSign])
title('Signal')

% plot the kernel
subplot(312)
plot(kernel,'o-','linew',2,'markerface','r','markersize',9)
set(gca,'xlim',[1 nSign],'ylim',[-.1 1.1])
title('Kernel')


% plot the result of convolution
subplot(313)
plot(conv(signal,kernel,'same'),'o-','linew',2,'markerface','b','markersize',9)
set(gca,'xlim',[1 nSign],'ylim',[-.1 3.6])
title('Result of convolution')

%% convolution in animation

half_kern = floor(nKern/2);

% flipped version of kernel
kflip = kernel(end:-1:1);%-mean(kernel);

% zero-padded data for convolution
dat4conv = [ zeros(1,half_kern) signal zeros(1,half_kern) ];

% initialize convolution output
conv_res = zeros(1,nConv);


%%% initialize plot
figure(3), clf, hold on
plot(dat4conv,'o-','linew',2,'markerface','g','markersize',9)
hkern = plot(kernel,'o-','linew',2,'markerface','r','markersize',9);
hcres = plot(kernel,'s-','linew',2,'markerface','k','markersize',15);
set(gca,'ylim',[-1 1]*3,'xlim',[0 nConv+1])
plot([1 1]*(half_kern+1),get(gca,'ylim'),'k--')
plot([1 1]*(nConv-2),get(gca,'ylim'),'k--')
legend({'Signal';'Kernel (flip)';'Convolution'})

% run convolution
for ti=half_kern+1:nConv-half_kern
    
    % get a chunk of data
    tempdata = dat4conv(ti-half_kern:ti+half_kern);
    
    % compute dot product (don't forget to flip the kernel backwards!)
    conv_res(ti) = sum( tempdata.*kflip );
    
    % update plot
    set(hkern,'XData',ti-half_kern:ti+half_kern,'YData',kflip);
    set(hcres,'XData',half_kern+1:ti,'YData',conv_res(half_kern+1:ti))
    
    pause(.5)
    
end

% cut off edges
conv_res = conv_res(half_kern+1:end-half_kern);


%% compare with MATLAB function

figure(4), clf

matlab_conv = conv(signal,kernel,'same');

plot(conv_res,'o-','linew',2,'markerface','g','markersize',9)
hold on
plot(matlab_conv,'o-','linew',2,'markerface','r','markersize',3)
legend({'Time-domain convolution';'Matlab conv function'})

%% done.
