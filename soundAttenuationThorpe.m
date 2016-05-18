% returns attenuation in dB/m (so-called absorption)
% assumptions: temperature = 4C, depth <=1 km

%usage:
% att = soundAttenuationThorpe( freq, ... ); %can receive same arguments as Fisher

function [attenuation] = soundAttenuationThorpe (
freq, ... % carrier frequency Hz
varargin ... %those do not matter
)

freqkHz = freq * 1e-3;
freqkHz2 = freqkHz .^ 2;

if freq >= 400
  attenuation = 3.3e-3 + 0.11*freqkHz2./(1+freqkHz2) + 44*freqkHz2./(4100 + freqkHz2) + 3e-4*freqkHz2; %dB/km
  %from: Acoustic Underwater Channel and Network Simulator
else
  attenuation = 0.002 + 0.11*freqkHz./(1+freqkHz) + 0.011*freqkHz;
  %from: NS-3 and other sources
end

attenuation = attenuation * 1e-3; %dB/km -> dB/m

if nargin > 1
  %if varargin{1} exists, it is depth scalar/vector
  attenuation = ones(size(varargin{1}, 2)) * attenuation;
end

