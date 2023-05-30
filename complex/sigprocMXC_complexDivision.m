%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Working with complex numbers
%      VIDEO: Division with complex numbers
% Instructor: sincxpress.com
%
%%

% create two complex numbers
a = complex(4,-5);
b = complex(7,8);

% let MATLAB do the hard work
adb1 = a/b;

% the "manual" way
adb2 = (a*conj(b)) / (b*conj(b));

%% done.
