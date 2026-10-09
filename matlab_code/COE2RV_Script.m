clear ; close all; clc;
% Given data
mu = 3.986004418e14; % in meters
a = 26561074; % in meters
e = 0.6603;
i_deg = 67.95;
i = deg2rad(i_deg);
RAAN_deg = 268.72;
RAAN = deg2rad(RAAN_deg);
omega_deg = 321.24;
omega = deg2rad(omega_deg);
M0_deg = 15.75; %M0 is referred to as the mean anomaly at the initial epoch t0
M0 = deg2rad(M0_deg);
t0 = 0;

%Formula to calculate orbital period P
P = 2*pi*sqrt(a^3/mu);
n = sqrt(mu/a^3) ;
fprintf('Orbital Period P = %.3f s\n', P);
%1000 is used to divide in equal spaced points
t = linspace(0, P, 1000);

M = zeros(1,1000);
E = zeros(1, 1000);
theta = zeros(1, 1000);
X = zeros(6,1000);
tol = 1e-10;
for j = 1:1000
    M(j) = M0 + n*(t(j) - t0);
    M(j) = mod(M(j), 2*pi);
    [E(j), itr(j)] = Kepler(e, M(j), tol);
    theta(j) = 2 * atan2( sqrt(1+e)*sin(E(j)/2), sqrt(1-e)*cos(E(j)/2) ); %true anomaly 
    theta(j) = mod(theta(j), 2*pi); 
    coe = [a, e, i, RAAN, omega, theta(j)];
    X(:, j) = COE2RV(coe, mu);
end

%Plotting the 2D graph
figure;
plot(t, M, 'r', 'LineWidth', 1); hold on;  %'hold on' allows more graphs to be plotted on the same plot %Plots mean anomaly vs time in red 
plot(t, E, 'b', 'LineWidth', 1); %Plots eccentric anomaly vs time in blue 
plot(t, theta, 'g', 'LineWidth', 1); %Plots ture anomaly vs time in green 
xlabel('Time (s)'); %x-axis Time
ylabel('Anomaly (rad)'); %y-axis Anomalies in Rad
legend('Mean Anomaly M','Eccentric Anomaly E', 'True Anomaly \theta'); %identifies each plot
title('Anomalies vs Time');
grid on;

%Plotting the 3-D graph
figure('Name','ECI Orbit Trajectory with Earth','Color','black');
R_earth = 6371e3; %in meters
% Creates sphere 
[xe, ye, ze] = sphere(60);   
% draw Earth as a blue semi-transparent sphere
hSurf = surf(R_earth*xe, R_earth*ye, R_earth*ze, ...
    'FaceColor', [0 0.45 0.90], ...   % solid blue color (RGB)
    'EdgeColor', 'none', ...
    'FaceAlpha', 0.8);                % makes earth semi-transparent so orbit is visible
hold on;
plot3(X(1,:), X(2,:), X(3,:), 'g', 'LineWidth', 1.2);
% Marking initial and final points
plot3(X(1,1), X(2,1), X(3,1), 'ko', 'MarkerFaceColor','g', 'MarkerSize',8); % start
plot3(X(1,end), X(2,end), X(3,end), 'mo', 'MarkerFaceColor','m', 'MarkerSize',8); % end
% labelling and formatting
axis equal;
grid on;
xlabel('X_{ECI} (m)');
ylabel('Y_{ECI} (m)');
zlabel('Z_{ECI} (m)');
title('ECI Orbit Trajectory around Earth');
% set axis limits to focus on the orbit (pad by 20%)
r_orbit = mean(vecnorm(X(1:3,:)',2,2));
lim = r_orbit * 1.2;
xlim([-lim lim]); ylim([-lim lim]); zlim([-lim lim]);
view(35,20);  
legend({'Earth','Orbit','Start','End'}, 'Location','best');

hold off;


% Displayin the starting and final position, they will be same because of an elliptical orbit
fprintf('At t=0: M=%.8f rad, E=%.8f rad, theta = %.8f rad\n', M(1), E(1), theta(1));
fprintf('At t=P: M=%.8f rad, E=%.8f rad, theta = %.8f rad\n', M(end), E(end), theta(end));


