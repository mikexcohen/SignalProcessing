%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Working with complex numbers
%      VIDEO: The complex conjugate
% Instructor: sincxpress.com
%
%%

% create a complex number
a = complex(4,-5);

% let MATLAB do the hard work
ac1 = conj(a);

% the "manual" way
ac2 = complex( real(a) , -imag(a) );

%% magnitude squared of a complex number

amag1 = a*conj(a);

amag2 = real(a)^2 + imag(a)^2;

amag3 = abs(a)^2;

%% done.
