%returns total noise and noise components in dB in relation to 1 miPa

function [total, noise] = soundNoise ( ...
  freq ... % Hz
)

%'Variability ...', 'Acoustic Underwater Channel'
shipping = 0.1; % 0-1
wind = 1; % [m/s]; light air

freqkHz = freq * 1e-3;
noise = zeros(4,length(freq)); %noise components

noise(1,:) = 17 - 30*log10(freqkHz); %turbulence dB
noise(2,:) = 40 + 20*(shipping-0.5) + 26*log10(freqkHz) - 60*log10(freqkHz+0.03); %shipping dB
noise(3,:) = 50 + 7.5*sqrt(wind) + 20*log10(freqkHz) - 40*log10(freqkHz+0.4); %waves dB
noise(4,:) = -15 + 20*log10(freqkHz); %thermal dB

% return to linear power in order to sum
total = 10.^(noise/10);
total = sum(total, 1);
total = 10*log10(total);

end
