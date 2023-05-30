%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Convolution
%      VIDEO: The convolution theorem
% Instructor: sincxpress.com
%
%%

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

%% time-domain convolution

half_kern = floor(nKern/2);

% flipped version of kernel
kflip = kernel(end:-1:1);

% zero-padded data for convolution
dat4conv = [ zeros(1,half_kern) signal zeros(1,half_kern) ];

% initialize convolution output
conv_res = zeros(1,nConv);

% run convolution
for ti=half_kern+1:nConv-half_kern
    
    % get a chunk of data
    tempdata = dat4conv(ti-half_kern:ti+half_kern);
    
    % compute dot product (don't forget to flip the kernel backwards!)
    conv_res(ti) = sum( tempdata.*kflip );
end

% cut off edges
conv_res = conv_res(half_kern+1:end-half_kern);

%% convolution implemented in the frequency domain

% spectra of signal and kernel
signalX = fft(signal,nConv);
kernelX = fft(kernel,nConv);

% element-wise multiply
sigXkern = signalX .* kernelX;

% inverse FFT to get back to the time domain
conv_resFFT = ifft( sigXkern );


% cut off edges
conv_resFFT = conv_resFFT(half_kern+1:end-half_kern);


%% plot for comparison

figure(1), clf, hold on
plot(conv_res,'o-','linew',2,'markerface','g','markersize',9)
plot(conv_resFFT,'o-','linew',2,'markerface','r','markersize',3)

legend({'Time domain';'Freq domain'})

%% done.
