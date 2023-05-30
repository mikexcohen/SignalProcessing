%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Filtering
%      VIDEO: Data length and filter kernel length
% Instructor: sincxpress.com
%
%%

% parameters
dataN = 10000;
filtN = 5001;

% generate data
signal = randn(dataN,1);

% create filter kernel
fkern = fir1(filtN,.01,'low');

% apply filter kernel to data
fdata = filtfilt(fkern,1,signal);

%%%  --------------  %%%
%  Is there an error?  %
%%%  --------------  %%%

%%

% use reflection to increase signal length!
signalRefl = [ signal(end:-1:1) signal signal(end:-1:1) ];


% apply filter kernel to data
fdataR = filtfilt(fkern,1,signalRefl);

% and cut off edges
fdata = fdataR(dataN+1:end-dataN);


%% done.
