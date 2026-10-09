clear; close all; clc

%Given values
a = 26561.74*1e3;          
e = 0.6603;
i = deg2rad(67.95);
RAAN = deg2rad(268.72);
omega = deg2rad(321.24);
M0 = deg2rad(15.75);
mu = 3.986004418e14;
Tol = 1e-10; 

% Computiing initial E and theta
[E0, itE0] = Kepler(e, M0,Tol);
theta0 = 2 * atan2( sqrt(1+e)*sin(E0/2), sqrt(1-e)*cos(E0/2) );

%Initial ECI state from W3.3
coe0 = [a, e, i, RAAN, omega, theta0];
X0 = COE2RV(coe0, mu);    % 6x1 initial ECI state

% Time vector from W3.1
P = 2*pi * sqrt(a^3 / mu);
fprintf('Orbital period P = %.6f s (%.6f hours)\n', P, P/3600);
tspan = linspace(0, P, 1000);   

% Using ODE45 solver
ode_opts = odeset('RelTol',1e-9,'AbsTol',1e-12);
[t_num, X_num] = ode45(@(t,X) TBP_ECI_Trial2(t,X,mu), tspan, X0, ode_opts);
% X_num is Nx6 (rows = time points), where columns are x,y,z,vx,vy,vz

% Analytical solution
n = sqrt(mu / a^3);
M_v = M0 + n*(tspan - 0);
M_v = mod(M_v, 2*pi);

E_v = zeros(size(M_v));
theta_vec = zeros(size(M_v));
for k = 1:length(M_v)
    [E_v(k), ~] = Kepler(e, M_v(k), Tol);
    theta_vec(k) = 2 * atan2( sqrt(1+e)*sin(E_v(k)/2), sqrt(1-e)*cos(E_v(k)/2) );
    theta_vec(k) = mod(theta_vec(k), 2*pi);
end

X_ana = zeros(6, length(tspan));
for k = 1:length(tspan)
    coe_k = [a, e, i, RAAN, omega, theta_vec(k)];
    X_ana(:,k) = COE2RV(coe_k, mu);
end
X_ana= X_ana.'; % make Nx6 to match ode45 output rows

% Position and Time vectors over time
pos_num = X_num(:,1:3);       
vel_num = X_num(:,4:6);       
pos_ana = X_ana(:,1:3);  
vel_ana = X_ana(:,4:6);  
 % To find error in numerical and analytical solution
pos_err = vecnorm(pos_num - pos_ana, 2, 2); 
vel_err = vecnorm(vel_num - vel_ana, 2, 2);  

% Plots
figure('Name','Position and Velocity Errors');
yyaxis left
plot(tspan, pos_err, 'r', 'LineWidth', 1.2);
ylabel('Position error ||Δr|| (m)')
yyaxis right
plot(tspan, vel_err, 'b', 'LineWidth', 1.2);
ylabel('Velocity error ||Δv|| (m/s)')
xlabel('Time (s)')
title('Position and Velocity Errors: Numerical integration vs Analytical propagation')
legend('Position error','Velocity error','Location','best')
grid on

% Specific angular momentum over time 
h_v = zeros(length(t_num),1);
for k = 1:length(t_num)
    r_k = pos_num(k,:).'; v_k = vel_num(k,:).';
    h_k = cross(r_k, v_k);    % 3x1
    h_v(k) = norm(h_k);
    h_mag = vecnorm(h_v, 2, 2);
end

% theoretical h magnitude
h_theoretical = sqrt(mu * a * (1 - e^2));
fprintf('Theoretical specific angular momentum |h_theo| = %.6e (m^2/s)\n', h_theoretical);
fprintf('Mean Value of Analytical Specific Angular Momentum |h_ana| = %.6e (m^2/s)\n', mean(h_mag))

% Plots
figure('Name','Specific angular momentum norm');
plot(tspan, h_v, 'b', 'LineWidth', 1.2); hold on;
yline(h_theoretical, '--r', 'LineWidth', 1.3);
xlabel('Time (s)')
ylabel('||h|| (m^2/s)')
title('Specific angular momentum magnitude over time')
legend('Numerical ||h||','Analytic sqrt(mu a (1-e^2))','Location','best')
grid on

% Initial and Final states
X0_num = X_num(1,:)';
Xf_num = X_num(end,:)';
X0_ana = X_ana(1,:)';
Xf_ana = X_ana(end,:)';

%ECI trajectory around the Earth
R_earth = 6371e3;   % in meters
[xe, ye, ze] = sphere(60);    % 60x60 mesh

figure('Name','3D ECI Trajectory around Earth','Color','black');

hSurf = surf(R_earth*xe, R_earth*ye, R_earth*ze, ...
    'FaceColor', 'interp', 'EdgeColor', 'none', 'FaceAlpha', 0.75);
colormap(gca, winter);    
hold on;
% plot numerical trajectory (ECI) in meters
plot3(X_num(:,1), X_num(:,2), X_num(:,3), '-r', 'LineWidth', 1.5);

% plot analytical trajectory for comparison (optional)
plot3(X_ana(:,1), X_ana(:,2), X_ana(:,3), '--b', 'LineWidth', 1);

% initial and final position markers (numerical)
plot3(X_num(1,1), X_num(1,2), X_num(1,3), 'go', 'MarkerFaceColor','g','MarkerSize',8);
plot3(X_num(end,1), X_num(end,2), X_num(end,3), 'mo', 'MarkerFaceColor','m','MarkerSize',8);

axis equal;
grid on;
xlabel('X_{ECI} (m)');
ylabel('Y_{ECI} (m)');
zlabel('Z_{ECI} (m)');
title('ECI Trajectory and Earth');
legend({'Earth','Numerical trajectory','Analytical trajectory','Initial pos (num)','Final pos (num)'}, ...
       'Location','bestoutside');
r_orbit = mean(vecnorm(X_num(:,1:3),2,2));
maxlim = (r_orbit * 1.2);
xlim([-maxlim maxlim]); ylim([-maxlim maxlim]); zlim([-maxlim maxlim]);
view(35,20);
hold off;


fprintf('\nInitial numerical state (first row):\n'); disp(X0_num)
fprintf('Final numerical state (last row):\n'); disp(Xf_num)
fprintf('Initial analytic state (first row):\n'); disp(X0_ana)
fprintf('Final analytic state (last row):\n'); disp(Xf_ana)

fprintf('Norm position error at t=0: %.6e m\n', pos_err(1));
fprintf('Norm position error at t=P: %.6e m\n', pos_err(end));
fprintf('Max position error over [0,P]: %.6e m\n', max(pos_err));
fprintf('Max velocity error over [0,P]: %.6e m/s\n', max(vel_err));
