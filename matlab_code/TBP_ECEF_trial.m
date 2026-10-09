function dXdt = TBP_ECEF_trial(t, X, mu, omega_v)
% TBP_ECEF  Right-hand side for two-body problem in ECEF rotating frame
% Inputs:
%   t         - time 
%   X         - 6x1 state vector [x;y;z;vx;vy;vz] in ECEF
%   mu        - gravitational parameter [m^3/s^2]
%   omega_v - 3x1 rotation vector of ECEF in ECI (rad/s), e.g. [0;0;omega]
%
% Output:
%   dXdt - 6x1 derivative [vx; vy; vz; ax; ay; az]

r = X(1:3);           % position in ECEF (m)
v_F = X(4:6);          % rotating-frame velocity in ECEF (m/s)
r_norm = norm(r);
if r_norm == 0
    error('Position radius is zero.');
end

% gravitational accel (in same frame)
a_grav = -mu / r_norm^3 * r;

% Coriolis and centrifugal (omega assumed constant)
a_coriolis = -2 * cross(omega_v, v_F);
a_cent      = - cross(omega_v, cross(omega_v, r));

a_total = a_grav + a_coriolis + a_cent;

dXdt = [v_F; a_total];
end
