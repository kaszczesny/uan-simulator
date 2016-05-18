% main function for simulation of communication between two nodes
% compares communication with acoustic and EM waves, taking into account multipath propagation

function [] = simulatorRaytracing ( ...
  tx, ... % transmitter position - vector: [x y z] m
  rx, ... % receiver position - vector: [x y z] m
  freq, ... % carrier Hz
  temperature, ... % water surface temperature; Celcius
  attModel, ... % 'thorpe' of 'fisher'
  noiseParams, ... % vector [shipping<0-1> wind<m/s>]
  % todo: seabed params (shape, material), modulation order, symbol period, node movement, simulation time
)
% todo retval: attenuation, impulse response, power delay profile, BER, capacity, eye diagram?
% todo theory: what is the difference between power delay profile and impulse response?
% todo theory: what sound carrier frequencies, transmission powers, data rates are feasiable?

% todo: set up seabed, figure out lowest point of the simulation (depth variable)

switch attModel
  case 'thorpe'
    temperature = 4; %model assumption
    if depth > 1e3
      error('Wrong depth for Thorpe model')
    end
    
    attenuation = soundAttenuationThorpe(freq); %dB/m
    
  case 'fisher'
    error('TODO')
    
    attenuation; %dB/m
    
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

% return to linear power in order to sum
noise = 10.^(noise/10);
noise = sum(noise);
noise = 10*log10(noise);

%path finding
% LOS - special case (draft)
losLen = norm(tx-rx);
losV = soundSpeed(temperature, [tx(3); rx(3)])
% v=s/t -> t = s/v
losTime = losLen / losV;

maxReflections = 3;
%todo find paths - list/vector of reflection points and possibly indicators on which polygon are those reflections
% paths are same for both wave types

%todo impulse response h for acoustic and EM:
% for each ray find:
%  -time delay due to propagation (subtract LOS propagation time)
%  -amplitude of ray in relation to unity (loss due to path loss and reflections)
%  -phase of ray in relation to initial (0) phase (number of wavelengths passed due to propagation & reflection phase shifts)
% 
hAcoustic = complex( zeros( 1, max( delays )*timeResolution ) );
hAcoustic( delays*timeResolution ) = abs(losses) * exp(-1i * phases ); %losses are linear, NOT dB

%hEM

%channel estimated for one sample

% msg creation, modulation
%for acoustic and EM: convolution with h, noise, demodulation, comparison with msg