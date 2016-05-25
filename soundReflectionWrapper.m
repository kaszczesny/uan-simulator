% simpler reflection for water-air/water-sand
%returns cumulative complex reflection coeffictien for all reflection points

function reflection = soundReflectionWrapper (
  grazingAngle, ... % angle between ray and surface (NOT normal); degrees
  depth ... % water-air interface assumed if 0, otherwise water-sand
)

if sum(grazingAngle > 90) + sum(grazingAngle < 0 )
  grazingAngle
  error('angle');
end

grazingAngle = grazingAngle * pi / 180; % deg -> rad



reflection = 1;

for i=1:length(depth)
  if isnan(depth(i))
    continue
  end
  
  if abs(depth(i)) < 1 %air
    %soundReflection( grazingAngle(i), 1.137 / 1000, 349.14 )
    reflection = reflection * soundReflection( grazingAngle(i), 1.137 / 1000, 349.14 );
  else
    %soundReflection( grazingAngle(i), 1.9, 1650 )
    reflection = reflection * soundReflection( grazingAngle(i), 1.9, 1650 );
  end
end
