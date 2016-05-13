function [speed] = soundSpeed (
T, ... %temp Celcius 2-30
S, ... %salinity parts per thousand 25-40
D ... %depth m 0-8000 
)
% if D is a vector (1,n), speed is calculated for each value
% if D is a matrix (2,n), average speed is calculated for each column


%MacKenzie coefficients; ftp://acoustics.whoi.edu/pub/Matlab/oceans
  c= 1.44896e3;     t= 4.591e0; 
 t2=-5.304e-2;     t3= 2.374e-4;
  s= 1.340e0;       d= 1.630e-2;
 d2= 1.675e-7;     ts=-1.025e-2;
td3=-7.139e-13;  

if size(D, 1) == 1
  D = abs(D);
  speed = c + t*T + t2*(T.^2) + t3*(T.^3) + ...
    s*(S-35) + d*D + d2*(D.^2) + ts*T.*(S-35) + td3*T.*(D.^3);
elseif size(D, 1) == 2
  %calculate average speed by integrating and dividing by interval length
  D = sort(D, 1)
  antiderivative = @(T, S, D) (c + t*T + t2*(T.^2) + t3*(T.^3) + ...
    s*(S-35)).*D + d*(D.^2)/2 + d2*(D.^3)/3 + ts*T.*(S-35).*D + td3*T.*(D.^4)/4;
  
  area = antiderivative(T, S, D(2,:)) - antiderivative(T, S, D(1,:));
  speed = area ./ (D(2,:) - D(1,:));
else
  error( 'Wrong depth vector size in soundSpeed' )
end