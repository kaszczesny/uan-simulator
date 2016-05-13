% returns attenuation in dB/m (so-called absorption)
% assumptions: ...

function [attenuation] = soundAttenuationFisher (
freq, ... % freqency Hz
d, ... % depth m
t ... % temperature Celcius
)

d = abs(d);
freqkHz2 = (freq *1e-3).^2;

A = [ ... % temperature signal absorption
  1.03e-8 + 2.36e-10*t - 5.22e-12*t.^2;
  5.62e-8 + 7.52e-10*t;
  (55.9 - 2.37*t + 4.77e-2*t.^2 - 3.48e-4*t.^3)*1e-15;
];
f = [ ... % relaxation frequencies introduced by boric acid and magnesium sulphate
  1.32e3*(t+273.1).*exp( -1700/(t+273.1) );
  1.5573*(t+273.1).*exp( -3052/(t+273.1) );
];
P = [ ... % effects of depth
  1;
  1 - 10.3e-5*d + 3.7e-9*d.^2;
  1 - 3.84e-5*d + 7.57e-10*d.^2;
];

attenuation = sum(A.*P.*[(f(1)*freqkHz2)/(f(1)^2+freqkHz2); (f(2)*freqkHz2)/(f(2)^2+freqkHz2); freqkHz2]);
%from: Variability...

%todo check units
