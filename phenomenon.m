d=0:800;

pl=soundPathLoss(5000, soundAttenuationFisher(10e3, d, waterTemperature(d,15)), 0, 2.0);

figure('Position', [0, 0, 1280, 800])
subplot(1,2,1)
plot(pl,d)
set(gca,'ydir','reverse')
ylabel('depth [m]')
xlabel('path loss [dB]')
title('sound path loss for 5 km line parallel to water')
print('szakalaka.png', '-dpng', '-F:18', '-r0')