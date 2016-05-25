% main function for simulation of communication between two nodes
% compares communication with acoustic and EM waves, taking into account multipath propagation

function [] = simulatorRaytracing ( ...
  tx, ... % transmitter position - vector: [x y z] m
  rx, ... % receiver position - vector: [x y z] m
  freq, ... % carrier Hz
  temperature, ... % water surface temperature; Celcius
  dataRate % bps
)
% todo retval: attenuation, impulse response, power delay profile, BER?
% todo theory: what is the difference between power delay profile and impulse response?
% todo theory: what sound carrier frequencies, transmission powers, data rates are feasiable?

soundTxPowerDb = 160; %dB rel miPa
soundTxPower = 10.^(soundTxPowerDb/10); %miPa

% msg creation, modulation
order = 4; %QPSK
%msg = randi([0 order-1], 1, 1e5 ); %temp
%pkg load communications
%signalTransmitter = pskmod( msg, order, 0, 'gray' ) * soundTxPower;

% rate = log2(order)/symbolTime
symbolTime = log2(order) / dataRate;

%reflections = multipath(...); % paths are same for both wave types
reflections = zeros(2,4,4); %temp
reflections(:,:,1) = 1.0e+02  * ...
  [3.60000  3.60000  0.00000  1.42281;
      NaN      NaN      NaN      NaN];

reflections(:,:,2) = 1.0e+02  *...
  [1.72969  1.72969  -7.98000  1.64248;
      NaN      NaN      NaN      NaN];

reflections(:,:,3) = 1.0e+02  *...
  [1.22465  1.22465  -7.97000  1.94245;
  4.24266  4.24266  0.00000  1.94245];

reflections(:,:,4) = 1.0e+02  *...
  [1.39219  1.39219  0.00000  2.19670;
  3.45454  3.45454  -7.98000  2.19670];
reflections(:,4,:)/=pi;
%impulse response h for acoustic and EM:
% for each ray find:
%  -time delay due to propagation (subtract LOS propagation time)
%  -amplitude of ray in relation to unity (loss due to path loss and reflections)
%  -phase of ray in relation to initial (0) phase (number of wavelengths passed due to propagation & reflection phase shifts)

  
soundDelay = zeros(1, size(reflections,3)+1);
soundRayTransmittance = ones(1, size(reflections,3)+1);

lengthLOS = norm(tx-rx);

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
  
  i
  lengths
  speeds
  depths
  
  soundDelay(i) = sum( lengths ./ speeds ); % t = s/v
  
  %phase change due to travel
  lambdas = speeds ./ freq; %wavelengths for each part
  lambda = sum( lengths ./ lambdas );
  phase = lambda - floor(lambda); %fractional part
  
  %attenuation due to travel
  absorptions = soundAttenuationFisher( freq, [depths(1:end-1)'; depths(2:end)'], temperature ).';
  pathloss = soundPathLoss( lengths, absorptions, 2.0 );
  
  pathloss
  disp( ' ')
  
  soundRayTransmittance(i) = exp( -1i * 2 * pi * phase ) / 10.^(pathloss/10);
  
  if i ~= size(reflections,3)+1
    soundRayTransmittance(i) = soundRayTransmittance(i) * ...
    soundReflectionWrapper( reflections( :, 4, i ), reflections( :, 3, i ) ); %reflections
  end
end

soundDelay = soundDelay - min(soundDelay);
soundTime = 0:symbolTime:max( soundDelay );

soundH = complex( zeros( size( soundTime ) ) );
for i=1:length(soundDelay)
  [~, ind] = min( abs( soundTime - soundDelay(i) ) );
  soundH(ind) = soundRayTransmittance(i) * soundTxPower;
end


figure
subplot(2,1,1)
stem(soundTime, 10*log10(abs(soundH)));
m = xlim();
m = m(2)*0.1;
xlim( xlim() + [-m +m] )
xlabel('time [s]')
ylabel('sound ray power level [dB rel. miPa]')
subplot(2,1,2)
stem(soundTime, arg(soundH));
xlim( xlim() + [-m +m] )
xlabel('time [s]')
ylabel('sound ray phase [rad]')






%hEM
