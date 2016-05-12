%returns path loss in dB for given path length

function [pathloss] = soundPathLoss (
distance, ... % path distance (or vector of distances); m
absorption, ... % attenuation in dB/m (from Thorpe/Fisher)
)

k = 1.5; %spreading factor( 2 - spherical, 1 - cylindrical, 1.5 - practical )
pathloss = k * 
