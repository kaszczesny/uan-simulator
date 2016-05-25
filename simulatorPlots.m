% compares acoustic and EM LOS Path Loss
% and displays other general plots

clear all;
close all;

%path loss
figure
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
xlabel( 'distance [m]' )
ylabel( 'path loss [dB]' )
legend( ...
  sprintf( 'Acoustic, Thorpe f=%g kHz, k=%.1f', freq_ac*1e-3, 2.0 ), ...
  sprintf( 'Acoustic, Thorpe f=%g kHz, k=%.1f', freq_ac*1e-3, 1.5 ), ...
  sprintf( 'Acoustic, Fisher f=%g kHz, k=%.1f', freq_ac*1e-3, 2.0 ), ...
  sprintf( 'Acoustic, Fisher f=%g kHz, k=%.1f', freq_ac*1e-3, 1.5 ), ...
  'Electromagnetic, f=2.4 MHz'
);
ylim([0 250])
title('path loss comparison')

%Fisher absorption (fixed distance)
depth = 0:200:8000;
frequency = [0:2.5:100]*1e3;

[x, y] = meshgrid(depth, frequency);
z = soundAttenuationFisher( y, x, waterTemperature( x, 15 ) );

figure
surf(x,y*1e-3,z*1e3);
colormap('jet');
xlabel('depth [m]')
ylabel('frequency [kHz]');
zlabel('sound absorption [dB/km]');
colorbar
title('sound absorption coefficient, Fisher model, temp. varies with depth (15 C at surface)')

%distance x frequency (fixed depth)
[x, y] = meshgrid(logspace( 0, 4, 41 ), frequency); % 1 m - 10 km
z = soundPathLoss( x, soundAttenuationFisher( y, 0.5e3, 8 ), 0, 1.5 );
figure
surf(x,y*1e-3,z);
colormap('jet')
xlabel('distance [m]')
set(gca, 'xscale', 'log')
ylabel('frequency [kHz]')
zlabel('path loss [dB]')
colorbar
title('sound path loss, Fisher model, 500 m, 8 C')

%EM pathloss
figure
distance = 1:0.1:10;
plot(distance, radioPathLoss( distance, radioAttenuation( 2.4e6 ), 2.4e6 ) )
xlabel( 'distance [m]' )
ylabel( 'path loss [dB]' )
xlim([1 10])
grid on
title('electromagnetic wave path loss @ 2.4 MHz')

%acoustic noise
figure
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
xlabel( 'frequency [Hz]')
ylabel( 'noise power spectral density [dB rel. miPa]')
grid on
ylim([0 110])
title('acoustic noise components')

disp(sprintf('radio noise: %.1f dBW, @ 10 C', radioNoise(10)))

%water temperature
figure
subplot(1,2,1)
depth = 0:1:4000;
plot( waterTemperature( depth, 15 ), -depth )
xlim([0 15])
xlabel( 'water temperature [C]')
ylabel( 'depth [m]')
grid on

%sound speed
subplot(1,2,2)
plot( soundSpeed( waterTemperature( depth, 15 ), depth ), -depth )
xlabel( 'sound speed [m/s]')
ylabel( 'depth [m]')
grid on

s = 2*pi*2.4e6/radioSpeed(2.4e6);
disp(sprintf('radio speed: %d m/s (%d%% c) @ 2.4 MHz', round(s), round(s*100/3e8)))

%sound reflection
figure
subplot(1,2,1)
phiDeg = 0:0.25:90;
phi = phiDeg * pi / 180;
plot( ...
  phiDeg, -10*log10(abs(soundReflection( phi, 1.137 / 1000, 349.14 ))), 'g', ...
  phiDeg, -10*log10(abs(soundReflection( phi, 1.9, 1650 ))), 'y', ...
  phiDeg, -10*log10(abs(soundReflection( phi, 2.1, 1950 ))), 'k', ...
  phiDeg, -10*log10(abs(soundReflection( phi, 1.5, 1500 ))), 'r' ...
)
legend( 'air', 'sand', 'moraine', 'clay');
xlabel('grazing angle [degrees]')
ylabel('reflection loss [dB]')

subplot(1,2,2)
plot( ...
  phiDeg, arg(soundReflection( phi, 1.137 / 1000, 349.14 )), 'g', ...
  phiDeg, arg(soundReflection( phi, 1.9, 1650 )), 'y', ...
  phiDeg, arg(soundReflection( phi, 2.1, 1950 )), 'k', ...
  phiDeg, arg(soundReflection( phi, 1.5, 1500 )), 'r' ...
)
legend( 'air', 'sand', 'moraine', 'clay');
xlabel('grazing angle [degrees]')
ylabel('reflection phase change [rad]')