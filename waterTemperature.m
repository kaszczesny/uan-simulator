% calculates water temperature for given depth and surface temperature

function temperature = waterTemperature ( ...
  depth, ... % meters; can be a vector
  tSurf ... % Celcius
)

tBottom = 2;

% https://books.google.pl/books?id=KnVhnw5m_M0C&pg=PA75&lpg=PA75&dq=sea+temperature+profile+formula&source=bl&ots=mfl-QiGavf&sig=IQSSDmojUpVl8QncWEZ30Rnubr0&hl=pl&sa=X&ved=0ahUKEwiiqeqs1eLMAhWCSxoKHUGUAnUQ6AEIJTAB#v=onepage&q=sea%20temperature%20profile%20formula&f=false
temperature = tBottom + ...
   ( (tSurf-tBottom)*exp( -depth./(1452-612*log(depth)+69*log(depth).^2+2e-6*depth.^3+0.0026*depth.^2+0.9214*depth )) ) ./ ...
   exp(depth/1e3);
