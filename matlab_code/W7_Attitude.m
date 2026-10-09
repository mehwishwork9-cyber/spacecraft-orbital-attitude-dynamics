clear; close all; clc

% Given rotation matrix [B I]
BI = [0.0445  0.6951 -0.7175;
     -0.8506 -0.3503 -0.3921;
     -0.5239  0.6277  0.5757];

% Euler's Prinicpal Axis and Angle
Tr = trace(BI);
phi = acos( (Tr - 1)/2 );        % Principal angle (rad)
% handle numerical rounding
if abs(sin(phi)) < 1e-12 %phi is approximately 0 or pi radians
    e_hat = [0;0;0];
else
    e_hat = (1/(2*sin(phi))) * [ BI(3,2) - BI(2,3);
                             BI(3,1) - BI(1,3);
                             BI(1,2) - BI(2,1) ];
end

fprintf('Axis-angle: phi = %.8f rad (%.6f deg)\n', phi, rad2deg(phi));
fprintf('Axis e = [%.8f %.8f %.8f]^T (norm = %.8f)\n', e_hat(1), e_hat(2), e_hat(3), norm(e_hat));

% Quaternions
q0 = cos(phi/2); %scalar part
q_v = e_hat * sin(phi/2); %vector part
q = [q0; q_v];
fprintf('Quaternion q = [q0 q1 q2 q3]^T = [%.8f %.8f %.8f %.8f]^T\n', q(1), q(2), q(3), q(4));
fprintf('Quaternion norm = %.12f\n', norm(q));

% If norm deviates, renormalize:
if abs(norm(q)-1) > 1e-10
    q = q / norm(q);
    fprintf('Renormalized quaternion.\n');
end

% 3-1-3 Euler angles (Z-X-Z) extraction
beta = acos( max(min(BI(3,3),1),-1) ); % Computes Euler angle % Argument remains between [-1,1]
sin_b = sin(beta);
if abs(sin_b) > 1e-8 
    alpha = atan2( BI(1,3)/sin_b, -BI(2,3)/sin_b );
    gamma = atan2( BI(3,1)/sin_b,  BI(3,2)/sin_b );
else
    % singular case: alpha = 0, gamma = atan2(-R12, R11)
    alpha = 0;
    gamma = atan2(-BI(1,2), BI(1,1));
end

fprintf('3-1-3 Euler angles (alpha,beta,gamma) in rad = [%.8f, %.8f, %.8f]\n', alpha, beta, gamma);
fprintf('In degrees = [%.6f, %.6f, %.6f]\n', rad2deg(alpha), rad2deg(beta), rad2deg(gamma));

% Kinematic matrix B(theta) (gives [dot alpha; dot beta; dot gamma] = B * omega_body)
% For 3-1-3 (Z-X-Z), the explicit inverse mapping is:
B_theta = [ sin(gamma)/sin(beta),  cos(gamma)/sin(beta),  0;
         cos(gamma),           -sin(gamma),           0;
        -sin(gamma)*cos(beta)/sin(beta), -cos(gamma)*cos(beta)/sin(beta), 1 ];

fprintf('Kinematic matrix B(theta) (maps body omega to Euler rates):\n');
disp(B_theta);
