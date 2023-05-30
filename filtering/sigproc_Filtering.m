%%
%     COURSE: Signal processing and image processing in MATLAB and Python
%    SECTION: Filtering
%      VIDEO: Code challenge: Filter these signals!
% Instructor: mikexcohen.com
%
%%


fs = 1000;
N = 10000;
x = randn(N,1);



%%% lowpass
fcutoff = 30;
transw  = .2;
order   = round( 5*fs/fcutoff );
shape   = [ 1 1 0 0 ];
frex    = [ 0 fcutoff fcutoff+fcutoff*transw fs/2 ] / (fs/2);


% filter 
filtkern = firls(order,frex,shape);
y = filtfilt(filtkern,1,x);


%%% highpass
fcutoff = 5;
transw  = .05;
order   = round( 5*fs/fcutoff );
shape   = [ 0 0 1 1 ];
frex    = [ 0 fcutoff fcutoff+fcutoff*transw fs/2 ] / (fs/2);

% filter 
filtkern = firls(order,frex,shape);
y = filtfilt(filtkern,1,y);


%%% notch
fcutoff = [ 18 24 ];
transw  = .1;
order   = round( 5*fs/fcutoff(1) );
shape   = [ 1 1 0 0 1 1 ];
frex    = [ 0 fcutoff(1)*(1-transw) fcutoff fcutoff(2)+fcutoff(2)*transw fs/2 ] / (fs/2);

% filter 
filtkern = firls(order,frex,shape);
y = filtfilt(filtkern,1,y);






clf
subplot(211), hold on
plot(x,'r')
plot(y,'k')
title('Time domain')

yX = abs(fft(y)).^2;
xX = abs(fft(x)).^2;
hz = linspace(0,fs,N);

subplot(212), hold on
plot(hz,xX,'r');
plot(hz,yX,'k');
set(gca,'xlim',[0 80])
title('Frequency domain')

legend({'X';'Y'})


%%











