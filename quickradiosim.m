clear all;
close all;

freq = 2.4 * 10^9;
distance = (1:0.01:5);

att = radioAttenuation(freq);

for iter=1:length(distance)
  pathloss(iter) = radioPathLoss(distance(iter), att, freq);
end

semilogy(distance, pathloss)  

%%Underwater Wireless Sensor Network Communication Using Electromagnetic Waves at Resonance Frequency 2.4 GHz