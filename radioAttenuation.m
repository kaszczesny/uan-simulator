% returns attenuation in Np/m (so-called absorption)

function [attenuation] = radioAttenuation (
frequency ... %Hz
)

ang_freq = 2* pi() * frequency; %angular frequency, rad
conductivity = 1.527; %tangent loss for salt water
mi = 1.256627 * 10^(-6); %permeability of water
permittivity = 81; %relative permittivity for water


%%Feasibility of Electromagnetic Communication in Underwater Wireless Sensor Networks
attenuation = ang_freq * sqrt( (mi * permittivity / 2) * (sqrt(1 + (conductivity / permittivity)^2 ) - 1)); % returns attenuation in nepers per meter