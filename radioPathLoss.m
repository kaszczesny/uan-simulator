%returns path loss in dB for given path length

function [pathLoss] = radioPathLoss (
distance, ... % [m]
attenuation, ... % [Np/m]
frequency ... % [Hz]
)

c = 299700 * 1000; %speed of light in air [m/s]

%%Underwater Wireless Sensor Network Communication Using Electromagnetic Waves at Resonance Frequency 2.4 GHz
pathLossZero = 20 * log10( 4 * pi() * distance * frequency / c );
pathLossSpeed = 20 * log10( c / radioSpeed( frequency ) );
pathLossAtt = 10 * log10( exp( (-2) * attenuation * distance) );

pathLoss = pathLossZero + pathLossSpeed + pathLossAtt;