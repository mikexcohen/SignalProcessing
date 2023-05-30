%%
%     COURSE: Signal processing and image processing in MATLAB and Python
%    SECTION: Time-domain denoising
%      VIDEO: Code challenge: Denoise these signals!
% Instructor: mikexcohen.com
%
%%

N = 4000;

origSignal = linspace(-1,1,N) .* sin(linspace(0,10*pi,N)) + randn(1,N);
r = randperm(N);
nn = round(N*.05);
origSignal(r(1:nn)) = (1+rand(1,nn))*10;
origSignal(r(end-nn+1:end)) = -(1+rand(1,nn))*10;

cleanedSignal = origSignal;

% remove positive noise spikes
p2r = find(origSignal>5);
k = 5;
for i=1:length(p2r)
    cleanedSignal(p2r(i)) = median(cleanedSignal(max(1,p2r(i)-k):min(p2r(i)+k,N)));
end

% remove negative noise spikes
p2r = find(origSignal<-5);
k = 5;
for i=1:length(p2r)
    cleanedSignal(p2r(i)) = median(cleanedSignal(max(1,p2r(i)-k):min(p2r(i)+k,N)));
end

% mean-smooth
k = 150;
for i=1:N
    cleanedSignal(i) = mean(cleanedSignal(max(1,i-k):min(N,i+k)));
end


clf
subplot(211)
plot(1:N,origSignal,'linew',2)

subplot(212)
plot(1:N,cleanedSignal,'linew',2)

%% done.
