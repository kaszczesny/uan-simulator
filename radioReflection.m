% returns a complex number describing reflection (signal attenuation and phase change)

function reflection = radioReflection (
  grazingAngle, ... % angle between ray and surface (NOT normal); rad; can be a vector
  freq, ... % carrier frequency Hz
  epsilonR, ... % relative dielectric constant of the surface; can be a vector
  sigma ... % conductivity [S] of the surface; can be a vector
)

% http://www.mike-willis.com/Tutorial/reflection.htm

%vertical polarization
lossFactor = 18e9 * sigma ./ freq;

reflection = ...
  ( (epsilonR - 1i*lossFactor).*sin(grazingAngle) - sqrt( epsilonR - 1i*lossFactor - cos(grazingAngle).^2 ) ) ./ ...
  ( (epsilonR - 1i*lossFactor).*sin(grazingAngle) + sqrt( epsilonR - 1i*lossFactor - cos(grazingAngle).^2 ) );

% todo what about water episilon?