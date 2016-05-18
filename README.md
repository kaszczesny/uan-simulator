# uan-simulator

trash:
seawater for EM: epsilon_r = 81, mi_r 1, sigma = 4 S/m

separate simulations:
  attuenuation(distance) for acoustic and EM (both LOS)
  refraction+reflection in 2D for acoustic (brus #3 p.7)
  range(BER) at given modulation for acoustic and EM? eye pattern?

 "Elements of Physical Oceanography: A derivative of the Encyclopedia of Ocean"
 page 421 Table 1
 water density - 1000 kg/L
switch material
  case 'air'
    ro = 1.137 / 1000; %moist air according to Wolfram Alpha
    v = 349.14 / vSound;
  case 'clay'
    ro = 1.5;
    v = 1500 / vSound;
  case 'sand'
    ro = 1.9;
    v = 1650 / vSound;
  case 'moraine'
    ro = 2.1;
    v = 1950 / vSound;
  case 'basalt'
    ro = 2.7;
    v = 5250 / vSound;
  otherwise
    error(sprintf('no such reflective material: %s', material))
end