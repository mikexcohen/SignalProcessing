



t = linspace(-2*pi,2*pi,1000);
s = detrend(cumsum(randn(length(t),1)));
k = cos(6*t) .* exp(-t.^2);
k = k*(sum(k)*2*pi/7.7);
r = conv(s,k,'same');
hz = linspace(0,1,length(t));

clf
subplot(321), plot(t,s), axis tight, axis off
subplot(322), plot(t,k), axis tight, axis off

subplot(323), plot(hz,abs(fft(s))), axis tight, axis off
set(gca,'xlim',[0 .1])

subplot(324), plot(hz,abs(fft(k))), axis tight, axis off
set(gca,'xlim',[0 .1])


subplot(325), plot(t,r), axis tight, axis off
subplot(326), plot(hz,abs(fft(r))), axis tight, axis off
set(gca,'xlim',[0 .1])















