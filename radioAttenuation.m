% returns attenuation in dB/m (so-called absorption)
% assumptions: ...

function [attenuation] = radioAttenuation (
frequency ... %Hz
)

ang_freq = 2* pi() * frequency; %angular frequency, rad
conductivity = 4; % [S/m] 0.01 for freshwater; 4 for salty water
mi = 1.256627 * 10^(-6); %permeability of water
permittivity = 81 * 10^(-9) / ( 36* pi() ); %81 is the relative permittivity for water


%%Feasibility of Electromagnetic Communication in Underwater Wireless Sensor Networks
attenuation = ang_freq * sqrt( ( mi * permittivity / 2 ) * ( sqrt( 1 + (conductivity / (ang_freq * permittivity ))^2 ) - 1)); % returns attenuation in nepers per meter
attenuation = attenuation / ( 20 *log10(e) ); %returns attenuation in dB/m
