%calculates radio noise in dBW for body of given temperature
%WiFi assumed (20 MHz bandwidth)

function noise = radioNoise ( ...
  temp ... % temperature, Celcius
)

kb = 1.38e-23; %Boltzmann's constant

%Johnson-Nyquist noise
noise = 10*log10( kb * (273.15+temp) * 20e6 );