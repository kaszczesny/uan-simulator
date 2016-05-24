function [intersection_point, angle] = calcTriangle (triangleMatrix, sta1, sta2)

x1 = triangleMatrix(1,:);
x2 = triangleMatrix(2,:);
x3 = triangleMatrix(3,:);



%calculate plane normal
N = cross(x1 - x3,x2 - x3);
N = N/norm(N);

%calculate sta2 mirrored parameters
sta2mirror = sta2 + 2*dot(x1 - sta2, N)*N;

%calculate point of intersection
inter = sta1+(dot((sta1-x1),N)/dot(sta1-sta2mirror,N))*(sta2mirror-sta1);

%check if point lies on the surface triangle
x = inter(1);
y = inter(2);

xv = triangleMatrix(:,1);
yv = triangleMatrix(:,2);

[in on] = inpolygon(x,y,xv,yv);


if(in==1 || on==1)
  intersection_point = inter;
  line_vector = sta1-inter;
  line_vector = line_vector/norm(line_vector);
  angle = asin( abs(line_vector(1)*N(1)+line_vector(2)*N(2)+line_vector(3)*N(3)) / ( sqrt(line_vector(1)^2 + line_vector(2)^2 + line_vector(3)^2) * sqrt(N(1)^2 + N(2)^2 + N(3)^2) ));
  angle = angle * 180;
else
  intersection_point = [ -1, -1, -1];
  angle = 0;
end

end