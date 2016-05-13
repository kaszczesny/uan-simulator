%returns path loss in dB for given path length

function [pathloss] = soundPathLoss (
distance, ... % path distance (or vector of distances); m
absorption, ... % attenuation in dB/m (from Thorpe/Fisher)
varargin ... %optional spreading factor: 1, 1.5 or 2
)

%spreading factor: 2 - spherical (for multipath), 1.5 - practical, 1 - cylindrical

if nargin == 3
  k = varargin{1};
else
  k = 1.5;
end

%from: AquaTools - An Underwater Acoustic...
pathloss = k * 10*log10(distance) + distance .* 10*log(absorption);

%todo check whether path distance is in m or km; absorption in dB/m or dB/km
