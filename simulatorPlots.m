% compares acoustic and EM LOS Path Loss
% and displays other general plots

clear all;
close all;

%path loss
figure('Position', [0, 0, 1280, 800])
distance = logspace( 0, 5, 1000 ); % 1 m - 100 km
freq_ac = 10e3;
semilogx( ...
  distance, soundPathLoss( distance, soundAttenuationThorpe( freq_ac ), 0, 2.0 ), 'r', ...
  distance, soundPathLoss( distance, soundAttenuationThorpe( freq_ac ), 0, 1.5 ), 'g', ...
  distance, soundPathLoss( distance, soundAttenuationFisher( freq_ac, 0.5e3, 4 ), 0, 2.0 ), 'b', ...
  distance, soundPathLoss( distance, soundAttenuationFisher( freq_ac, 0.5e3, 4 ), 0, 1.5 ), 'k', ...
  distance, radioPathLoss( distance, radioAttenuation( 2.4e6 ), 2.4e6 ), 'm'
);
grid on;
xlabel( 'distance [m]','fontsize',18 )
ylabel( 'path loss [dB]','fontsize',18 )
legend( ...
  sprintf( 'Acoustic, Thorpe f=%g kHz, k=%.1f', freq_ac*1e-3, 2.0 ), ...
  sprintf( 'Acoustic, Thorpe f=%g kHz, k=%.1f', freq_ac*1e-3, 1.5 ), ...
  sprintf( 'Acoustic, Fisher f=%g kHz, k=%.1f', freq_ac*1e-3, 2.0 ), ...
  sprintf( 'Acoustic, Fisher f=%g kHz, k=%.1f', freq_ac*1e-3, 1.5 ), ...
  'Electromagnetic, f=2.4 MHz'
);
ylim([0 350])
title('path loss comparison','fontsize',18)
set(gca,'fontsize',18)
c = findobj(gcf,'type','axes','tag','legend')
set(c,'fontsize',18)
print('fig1.png', '-dpng', '-r0')

%Fisher absorption (fixed distance)
depth = 0:200:8000;
frequency = [0:2.5:100]*1e3;

[x, y] = meshgrid(depth, frequency);
z = soundAttenuationFisher( y, x, waterTemperature( x, 15 ) );

figure('Position', [0, 0, 1280, 800])
surf(x,y*1e-3,z*1e3);
colormap('jet');
xlabel('depth [m]')
ylabel('frequency [kHz]');
zlabel('sound absorption [dB/km]');
colorbar
title('sound absorption coefficient, Fisher model, temp. varies with depth (15 C at surface)')
print('fig2.png', '-dpng', '-r0', -'F:18')

%distance x frequency (fixed depth)
[x, y] = meshgrid(logspace( 0, 4, 41 ), frequency); % 1 m - 10 km
z = soundPathLoss( x, soundAttenuationFisher( y, 0.5e3, 8 ), 0, 1.5 );
figure('Position', [0, 0, 1280, 800])
surf(x,y*1e-3,z);
colormap('jet')
xlabel('distance [m]')
set(gca, 'xscale', 'log')
ylabel('frequency [kHz]')
zlabel('path loss [dB]')
colorbar
title('sound path loss, Fisher model, 500 m, 8 C')
print('fig3.png', '-dpng', '-r0', '-F:18')

%path loss
figure('Position', [0, 0, 1280, 800])
distance = 1:1:1000;
freq_ac = 10e3;
plot( ...
  distance, soundPathLoss( distance, soundAttenuationThorpe( freq_ac ), 0, 2.0 ), 'r', ...
  distance, soundPathLoss( distance, soundAttenuationThorpe( freq_ac ), 0, 1.5 ), 'g', ...
  distance, soundPathLoss( distance, soundAttenuationFisher( freq_ac, 0.5e3, 4 ), 0, 2.0 ), 'b', ...
  distance, soundPathLoss( distance, soundAttenuationFisher( freq_ac, 0.5e3, 4 ), 0, 1.5 ), 'k' ...
);
grid on;
xlabel( 'distance [m]','fontsize',18 )
ylabel( 'path loss [dB]','fontsize',18 )
legend( ...
  sprintf( 'Acoustic, Thorpe f=%g kHz, k=%.1f', freq_ac*1e-3, 2.0 ), ...
  sprintf( 'Acoustic, Thorpe f=%g kHz, k=%.1f', freq_ac*1e-3, 1.5 ), ...
  sprintf( 'Acoustic, Fisher f=%g kHz, k=%.1f', freq_ac*1e-3, 2.0 ), ...
  sprintf( 'Acoustic, Fisher f=%g kHz, k=%.1f', freq_ac*1e-3, 1.5 )
);
ylim([0 70])
title('acoustic path loss; t=4 C','fontsize',18)
set(gca,'fontsize',18)
c = findobj(gcf,'type','axes','tag','legend')
set(c,'fontsize',18)
print('fig4.png', '-dpng', '-r0')

%EM pathloss
figure('Position', [0, 0, 1280, 800])
distance = 1:0.1:10;
plot(distance, radioPathLoss( distance, radioAttenuation( 2.4e6 ), 2.4e6 ) )
xlabel( 'distance [m]' )
ylabel( 'path loss [dB]' )
xlim([1 10])
grid on
title('electromagnetic wave path loss @ 2.4 MHz')
print('fig5.png', '-dpng', '-r0', 'F:18')

%acoustic noise
figure('Position', [0, 0, 1280, 800])
frequency = logspace(0, 6, 200);
[total, noiseComponents] = soundNoise(frequency);
semilogx( ...
  frequency, noiseComponents(1,:), 'm', ...
  frequency, noiseComponents(2,:), 'b', ...
  frequency, noiseComponents(3,:), 'g', ...
  frequency, noiseComponents(4,:), 'r', ...
  frequency, total, 'k', 'linewidth', 2 ...
)
legend( 'turbulence', 'shipping', 'wind', 'thermal', 'total noise')
xlabel( 'frequency [Hz]','fontsize',18)
ylabel( 'noise power spectral density [dB rel. uPa]','fontsize',18)
grid on
ylim([0 110])
title('acoustic noise components','fontsize',18)
set(gca,'fontsize',18)
c = findobj(gcf,'type','axes','tag','legend')
set(c,'fontsize',18)
print('fig6.png', '-dpng', '-r0')

disp(sprintf('radio noise: %.1f dBW, @ 10 C', radioNoise(10)))

%water temperature
figure('Position', [0, 0, 1280, 800])
subplot(1,2,1)
depth = 0:1:4000;
plot( waterTemperature( depth, 15 ), depth )
xlim([0 15])
xlabel( 'water temperature [C]')
ylabel( 'depth [m]')
set(gca,'ydir','reverse')
grid on

%sound speed
subplot(1,2,2)
plot( soundSpeed( waterTemperature( depth, 15 ), depth ), depth )
xlabel( 'sound speed [m/s]')
ylabel( 'depth [m]')
set(gca,'ydir','reverse')
grid on
print('fig7.png', '-dpng', '-r0', -'F:18')

s = 2*pi*2.4e6/radioSpeed(2.4e6);
disp(sprintf('radio speed: %d m/s (%d%% c) @ 2.4 MHz', round(s), round(s*100/3e8)))

%sound reflection
figure('Position', [0, 0, 1280, 800])
subplot(1,2,1)
phiDeg = 0:0.25:90;
phi = phiDeg * pi / 180;
plot( ...
  phiDeg, -10*log10(abs(soundReflection( phi, 1.137 / 1000, 349.14 ))), 'g', ...
  phiDeg, -10*log10(abs(soundReflection( phi, 1.9, 1650 ))), 'm', ...
  phiDeg, -10*log10(abs(soundReflection( phi, 2.1, 1950 ))), 'k', ...
  phiDeg, -10*log10(abs(soundReflection( phi, 1.5, 1500 ))), 'r' ...
)
legend( 'air', 'sand', 'moraine', 'clay');
xlabel('grazing angle [degrees]','fontsize',18)
ylabel('reflection loss [dB]','fontsize',18)
set(gca,'fontsize',18)
c = findobj(gcf,'type','axes','tag','legend')
set(c,'fontsize',18)

subplot(1,2,2)
plot( ...
  phiDeg, arg(soundReflection( phi, 1.137 / 1000, 349.14 )), 'g', ...
  phiDeg, arg(soundReflection( phi, 1.9, 1650 )), 'm', ...
  phiDeg, arg(soundReflection( phi, 2.1, 1950 )), 'k', ...
  phiDeg, arg(soundReflection( phi, 1.5, 1500 )), 'r' ...
)
legend( 'air', 'sand', 'moraine', 'clay');
xlabel('grazing angle [degrees]','fontsize',18)
ylabel('reflection phase change [rad]','fontsize',18)
set(gca,'fontsize',18)
c = findobj(gcf,'type','axes','tag','legend')
set(c,'fontsize',18)
print('fig8.png', '-dpng', '-r0')
