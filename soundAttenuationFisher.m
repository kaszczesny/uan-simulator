% returns attenuation in dB/m (so-called absorption)
% assumptions: 0 <= temperature <= 30; 10 <= depth <= 4000

function [attenuation] = soundAttenuationFisher (
freq, ... % freqency Hz
d, ... % depth m
t ... % temperature Celcius
)

% if d is a matrix (2,n), average absorption is calculated for each column
%  columns are interpreted as [depthStart; depthStop];
%  t is surface temperature (local temperature is calculated internally)
% otherwise absorption is calculated for each value; t is local temperature


% http://www.mathworks.com/matlabcentral/fileexchange/37689-seawater-acoustic-absorption-calculator
% the formula is compatibile with Fisher's results in
%  http://nsgl.gso.uri.edu/washu/washuw80001/washuw80001_part3.pdf
freq2 = freq.^2;
P_atm = abs(d) / 10; % pressure [atm]

f1 = 1.32e3 * (t + 273.15) .* exp( -1700./(t + 273.15) );
f2 = 1.55e7 * (t + 273.15) .* exp( -3052./(t + 273.15) ); 
A = 8.95e-8 * (1 + 2.3e-2*t - 5.1e-4*t.^2); 
B = 4.88e-7 * (1 + 1.3e-2*t); 
C = 4.76e-13 * (1 - 4e-2*t + 5.9e-4*t.^2); 

if size(d, 1) ~= 2
  attenuation = ...
    A.*f1.*(freq2) ./ (f1.^2 + freq2) + ... % boric acid
    B.*(1 - 9e-4*P_atm).*f2.*(freq2) ./ (f2.^2 + freq2) + ... % MgSO4
    C.*(1 - 3.8e-4*P_atm).*freq2; %pure water
else
  %calculate average speed by integrating and dividing by interval length
  d = sort(d, 1);
  p = abs(d) / 10; % pressure [atm] (1 atm for every 10 meters of depth)
  
  antiderivative = @(p) ... % integral over dp
    p*A.*f1.*(freq2) ./ (f1.^2 + freq2) + ...
    p*B.*f2.*(freq2) ./ (f2.^2 + freq2) + ...
    -p.^2 * 0.5 * 9e-4 * B.*f2.*(freq2) ./ (f2.^2 + freq2) + ...
    p*C.*freq2 + ...
    -p.^2 * 0.5 * 3.8e-4 * C.*freq2;
  
  area = antiderivative(d(2,:)) - antiderivative(d(1,:));
  attenuation = area ./ (d(2,:) - d(1,:));

  %for zero intervals calculate attenuation as if (1,n) 
  attenuation( d(2,:) == d(1,:) ) = soundAttenuationFisher( freq, d( 1, d(2,:) == d(1,:) ), t );
end
  
