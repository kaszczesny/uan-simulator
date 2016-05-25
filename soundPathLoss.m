%returns path loss in dB for given path length

%usage:
% PL = soundPathLoss( D, alpha );
% PL = soundPathLoss( D, alpha, 2 );

function [pathloss] = soundPathLoss (
distance, ... % path distance (or vector of distances); m
absorption, ... % attenuation in dB/m (from Thorpe/Fisher)
varargin ... %optional spreading factor: 1, 1.5 or 2 (default: 1.5)
)

%spreading factor: 2 - spherical (for multipath), 1.5 - practical, 1 - cylindrical

if nargin == 3
  k = varargin{1};
else
  k = 1.5;
end

%from: AquaTools - An Underwater Acoustic...
pathloss = k * 10*log10(sum(distance)) + sum(distance .* absorption);

%todo take into account that absorption changes for each ray piece
