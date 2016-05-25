freq = 2.4 * 10^9;
distance = (1:0.01:5);

att = radioAttenuation(freq);

for iter=1:length(distance)
  pathloss(iter) = radioPathLoss(distance(iter), att, freq);
end

pathloss;
plot(pathloss)  

%%Underwater Wireless Sensor Network Communication Using Electromagnetic Waves at Resonance Frequency 2.4 GHz
%todo: check results with fig5