clear; close all; clc;

% Given 
mu = 3.986004418e14; 
a  = 26561.74e3;            
e  = 0.6603;               
i  = deg2rad(67.95);      
RAAN = deg2rad(268.72);
omega_arg = deg2rad(321.24);
M0 = deg2rad(15.75);
t0 = 0;

% Earth rotation
P_earth = 86164;                % sidereal day [s]
omega_earth = 2*pi / P_earth;   % rad/s
omega_v = [0; 0; omega_earth]; %angular velocity vector(z-axis rotation) for cross products

% Orbital period & time vector for 10 periods 
P = 2*pi * sqrt(a^3 / mu);      % orbital period [s]
fprintf('Orbital period P = %.6f s (%.6f hours)\n', P, P/3600);
n_p = 10;
tspan = linspace(0, n_p*P, 1000*n_p);  

% Initial true anomaly at t0
n = sqrt(mu / a^3);
M_t0 = M0 + n*(t0 - t0);    
[E0, ~] = Kepler(e, M_t0, 1e-12);
theta0 = 2 * atan2( sqrt(1+e)*sin(E0/2), sqrt(1-e)*cos(E0/2) );

% initial ECI state from COE
coe0 = [a, e, i, RAAN, omega_arg, theta0];
X0_ECI = COE2RV(coe0, mu);    % 6x1 [r_ECI; v_ECI]

r0_ECI = X0_ECI(1:3);
v0_ECI = X0_ECI(4:6);

%Convert initial ECI to ECEF at t0 
r0_ECEF = r0_ECI; % At t0 = 0, r_ECEF = r_ECI

% Since v_I = v_F + omega x r, therefore v_F = v_I - omega x r
v0_ECEF = v0_ECI - cross(omega_v, r0_ECEF);

%Initial state in rotating frame
X0_ECEF = [r0_ECEF; v0_ECEF];

% Displaying initial state
fprintf('Initial ECEF state (r [m]; v_F [m/s]):\n');
disp(X0_ECEF);

% Integrating TBP_ECEF for 10 periods
opts = odeset('RelTol',1e-9,'AbsTol',1e-12);
[t_out, X_out] = ode45(@(t,X) TBP_ECEF_trial(t, X, mu, omega_v), tspan, X0_ECEF, opts);

% Final state (ECEF) 
X_final = X_out(end, :)';
fprintf('Final ECEF state after %.0f periods:\n', n_p);
disp(X_final);

% Difference between initial and final ECEF states
diff_v = X_final - X0_ECEF;
fprintf('Norm of difference (final - initial) = %.6e\n', norm(diff_v));

% Plot trajectory in ECEF  
figure;
plot3(X_out(:,1), X_out(:,2), X_out(:,3), 'b', 'LineWidth', 1.2); hold on;
% Earth
[xe, ye, ze] = sphere(80);
R_earth = 6371e3;
surf(R_earth*xe, R_earth*ye, R_earth*ze, 'FaceColor', 'c', 'EdgeColor', 'none');
alpha(0.25);
% initial and final markers
plot3(X0_ECEF(1), X0_ECEF(2), X0_ECEF(3), 'go', 'MarkerFaceColor','g', 'MarkerSize',8);
plot3(X_final(1), X_final(2), X_final(3), 'ro', 'MarkerFaceColor','r', 'MarkerSize',8);
axis equal; grid on;
xlabel('X_{ECEF} (m)'); ylabel('Y_{ECEF} (m)'); zlabel('Z_{ECEF} (m)');
title(sprintf('Satellite trajectory in ECEF for %d orbital periods', n_p));
legend('Trajectory','Earth','Initial pos','Final pos','Location','best');

%Comment about equivalence with initial ECEF
fprintf('\nComment:\n');
fprintf(['If the orbital period of the satellite is not an integral multiple of the rotation period of the Earth ' ...
    '$P_earth (86164 s)$, the final ECEF state of the satellite will differ from the initial state. The difference in norm shows' ...
    '     the difference between initial and final ECEF state.]'])