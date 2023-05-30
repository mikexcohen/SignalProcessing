%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Working with complex numbers
%      VIDEO: Multiplication with complex numbers
% Instructor: sincxpress.com
%
%%

% create two complex numbers
a = complex(4,5);
b = 3+2i;

% let MATLAB do the hard work
z1 = a*b;

% the intuitive-but-WRONG way
z2 = complex( real(a)*real(b) , imag(a)*imag(b) );

% the less-intuitive-but-CORRECT way
ar = real(a);
ai = imag(a);
br = real(b);
bi = imag(b);

z3 = (ar + 1i*ai) * (br + 1i*bi);
z4 = (ar*br) + (ar*(1i*bi)) + ((1i*ai)*br) + ((1i*ai)*(1j*bi));

%% done.
