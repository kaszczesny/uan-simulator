%returns path loss in dB for given path length

function [pathLoss] = radioPathLoss (
attenuation, ... %
distance ... %
)

pathLoss = 10 * log( exp(attenuation * distance) );