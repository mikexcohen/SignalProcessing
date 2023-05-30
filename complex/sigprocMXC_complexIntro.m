%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Working with complex numbers
%      VIDEO: From the number line to the complex number plane
% Instructor: sincxpress.com
%
%%

%% the imaginary operator

clear
i
j
1i
1j
sqrt(-1)

% but...
i = 2;
1i = 2;


%% creating complex numbers

% several ways to create a complex number
z = 4 + 3i;
z = 4 + 3*1i;
z = 4 + 3*sqrt(-1);
z = complex(4,3);

disp([ 'Real part is ' num2str(real(z)) ' and imaginary part is ' num2str(imag(z)) '.' ])


% beware of a common programming error:
i = 2;
zz = 4 + 3*i;


%% plotting a complex number

figure(1), clf
plot(real(z),imag(z),'s','markersize',12,'markerfacecolor','k')

% make plot look nicer
set(gca,'xlim',[-5 5],'ylim',[-5 5])
grid on, hold on, axis square
plot(get(gca,'xlim'),[0 0],'k','linew',2)
plot([0 0],get(gca,'ylim'),'k','linew',2)
xlabel('Real axis')
ylabel('Imaginary axis')
title([ 'Number (' num2str(real(z)) ' ' num2str(imag(z)) 'i) on the complex plane' ])


%% done.
