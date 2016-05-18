% returns a complex number describing reflection (signal attenuation and phase change)

%usage:
% ref = soundReflection( angle, relDensity, speed );
% ref = soundReflection( ..., vSound  );
% ref = soundReflection( ..., 'variation' );

function reflection = soundReflection (
  grazingAngle, ... % angle between ray and surface (NOT normal); rad; can be a vector
  relDensity, ... % material density in relation to water, can be a vector
  speed, ... % material sound speed [m/s], can be a vector
  varargin ... % optionally sound of speed in water at reflection point [m/s] (default: 1500 m/s)
)

vSound = 1500;

for length(varargin)> 0
  vSound = varargin{1};
end

relSpeed = speed ./ vSound;

% "Elements of Physical Oceanography: A derivative of the Encyclopedia of Ocean"
% page 420 Eq. 6
reflection = ...
  ( relDensity.*sin(grazingAngle) - sqrt( (1./relSpeed).^2 - (cos(grazingAngle).^2) ) ) ./ ...
  ( relDensity.*sin(grazingAngle) + sqrt( (1./relSpeed).^2 - (cos(grazingAngle).^2) ) );
