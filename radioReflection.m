% returns a complex number describing reflection (signal attenuation and phase change)

function reflection = radioReflection (
  grazingAngle, ... % angle between ray and surface (NOT normal); rad; can be a vector
  freq ... % carrier frequency Hz
)

% http://www.mike-willis.com/Tutorial/reflection.htm

sigma = 5e-5; %kowalski's constant
epsilonR = 2;

%vertical polarization
lossFactor = 18e9 * sigma ./ freq;



reflection = ...
  ( (epsilonR - 1i*lossFactor).*sin(grazingAngle) - sqrt( epsilonR - 1i*lossFactor - cos(grazingAngle).^2 ) ) ./ ...
  ( (epsilonR - 1i*lossFactor).*sin(grazingAngle) + sqrt( epsilonR - 1i*lossFactor - cos(grazingAngle).^2 ) );

