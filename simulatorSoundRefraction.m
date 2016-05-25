clear all;
close all;

% simulation parameters
start_depth = 4000;
surface_temp = 15;
num_waves = 3;
sim_duration = 100;  % in seconds
sim_interval = 10;   % in seconds

start_temp = waterTemperature( start_depth, surface_temp );
start_sound_speed = soundSpeed( start_temp, start_depth );
sim_cycles = sim_duration/sim_interval;

% Results matrixes
waves_angles = 0:pi/num_waves:pi/2;
waves_depths(1:length(waves_angles)) = start_depth;
waves_speeds(1:length(waves_angles)) = start_sound_speed;

for k = 1:sim_cycles
  temp_depth_vector = [];
  temp_angle_vector = [];
  temp_speed_vector = [];
  for l = 1:length(waves_speeds)
    depth = waves_depths(l) - sim_interval*waves_speeds(l)*sin(waves_angles(l));
    temp_depth_vector = [temp_depth_vector depth];

    temperature = waterTemperature(depth, surface_temp);
    speed = soundSpeed( temperature, depth );
    temp_speed_vector = [temp_speed_vector speed];

    angle = refraction(waves_speeds(l), speed, waves_angles(l))
    temp_angle_vector = [temp_angle_vector angle];
  end
  waves_depths = [waves_depths, temp_depth_vector];
  waves_angles = [waves_angles, temp_angle_vector];
  waves_speeds = [waves_speeds, temp_speed_vector];
end

waves_depths
waves_angles
waves_speeds
