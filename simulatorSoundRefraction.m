clear all;
close all;

% simulation parameters
start_depth = 8000;
surface_temp = 15;
 % TODO Dynamic wave values
waves_angles = 0:pi/30:pi/2;
num_of_waves = length(waves_angles);
sim_duration = 5;  % in seconds
sim_interval = 0.1;   % in seconds

start_temp = waterTemperature( start_depth, surface_temp );
start_sound_speed = soundSpeed( start_temp, start_depth );
sim_cycles = sim_duration/sim_interval

% Results matrixes
waves_depths(1:length(waves_angles)) = start_depth;
waves_speeds(1:length(waves_angles)) = start_sound_speed;

for k = 1:sim_cycles
  temp_depth_vector = [];
  temp_angle_vector = [];
  temp_speed_vector = [];
  for l = 1:num_of_waves
    depth = waves_depths(k,l) - sim_interval*waves_speeds(k,l)*real(sin(waves_angles(k,l)));
    % in case if simulation reached the surface simulation will get weird
    if depth < 0
    	depth = NaN;
    	speed = NaN;
    	angle = NaN;
    else
    	temperature = waterTemperature(depth, surface_temp);
    	speed = soundSpeed( temperature, depth );
    	angle = refraction(waves_speeds(k,l), speed, waves_angles(k,l));
    end

    temp_depth_vector = [temp_depth_vector, depth];
    temp_speed_vector = [temp_speed_vector, speed];
    temp_angle_vector = [temp_angle_vector, angle];
  end
  waves_depths = [waves_depths; temp_depth_vector];
  waves_angles = [waves_angles; temp_angle_vector];
  waves_speeds = [waves_speeds; temp_speed_vector];
end

waves_depths
waves_angles
waves_speeds

% X, Y for the plot
X = [];
Y = [];
for k = 1:sim_cycles
  for l = 1:num_of_waves
  	if k == 1
  		X(k,l) = 0;
  	else
  		X(k,l) = X(k-1,l) + waves_speeds(k-1,l)*real(cos(waves_angles(k-1,l)));
  	end
  	Y(k,l) = -waves_depths(k,l);
  end
end
X
Y
% Generate 5 hue-saturation-value color map for your data
colorVec = hsv(num_of_waves);
% Plot and change the color for each line
hold on;
for l = 1:num_of_waves
    plot(transpose(X(:,l)),transpose(Y(:,l)),'Color',colorVec(l,:))
end
hold off;
