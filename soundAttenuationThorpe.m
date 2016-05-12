% assumptions: temperature = 4C, depth <=1 km
% returns attenuation in dB/m

function [attenuation] = soundAttenuationThorpe (varargin)
% first argument: frequency in Hz (or vector of freqencies), rest does not matter

freq = varargin{1};
freqkHz2 = (freq * 1e-3).^2;
attenuation = 3.3e-3 + 0.11*freqkHz2./(1+freqkHz2) + 44*freqkHz2./(4100 + freqkHz2) + 3e-4*freqkHz2; %dB/km
%from: Acoustic Underwater Channel and Network Simulator
attenuation = attenuation * 1e-3; %dB/km -> dB/m


