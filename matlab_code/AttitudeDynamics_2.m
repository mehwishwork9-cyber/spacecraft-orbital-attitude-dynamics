function dXdt = AttitudeDynamics_2(t, X, I)
% AttitudeDynamics  compute state derivative for torque-free rigid body
%   X = [phi; theta; psi; omega1; omega2; omega3]
%   I is 3x3 inertia matrix (diagonal here)
%
%   returns dXdt (6x1)

% unpack
phi   = X(1);
theta = X(2);
psi   = X(3);
omega = X(4:6);   % [p; q; r]

% inertia (3x3). Expect caller to pass diag(Ixx,Iyy,Izz)
% I = diag(Ixx,Iyy,Izz);  % not here, passed in

% Kinematics: Euler angle rates (3-2-1 / Z-Y-X sequence)
% Avoid dividing by zero: check cos(theta)
ct = cos(theta);
if abs(ct) < 1e-8
    warning('theta near +/-90 deg: singularity in Euler parametrization.');
end

T = [ 1,          sin(phi)*tan(theta),  cos(phi)*tan(theta);
      0,          cos(phi),            -sin(phi);
      0,          sin(phi)/ct,          cos(phi)/ct ];

angles_dot = T * omega;   % [phi_dot; theta_dot; psi_dot]

% Dynamics: torque-free Euler equations
% I * domega + omega x (I*omega) = 0  =>  domega = I^{-1} ( - omega x (I*omega) )
Iomega = I * omega;
omega_dot = I \ ( - cross(omega, Iomega) );

% pack derivative
dXdt = zeros(6,1);
dXdt(1:3) = angles_dot;
dXdt(4:6) = omega_dot;
end
