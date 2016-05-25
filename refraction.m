function out_angle = refraction(in_speed, out_speed, in_angle)
	% implementation of Snell's Law
	% in_speed - wave's input speed
 	 %	out_speed - wave's output speed
	% in_angle - wave's input angle, unit radian
	% return:
	% 	out_angle - wave's output angle, unit radian
	% There is some sin/cos voodoo because an input angle is in relation to X-axis

  angle = abs(asin(cos(in_angle)));

  sin_crit_angle = in_speed/out_speed;

  out_angle = acos(real(sin(angle))*out_speed/in_speed);

  % no idea why complex numbers
  %out_angle = real(out_angle);

  if in_angle < 0
    out_angle = -out_angle;
  end

  if sin(angle) > sin_crit_angle
    out_angle = -out_angle;
  end
