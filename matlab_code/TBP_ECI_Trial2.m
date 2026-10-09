function dXdt = TBP_ECI_Trial2(t, X, mu)
% TBP_ECI  Right-hand side of two-body problem in ECI frame
% Inputs:
%   t  - time 
%   X  - 6x1 state vector [x; y; z; vx; vy; vz]
%   mu - Earth's gravitational parameter (m^3/s^2)
% Output:
%   dXdt - 6x1 derivative [vx; vy; vz; ax; ay; az]

% position and velocity
r_v = X(1:3);
v_v = X(4:6);

r = norm(r_v);
if r == 0
    error('Zero radius encountered in TBP_ECI.');
end

% gravitational acceleration
a_v = -mu / r^3 * r_v;

% derivative of state
dXdt = [v_v; a_v];
end
