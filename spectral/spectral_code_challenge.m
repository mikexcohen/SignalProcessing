
% create signal
srate = 1000;
time  = -3:1/srate:3;
pnts  = length(time);
freqmod = exp(-time.^2)*10+10;
freqmod = freqmod + linspace(0,10,pnts);
signal  = sin( 2*pi * ((time + cumsum(freqmod))/srate) );


% plot the signal
figure(1), clf
subplot(411)
plot(time,signal,'linew',1)
xlabel('Time (s)')
title('Time-domain signal')


n  = 500;
hz = linspace(0,srate,n+1);
tf = zeros(floor(pnts/n)-1,length(hz));
tv = zeros(floor(pnts/n)-1,1);

for i=1:floor(pnts/n)-1
    datasnip = signal(i*n:(i+1)*n);
    
    pw = abs(fft(datasnip)).^2;
    tf(i,1:length(hz)) = pw(1:length(hz));
    tv(i) = mean(time(i*n:(i+1)*n));
end

subplot(4,1,2:4)
imagesc(tv,hz,tf')
axis xy
set(gca,'ylim',[0 40])
colormap hot
xlabel('Time (s)'), ylabel('Frequency (Hz)')




