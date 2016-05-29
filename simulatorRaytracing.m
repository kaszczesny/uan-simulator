% main function for simulation of communication between two nodes
% compares communication with acoustic and EM waves, taking into account multipath propagation

%function [] = simulatorRaytracing ( ...
%  tx, ... % transmitter position - vector: [x y z] m
%  rx, ... % receiver position - vector: [x y z] m
%  freq, ... % carrier Hz
%  temperature, ... % water surface temperature; Celcius
%  seabed ... %[x y depth step]
%)

tx = [100 100 -200];
rx = [20*100 50*100 -500];
freq = 10e3;
temperature = 15;
seabed = [20 50 -800 100];

% todo retval: attenuation, impulse response, power delay profile, BER?
% todo theory: what is the difference between power delay profile and impulse response?
% todo theory: what sound carrier frequencies, transmission powers, data rates are feasiable?

soundTxPowerDb = 160; %dB rel miPa
soundTxPower = 10.^(soundTxPowerDb/10); %miPa

radioTxPowerDb = -10; %dBW (20 dBm)
radioTxPower = 10.^(radioTxPowerDb/10);

% msg creation, modulation
%order = 4; %QPSK
%msg = randi([0 order-1], 1, 1e5 ); %temp
%pkg load communications
%signalTransmitter = pskmod( msg, order, 0, 'gray' ) * soundTxPower;

% rate = log2(order)/symbolTime
%symbolTime = log2(order) / dataRate;

depth = -abs(seabed(3));
reflections = simulatorBottom ( [seabed(1) seabed(2)], depth, 5, 3, rx, tx, 1, seabed(4) );
%reflections(:,4,:)/=pi;
%impulse response h for acoustic and EM:
% for each ray find:
%  -time delay due to propagation (subtract LOS propagation time)
%  -amplitude of ray in relation to unity (loss due to path loss and reflections)
%  -phase of ray in relation to initial (0) phase (number of wavelengths passed due to propagation & reflection phase shifts)

lengthLOS = norm(tx-rx);

soundDelay = zeros(1, size(reflections,3)+1);
soundRayTransmittance = ones(1, size(reflections,3)+1);

for i=1:size(reflections,3)+1
  if i ~= size(reflections,3)+1 %not LOS
    point = reflections( :, 1:3, i );

    if isnan( point(2,3) ) % omit ref(2,:,n)
      lengths = [
        norm( rx - point(1,:) );
        norm( point(1,:) - tx )];
      
      speeds = [
        soundSpeed( temperature, [rx(3); point(1,3)] );
        soundSpeed( temperature, [point(1,3); tx(3)] )];
        
      depths = [rx(3); point(1,3); tx(3)];
      
    else
      lengths = [
        norm( rx - point(1,:) );
        norm( point(1,:) - point(2,:) );
        norm( point(2,:) - tx )];
      
      speeds = [
        soundSpeed( temperature, [rx(3); point(1,3)] );
        soundSpeed( temperature, [point(1,3); point(2,3)] );
        soundSpeed( temperature, [point(2,3); tx(3)] )];
        
      depths = [rx(3); point(1,3); point(2,3); tx(3)];
    end
  else %LOS
    lengths = [norm(tx-rx)];
    speeds = soundSpeed( temperature, [tx(3); rx(3)] );
    depths = [rx(3); tx(3)];
  end
  
  soundDelay(i) = sum( lengths ./ speeds ); % t = s/v
  
  %phase change due to travel
  lambdas = speeds ./ freq; %wavelengths for each part
  lambda = sum( lengths ./ lambdas );
  phase = lambda - floor(lambda); %fractional part
  
  %attenuation due to travel
  absorptions = soundAttenuationFisher( freq, [depths(1:end-1)'; depths(2:end)'], temperature ).';
  pathloss = soundPathLoss( lengths, absorptions, 1, 2.0 );
  
  soundRayTransmittance(i) = exp( -1i * 2 * pi * phase ) / 10.^(pathloss/10);
  
  if i ~= size(reflections,3)+1
    soundRayTransmittance(i) = soundRayTransmittance(i) * ...
      soundReflectionWrapper( reflections( :, 4, i ), reflections( :, 3, i ) ); %reflections
  end
end


figure
subplot(2,1,1)
hold on
for i=1:length(soundDelay)
  ftx = 'bx-';
  if i == length(soundDelay)
   ftx = 'rx-';
  end
  plot(soundDelay(i), 10*log10(abs(soundRayTransmittance(i)*soundTxPower)), ftx);
end
%plot(xlim, [0 0], 'k')
%plot(xlim, [1 1]*soundNoise(freq), 'r' );
hold off
%m = xlim();
%m = m(2)*0.1;
%xlim( xlim() + [-m +m] )
xlabel('time [s]','fontsize',18)
ylabel('sound ray power level [dB rel. uPa]','fontsize',18)
set(gca,'fontsize',18)
grid on

subplot(2,1,2)
hold on
for i=1:length(soundDelay)
  ftx = 'bx-';
  if i == length(soundDelay)
   ftx = 'rx-';
  end
  plot([1 1]*soundDelay(i), [0 arg(soundRayTransmittance(i))], ftx);
end
plot(xlim, [0 0], 'k')
hold off
%xlim( xlim() + [-m +m] )
xlabel('time [s]','fontsize',18)
ylabel('sound ray phase [rad]','fontsize',18)
set(gca,'fontsize',18)
grid on

figure
hold on
for i=1:length(soundDelay)
  ftx = 'bx-';
  if i == length(soundDelay)
   ftx = 'rx-';
  end
  plot([1 1]*soundDelay(i)-min(soundDelay), [0 abs(soundRayTransmittance(i))/max(abs(soundRayTransmittance(:)))], ftx);
end
plot(xlim, [0 0], 'k')
hold off
%m = xlim();
%m = m(2)*0.1;
%xlim( xlim() + [-m +m] )
xlabel('delay [s]','fontsize',18)
ylabel('ray power in relation to strongest ray','fontsize',18)
set(gca,'fontsize',18)
grid on

%tempTransmittance = abs(soundRayTransmittance);
%tempTransmittance = tempTransmittance / max(tempTransmittance);
%soundMeanDelay = sum(tempTransmittance.*(soundDelay-min(soundDelay)))/sum(tempTransmittance)


%fEM = 2.4e6;
%omegaEM = 2*pi*fEM;
%
%radioDelay = zeros(1, size(reflections,3)+1);
%radioRayTransmittance = ones(1, size(reflections,3)+1);
%
%for i=1:size(reflections,3)+1
%  if i ~= size(reflections,3)+1 %not LOS
%    point = reflections( :, 1:3, i );
%
%    if isnan( point(2,3) ) % omit ref(2,:,n)
%      lengths = [
%        norm( rx - point(1,:) );
%        norm( point(1,:) - tx )];
%      
%      speeds = [
%        radioSpeed( fEM );
%        radioSpeed( fEM )];
%      speeds = omegaEM ./ speeds;
%        
%      depths = [rx(3); point(1,3); tx(3)];
%      
%      angles = reflections( 1, 4, i );
%      
%    else
%      lengths = [
%        norm( rx - point(1,:) );
%        norm( point(1,:) - point(2,:) );
%        norm( point(2,:) - tx )];
%      
%      speeds = [
%        radioSpeed( fEM );
%        radioSpeed( fEM );
%        radioSpeed( fEM );];
%      speeds = omegaEM ./ speeds;
%        
%      depths = [rx(3); point(1,3); point(2,3); tx(3)];
%      
%      angles = reflections( :, 4, i );
%    end
%  else %LOS
%    lengths = [norm(tx-rx)];
%    speeds = omegaEM / radioSpeed( fEM );
%    depths = [rx(3); tx(3)];
%  end
%  
%  radioDelay(i) = sum( lengths ./ speeds ); % t = s/v
%  
%  %phase change due to travel
%  lambdas = speeds ./ fEM; %wavelengths for each part
%  lambda = sum( lengths ./ lambdas );
%  phase = lambda - floor(lambda); %fractional part
%  
%  %attenuation due to travel
%  pathloss = min( radioPathLoss( sum(lengths), radioAttenuation(fEM), fEM ), 150 );
%  
%  radioRayTransmittance(i) = exp( -1i * 2 * pi * phase ) / 10.^(pathloss/10);
%  
%  if i ~= size(reflections,3)+1
%    
%    radioRayTransmittance(i) = radioRayTransmittance(i) .* ...
%      prod( radioReflection( angles*pi/180, fEM ) ); %reflections
%  end
%end
%
%abs(radioRayTransmittance)
%figure
%subplot(2,1,1)
%hold on
%for i=1:length(radioDelay)
%  plot([1 1]*radioDelay(i)*1e3, [0 10*log10(abs(radioRayTransmittance(i)*radioTxPower))], 'bo-');
%end
%plot(xlim, [0 0], 'k')
%plot(xlim, [1 1]*radioNoise(temperature), 'r' );
%hold off
%%m = xlim();
%%m = m(2)*0.1;
%%xlim( xlim() + [-m +m] )
%xlabel('time [ms]')
%ylabel('radio ray power level [dBW]')
%ylim([max(radioNoise(temperature)*2,max(10*log10(abs(radioRayTransmittance(:)*radioTxPower)))), 0])
%
%subplot(2,1,2)
%hold on
%for i=1:length(radioDelay)
%  plot([1 1]*radioDelay(i)*1e3, [0 arg(radioRayTransmittance(i))], 'bo-');
%end
%plot(xlim, [0 0], 'k')
%hold off
%%xlim( xlim() + [-m +m] )
%xlabel('time [ms]')
%ylabel('radio ray phase [rad]')





