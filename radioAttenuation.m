% returns attenuation in Np/m (so-called absorption)

function [attenuation] = radioAttenuation (
frequency ... %Hz
)

ang_freq = 2 * pi() * frequency; %angular frequency, rad
mi = 1.256627 * 10^(-6); %permeability of water
permittivity = 81; %relative permittivity for water

epsilon = permittivity*10^(-9)/(36*pi());
sigma = 4; %[S/m] 0.01 for normal water

%%Underwater Wireless Sensor Network Communication Using Electromagnetic Waves at Resonance Frequency 2.4 GHz
attenuation = ang_freq * sqrt( (mi * epsilon / 2) * (sqrt(1 + (sigma/(ang_freq*epsilon))^2 ) - 1)); % returns attenuation in nepers per meterattenuation = ang_freq * sqrt( (mi * permittivity / 2) * (sqrt(1 + (conductivity / permittivity)^2 ) - 1)); % returns attenuation in nepers per meter