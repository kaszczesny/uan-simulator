% returns points of multipath reflections

%output is a matrix 2x4xn where n is the number of rays w/o LOS

%  -                  -
% | x1  y1  z1  angle1 |
% | nan nan nan nan    |  for one reflection
%  -                  -

%  -                  -
% | x1  y1  z1  angle1 |
% | x2  y2  z2  angle2 |  for two reflections
%  -                  -

function [output_matrix] = simulatorBottom (
seabed, ... %number of points for seabed shaping [x y], size in meters equals seabed*100[m] -- [20 50]
depth, ... %depth of seabed [-m] -- -800
difference, ... %difference from mean seabed depth [m] -- 5
variation, ... %RNG for seabed [m] -- 3
sta1, ... %tx coordinates [x y z] [m] -- [0 0 -200]
sta2, ... %rx coordinates [x y z] [m] -- [seabed(1)*100 seabed(2)*100 -500]
visualisation, ... %1 if plotted surface and rays are needed, 0 otherwise -- 1
step ... % step [m], default 100
)

ilosc_x = seabed(1);
ilosc_y = seabed(2);

imax = depth + difference;
imin = depth - difference;

disp("preparing bottom...")
bottom = zeros(ilosc_x+5, ilosc_y+5);

bottom(:,1) = randi([imin imax], ilosc_x+5, 1);
bottom(1,2:end) = randi([imin imax], 1, ilosc_y+4);
variation_matrix = randi([-variation variation], ilosc_x+4, ilosc_y+4);

for iter = 2:ilosc_x+5
  for jter = 2:ilosc_y+5
    bottom(iter, jter) = round(mean([bottom(iter-1, jter), bottom(iter, jter-1)]) + variation_matrix(iter-1, jter-1));
  end
end

bottom = bottom(6:end,6:end);

if(visualisation == 1)
  close all;
  [bottom_x, bottom_y] = meshgrid( [1:ilosc_x]*step, [1:ilosc_y]*step );
  figure
  surf(bottom')
  
  figure
  hold on
  surf(bottom_x, bottom_y, bottom')
end

disp("calculating water reflection...")
rectangle = [0 0 0; ilosc_x*step 0 0; 0 ilosc_y*step 0; ilosc_x*step ilosc_y*step 0];
N = cross(rectangle(1,:) - rectangle(3,:),rectangle(2,:) - rectangle(3,:));
N = N/norm(N);
%calculate sta2 mirrored parameters
sta1mirror = sta1 + 2*dot(rectangle(1,:) - sta1, N)*N;
sta2mirror = sta2 + 2*dot(rectangle(1,:) - sta2, N)*N;
%calculate point of intersection
inter_point = sta1+(dot((sta1-rectangle(1,:)),N)/dot(sta1-sta2mirror,N))*(sta2mirror-sta1);
line_vector = sta1-inter_point;
line_vector = line_vector/norm(line_vector);
angle = asin( abs(line_vector(1)*N(1)+line_vector(2)*N(2)+line_vector(3)*N(3)) / ( sqrt(line_vector(1)^2 + line_vector(2)^2 + line_vector(3)^2) * sqrt(N(1)^2 + N(2)^2 + N(3)^2) ));
%todo" pretty sure there (and in other lines with angles) there should be:
%angle = angle * 180 / pi;
angle = angle * 180;

%preparing structures
inter_point = [inter_point; [0 0 0]];
angle = [angle; [0]];

disp("calculating intersection points for 1 reflection...")
for iter=1:ilosc_x-1
  for jter=1:ilosc_y-1
    triangle=[iter jter bottom(iter,jter); iter+1 jter bottom(iter+1,jter); iter jter+1 bottom(iter,jter+1)];
    triangle(:,1:2) = triangle(:,1:2)*step;
    [intersection angle_temp] = calcTriangle(triangle, sta1, sta2);
    if(intersection == [-1, -1, -1])
    else
      inter_point = [inter_point; intersection; [0 0 0]];
      angle = [angle; angle_temp; [0]];
    end
    
    triangle=[iter+1 jter+1 bottom(iter+1,jter+1); iter+1 jter bottom(iter+1,jter); iter jter+1 bottom(iter,jter+1)];
    triangle(:,1:2) = triangle(:,1:2)*step;
    [intersection angle_temp] = calcTriangle(triangle, sta1, sta2);
    if(intersection == [-1, -1, -1])
    else
      inter_point = [inter_point; intersection; [0 0 0]];
      angle = [angle; angle_temp; [0]];
    end
  end
end

disp("calculating intersection points for 2 reflections...")
for iter = 1:ilosc_x-1
  for jter = 1:ilosc_y-1
    
    triangle = [iter jter bottom(iter,jter); iter+1 jter bottom(iter+1,jter); iter jter+1 bottom(iter,jter+1)];
    triangle(:,1:2) = triangle(:,1:2)*step;
    [intersection angle_temp] = calcTriangle(triangle, sta1, sta2mirror);
    if(intersection == [-1, -1, -1])
    else
      inter_point = [inter_point; intersection];
      angle = [angle; angle_temp];
        inter_point_temp = intersection+(dot((intersection-rectangle(1,:)),N)/dot(intersection-sta2mirror,N))*(sta2mirror-intersection);
        line_vector = intersection-inter_point_temp;
        line_vector = line_vector/norm(line_vector);
        angle_temp = asin( abs(line_vector(1)*N(1)+line_vector(2)*N(2)+line_vector(3)*N(3)) / ( sqrt(line_vector(1)^2 + line_vector(2)^2 + line_vector(3)^2) * sqrt(N(1)^2 + N(2)^2 + N(3)^2) ));
        angle_temp = angle_temp * 180;
      inter_point = [inter_point; inter_point_temp; [0 0 0]];
      angle = [angle; angle_temp; [0]];
    end
    [intersection angle_temp] = calcTriangle(triangle, sta1mirror, sta2);
    if(intersection == [-1, -1, -1])
    else
      inter_point = [inter_point; [0 0 0]; intersection];
      angle = [angle; [0]; angle_temp];
        inter_point_temp = intersection+(dot((intersection-rectangle(1,:)),N)/dot(intersection-sta1mirror,N))*(sta1mirror-intersection);
        line_vector = intersection-inter_point_temp;
        line_vector = line_vector/norm(line_vector);
        angle_temp = asin( abs(line_vector(1)*N(1)+line_vector(2)*N(2)+line_vector(3)*N(3)) / ( sqrt(line_vector(1)^2 + line_vector(2)^2 + line_vector(3)^2) * sqrt(N(1)^2 + N(2)^2 + N(3)^2) ));
        angle_temp = angle_temp * 180;
      inter_point(end-1, :) = inter_point_temp;
      inter_point = [inter_point; [0 0 0]];
      angle(end-1, :) = angle_temp;
      angle = [angle; [0]];
    end
    
    triangle=[iter+1 jter+1 bottom(iter+1,jter+1); iter+1 jter bottom(iter+1,jter); iter jter+1 bottom(iter,jter+1)];
    triangle(:,1:2) = triangle(:,1:2)*step;
    [intersection angle_temp] = calcTriangle(triangle, sta1, sta2mirror);
    if(intersection == [-1, -1, -1])
    else
      inter_point = [inter_point; intersection];
      angle = [angle; angle_temp];
        inter_point_temp = intersection+(dot((intersection-rectangle(1,:)),N)/dot(intersection-sta2mirror,N))*(sta2mirror-intersection);
        line_vector = intersection-inter_point_temp;
        line_vector = line_vector/norm(line_vector);
        angle_temp = asin( abs(line_vector(1)*N(1)+line_vector(2)*N(2)+line_vector(3)*N(3)) / ( sqrt(line_vector(1)^2 + line_vector(2)^2 + line_vector(3)^2) * sqrt(N(1)^2 + N(2)^2 + N(3)^2) ));
        angle_temp = angle_temp * 180;
      inter_point = [inter_point; inter_point_temp; [0 0 0]];
      angle = [angle; angle_temp; [0]];
    end
    [intersection angle_temp] = calcTriangle(triangle, sta1mirror, sta2);
    if(intersection == [-1, -1, -1])
    else
      inter_point = [inter_point; [0 0 0]; intersection];
      angle = [angle; [0]; angle_temp];
        inter_point_temp = intersection+(dot((intersection-rectangle(1,:)),N)/dot(intersection-sta1mirror,N))*(sta1mirror-intersection);
        line_vector = intersection-inter_point_temp;
        line_vector = line_vector/norm(line_vector);
        angle_temp = asin( abs(line_vector(1)*N(1)+line_vector(2)*N(2)+line_vector(3)*N(3)) / ( sqrt(line_vector(1)^2 + line_vector(2)^2 + line_vector(3)^2) * sqrt(N(1)^2 + N(2)^2 + N(3)^2) ));
        angle_temp = angle_temp * 180;
      inter_point(end-1, :) = inter_point_temp;
      inter_point = [inter_point; [0 0 0]];
      angle(end-1, :) = angle_temp;
      angle = [angle; [0]];
    end
    
  end
end

angle = angle / pi;
output_matrix = [];
 
if (visualisation == 1)
  disp("visualisation...")
  cntr = 0;
  %plotting stations
  plot3(sta1(1),sta1(2),sta1(3), "r*", sta2(1), sta2(2), sta2(3), "r*")
  for iter=1:size(inter_point, 1)
    if (inter_point(iter, :) == [0 0 0])
      cntr=0;
      line([sta2(1) inter_point(iter-1,1)], [sta2(2) inter_point(iter-1,2)], [sta2(3) inter_point(iter-1,3)]);
    else
      %plotting intersection point
      plot3(inter_point(iter,1), inter_point(iter,2), inter_point(iter,3),"b+");
      if (cntr == 0)
        line([sta1(1) inter_point(iter,1)], [sta1(2) inter_point(iter,2)], [sta1(3) inter_point(iter,3)]);
        output_matrix = cat(3, output_matrix, [inter_point(iter, :) angle(iter); NaN NaN NaN NaN]);
      else
        line([inter_point(iter,1) inter_point(iter-1,1)], [inter_point(iter,2) inter_point(iter-1,2)], [inter_point(iter,3) inter_point(iter-1,3)]);
        output_matrix(2, :, end) = [inter_point(iter, :) angle(iter)];
      end
    cntr = cntr+1;
    end
  end
  line([sta2(1) sta1(1)], [sta2(2) sta1(2)], [sta2(3) sta1(3)]);
  hold off;
else
  disp("no visualisation...")
  cntr = 0;
  for iter=1:size(inter_point, 1)
    if (inter_point(iter, :) == [0 0 0])
      cntr=0;
    else
      if (cntr == 0)
        output_matrix = cat(3, output_matrix, [inter_point(iter, :) angle(iter); NaN NaN NaN NaN]);
      else
        output_matrix(2, :, end) = [inter_point(iter, :) angle(iter)];
      end
    cntr = cntr+1;
    end
  end
end