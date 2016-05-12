function [] = simulator ( ... %todo retval
tx, ... %transmitter position - vector: [x y z] m
rx, ... %receiver position - vector: [x y z] m
depth, ... %seabed position (negative) m
freq, ... %carrier Hz
salinity, ... %parts per 1000 (25-40)
temperature, ... %Celcius
attModel, ... %'thorpe' of 'fisher'
noiseParams, ... % vector [shipping<0-1> wind<m/s>]
distanceResolution ... % for dynamic speed of sound calculation; m
% todo: modulation, seabed params, node movement
)

attenuation = 0; %dB/m

%setting up models - TODO
switch attModel
  case 'thorpe'
    temperature = 4; %model assumption
    if depth > 1e3
      error('Wrong depth for Thorpe model')
    end
    
    attenuation = soundAttenuationThorpe(freq); %dB/m
  case 'fisher'
    error('TODO')
  otherwise
    error('Only thorpe/fisher')
end

%noise ('Variability...')
freqkHz = freq * 1e-3;
noise = zeros(4,1); %dB
noise(1) = 17 - 30*log10(freqkHz); %turbulence dB
noise(2) = 40 + 20*(noiseParams(1)-0.5) + 26*log10(freqkHz) - 60*log10(freqkHz+0.03); %shipping dB
noise(3) = 50 + 7.5*sqrt(noiseParams(2)) + 20*log10(freqkHz) - 40*log10(freqkHz+0.4); %waves dB
noise(4) = -15 + 20*log10(freqkHz); %thermal dB

noise = sum(noise);

%path finding
% LOS - special case (draft)
losLen = sqrt(sum(tx-rx).^2);
direction = tx-rx;
versor = direction / norm(direction) * distanceResolution;

vs=[];
time = 0;
where = tx;
cumLen = 0;
while cumLen <= losLen
  v = soundSpeed(temperature, salinity, where(3));
  vs = [vs v];
  time = time + 1/v;
  where = where + versor;
  cumLen = cumLen + 1;
end
if cumLen ~= losLen
  v = soundSpeed(temperature, salinity, where(3));
  vs = [vs v];
  time = time + (losLen-cumLen)/v;
end

maxReflections = 3;
%todo

%path length calculation -> attenuation (both acoustic and EM)
%path time calculation for EM -> simple formula
%path time calculation for acoustic -> check every distanceResolution along the path
%phase & amplitude calculation reflection attenuation: constant random variable in reflection points [space] + time-variable if there is node movement, otherwise probably constant)
%sum paths into transmittance (brus #3 p.25)

%channel estimated for one sample

%msg creation, modulation, propagation, demodulation, comparison 

%the same for EM wave






%seawater for EM: epsilon_r = 81, mi_r 1, sigma = 4 S/m

%separate simulations:
%  attuenuation(distance) for acoustic and EM (both LOS)
%  refraction+reflection in 2D for acoustic (brus #3 p.7)
%  range(BER) at given modulation for acoustic and EM? eye pattern?