function out_angle = refraction(in_speed, out_speed, in_angle)
	% implementation of Snell's Law
	% in_speed - wave's input speed
 	 %	out_speed - wave's output speed
	% in_angle - wave's input angle, unit radian
	% return:
	% 	out_angle - wave's output angle, unit radian

  epsilon = 0.00001;
  angle = abs(in_angle);

  sin_crit_angle = in_speed/out_speed;

  out_angle = arcsin(sin(angle)*out_speed/in_speed);

  if in_angle < 0
    out_angle = -out_angle;
  end

  if (crit_angle - epsilon) <= sin(angle) <= (crit_angle + epsilon)
    out_angle = -out_angle;
  end
