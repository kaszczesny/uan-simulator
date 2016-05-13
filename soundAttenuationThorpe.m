% returns attenuation in dB/m (so-called absorption)
% assumptions: temperature = 4C, depth <=1 km

function [attenuation] = soundAttenuationThorpe (
freq, ... % carrier frequency Hz
varargin ... %those do not matter
)

freqkHz2 = (freq * 1e-3).^2;
attenuation = 3.3e-3 + 0.11*freqkHz2./(1+freqkHz2) + 44*freqkHz2./(4100 + freqkHz2) + 3e-4*freqkHz2; %dB/km
%from: Acoustic Underwater Channel and Network Simulator
attenuation = attenuation * 1e-3; %dB/km -> dB/m


