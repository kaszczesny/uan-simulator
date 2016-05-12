function [speed] = soundSpeed (
T, ... %temp Celcius 2-30
S, ... %salinity ppt 25-40
D ... %depth m 0-8000 
)

D = abs(D);

speed = 1448.96 + 4.591*T - 5.304e-2*T^2 + 2.374e-4*T^3 + ...
  1.340*(S-35) + 1.630e-2*D + 1.675e-7*D^2 - ...
  1.025e-2*T*(S - 35) - 7.139e-13*T*D^3;

% http://resource.npl.co.uk/acoustics/techguides/soundseawater/content.html
% or Munk profile?