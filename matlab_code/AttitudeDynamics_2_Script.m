clear; close all; clc;

% From Week 7
alpha = -1.071343;   
beta  =  0.957818;   
gamma = -0.695676;  

%Given
omega0 = [-4.3198e-5; 9.2423e-5; 1.0422e-4];  % rad/s, in body frame
I_xx = 2500; I_yy = 5000; I_zz = 6500;  % kg*m^2
I = diag([I_xx, I_yy, I_zz]);

% initial state
X0 = [alpha; beta; gamma; omega0];
t0 = 0; tf = 3600; dt = 10;
t_span = t0:dt:tf;

opts = odeset('RelTol',1e-9,'AbsTol',1e-12);

[t_out, X_out] = ode113(@(t,X) AttitudeDynamics_2(t,X,I), t_span, X0, opts);

%Extracting results
phi   = X_out(:,1);
theta = X_out(:,2);
psi   = X_out(:,3);
omega = X_out(:,4:6);  

% Calculating angular momentum and rotational kinetic energy at each time
H_vec = (I * omega')';      
H_mag = sqrt(sum(H_vec.^2,2));  
T_rotational = 0.5 * sum( omega .* ((I*omega')') , 2 );

% Plots
figure;
subplot(2,1,1);
plot(t_out, rad2deg([phi theta psi]));
grid on;
xlabel('Time (s)');
ylabel('Euler angles (deg)');
legend('\phi (roll)','\theta (pitch)','\psi (yaw)','Location','best');
title('Euler angles vs time (3-2-1 sequence)');

subplot(2,1,2);
plot(t_out, omega);
grid on;
xlabel('Time (s)');
ylabel('Angular velocity (rad/s)');
legend('\omega_1','\omega_2','\omega_3','Location','best');
title('Body angular velocity components vs time');

% Angular momentum magnitude and rotational kinetic energy
figure;
subplot(2,1,1);
plot(t_out, H_mag);
grid on;
xlabel('Time (s)');
ylabel('||H|| (kg m^2/s)');
title('Magnitude of angular momentum');

subplot(2,1,2);
plot(t_out, T_rotational);
grid on;
xlabel('Time (s)');
ylabel('Rotational kinetic energy (J)');
title('Rotational kinetic energy');

% print summary stats
fprintf('Initial ||H|| = %.6e  , final ||H|| = %.6e  (difference = %.3e)\n', H_mag(1), H_mag(end), H_mag(end)-H_mag(1));
fprintf('Initial Trot = %.6e J, final Trot = %.6e J (difference = %.3e)\n', T_rotational(1), T_rotational(end), T_rotational(end)-T_rotational(1));

