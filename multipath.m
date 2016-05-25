%returns array of intersection points and grazing angles (degrees): 2x4xn

function output_matrix = multipath ( ...
  sta1, ... % [x y z] m
  sta2, ... % [x y z] m
  bottomShape, ... % [imin imax variation] m
  visualisation ... % 0 or 1
)

imin = bottomShape(1);
imax = bottomShape(2);
variation = bottomShape(3);

%todo functionify simulatorBottom