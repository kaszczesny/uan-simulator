% returns wave number of EM in water

function [wave_number] = radioSpeed (
frequency ... %Hz
)

ang_freq = 2* pi() * frequency; %angular frequency, rad
conductivity = 1.527; %tangent loss for salt water
mi = 1.256627 * 10^(-6); %permeability of water
permittivity = 81; %relative permittivity for water


%%Underwater Wireless Sensor Network Communication Using Electromagnetic Waves at Resonance Frequency 2.4 GHz
wave_number = ang_freq * sqrt( (mi * permittivity / 2) * (sqrt(1 + (conductivity / permittivity)^2) + 1)); % returns wave number in rad/s