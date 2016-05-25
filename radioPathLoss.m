%returns path loss in dB for given path length

function [pathLoss] = radioPathLoss (
distance, ... % [m]
attenuation ... % [dB/m] until changed to Np/m

)

%%Underwater Wireless Sensor Network Communication Using Electromagnetic Waves at Resonance Frequency 2.4 GHz
pathLoss = 10 * log( exp(attenuation * distance) );
%todo: implement whole equation (2); beta is the same as in radioSpeed
%todo: verify function correctness by comparing visually with Figure 5. for 2.4 GHz