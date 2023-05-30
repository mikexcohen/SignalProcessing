%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Working with complex numbers
%      VIDEO: Magnitude and phase of complex numbers
% Instructor: sincxpress.com
%
%%

% create a complex number
z = 4 + 3i;

% plot the complex number
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

%% compute magnitude and phase of the complex number

% magnitude of the number (distance to origin)
magZ1 = sqrt( real(z)^2 + imag(z)^2 );
magZ2 = abs( z );

% angle of the line relative to positive real axis
angZ1 = atan2( imag(z),real(z) );
angZ2 = angle( z );

% draw a line using polar notation
h = polar([0 angZ1],[0 magZ1],'r');

%% done.
