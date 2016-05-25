% returns speed of EM in water [m/s]

function [speed] = radioSpeed (
frequency ... %Hz
)

ang_freq = 2* pi() * frequency; %angular frequency, rad
conductivity = 4; % [S/m] 0.01 for freshwater; 4 for salty water
mi = 1.256627 * 10^(-6); %permeability of water
permittivity = 81 * 10^(-9) / ( 36* pi() ); %81 is the relative permittivity for water


%%Feasibility of Electromagnetic Communication in Underwater Wireless Sensor Networks
wave_number = ang_freq * sqrt( ( mi * permittivity / 2 ) * ( sqrt( 1 + (conductivity / (ang_freq * permittivity ))^2 ) + 1)); % returns wave number in rad/s
speed = ang_freq / wave_number; #returns speed of propagation in m/s
