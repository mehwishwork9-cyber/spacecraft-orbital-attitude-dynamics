
clear; clc;

% Given data
a_km = 26561.74;      % semi-major axis in km
e = 0.6603;           % eccentricity
M_rad = deg2rad(15.75);  % mean anomaly getting converted in radians
tol = 1e-10;          % Newton tolerance

% Solve Kepler's equation (E in radians)
[E, itr] = Kepler(e, M_rad, tol);

% Formula to compute true anomaly (theta) in radian
theta = 2 * atan2( sqrt(1+e)*sin(E/2), sqrt(1-e)*cos(E/2) ); 

% normalise theta into the range of [0, 2*pi)
theta = mod(theta, 2*pi);

% Computing perigee and apogee distance to determine the position of satellite
r_km   = a_km * (1 - e*cos(E));      % orbital radius at E (km)
rp_km  = a_km * (1 - e);             % periapsis (km)
ra_km  = a_km * (1 + e);             % apoapsis (km)

% Closeness of the satellite to perigee or apogee
peri_dis = abs(r_km - rp_km);
apo_dis  = abs(ra_km - r_km);

if peri_dis < apo_dis
    position = 'closer to periapsis';
elseif peri_dis > apo_dis
    position = 'closer to apoapsis';
else
    position = 'equally distant from periapsis and apoapsis';
end

% ---- output results ----
fprintf('Week 2 - Kepler and True Anomaly Results: \n');
fprintf('Mean anomaly M = %.10f rad (%.8f deg)\n', M_rad, rad2deg(M_rad) );
fprintf('Eccentric anomaly E = %.12f rad (%.8f deg)\n', E, rad2deg(E));
fprintf('Newton iterations = %d\n', itr);
fprintf('True anomaly theta = %.12f rad (%.8f deg)\n', theta, rad2deg(theta));
fprintf('\nOrbital radii (km):\n');
fprintf(' r   = %.5f km (current)\n', r_km);
fprintf(' rp = %.5f km (periapsis)\n', rp_km);
fprintf(' ra = %.5f km (apoapsis)\n', ra_km);
fprintf('\nDistances:\n');
fprintf(' |r - rp| = %.5f km\n', peri_dis);
fprintf(' |ra - r| = %.5f km\n', apo_dis);
fprintf('\nConclusion: The satellite is %s.\n', position);
