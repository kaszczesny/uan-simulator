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

%%http://www.hindawi.com/journals/ijdsn/2013/508708/ to działa 10^9 razy lepiej, z tym wyzej jest cos nie tak. te same wartosci pomijajac znak + nie ma -Inf powyzej okreslonych wartosci
pathLossAtt = 20 * distance * attenuation / log(10);

pathLoss = pathLossZero + pathLossSpeed + pathLossAtt;