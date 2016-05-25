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

if length(varargin)> 0
  vSound = varargin{1};
end

relSpeed = speed ./ vSound;

% "Elements of Physical Oceanography: A derivative of the Encyclopedia of Ocean"
% page 420 Eq. 6
% https://books.google.pl/books?id=ISrnKDMyNTMC&pg=PA419&lpg=PA419&dq=sound+attenuation+thorpe&source=bl&ots=u7Eww1ybIE&sig=O1RZbal1fXAjg6QCK3MTyPz6HFM&hl=pl&sa=X&ved=0ahUKEwijguKPhN_MAhVDnRQKHZ6mBzYQ6AEIOTAD#v=onepage&q=sound%20attenuation%20thorpe&f=false
reflection = ...
  ( relDensity.^1 .*sin(grazingAngle) - sqrt( (1./relSpeed).^2 - (cos(grazingAngle).^2) ) ) ./ ...
  ( relDensity.^1 .*sin(grazingAngle) + sqrt( (1./relSpeed).^2 - (cos(grazingAngle).^2) ) );

reflection = reflection * 0.98; %disallow perfect reflection

