%returns path loss in dB for given path length

function [pathLoss] = radioPathLoss (
distance, ... % [m]
attenuation ... % [dB/m] until changed to Np/m

)

%%Underwater Wireless Sensor Network Communication Using Electromagnetic Waves at Resonance Frequency 2.4 GHz
pathLoss = 10 * log( exp(attenuation * distance) );
