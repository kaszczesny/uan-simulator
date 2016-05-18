% calculates speed of sound in water for given conditions
% if pairs of depths are given, a mean speed is calculated

function [speed] = soundSpeed (
T, ... %temp Celcius 2-30
D ... %depth m 0-8000 
)

% if D is a matrix (2,n), average speed is calculated for each column
%  columns are interpreted as [depthStart; depthStop]
%  T is surface temperature (local temperature is calculated internally)
% otherwise speed is calculated for each value; T is local temperature


% salinity assumed to be 35, therefore some terms are simplified: S-35 == 0

%MacKenzie coefficients; ftp://acoustics.whoi.edu/pub/Matlab/oceans
  c= 1.44896e3;     t= 4.591e0; 
 t2=-5.304e-2;     t3= 2.374e-4;
  s= 1.340e0;       d= 1.630e-2;
 d2= 1.675e-7;     ts=-1.025e-2;
td3=-7.139e-13;  

if size(D, 1) ~= 2
  D = abs(D);
  speed = c + t*T + t2*(T.^2) + t3*(T.^3) + ...
    d*D + d2*(D.^2) + td3*T.*(D.^3);
else
  %calculate average speed by integrating by depth and dividing by interval length
  D = sort(D, 1);
  
  f = @(x) c + t*waterTemperature(x,T) + t2*(waterTemperature(x,T).^2) + t3*(waterTemperature(x,T).^3) + ...
    d*x + d2*(x.^2) + td3*waterTemperature(x,T).*(x.^3);

  area = arrayfun( @(a,b) quad( f, a, b ), D(1,:), D(2,:) );
  speed = area ./ (D(2,:) - D(1,:));
  
  speed( D(2,:) == D(1,:) ) = soundSpeed( T, D( 1, D(2,:) == D(1,:) ) ); %for zero intervals
end