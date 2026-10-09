% Given vectors
r = [-3501.13; 15954.16; -9521.59]; % in km
v = [-0.7387; -4.9198; -1.5520];  % in km

% Computing unit vectors of RSW frame
R_h = r / norm(r);
W_h = cross(r, v);
W_h = W_h / norm(W_h);
S_h = cross(W_h, R_h);
%disp(R_h)
%disp(W_h)
%disp(S_h)
fprintf('R_h =\n');
disp(R_h)
fprintf('S_h =\n');
disp(S_h)
fprintf('W_h =\n');
disp(W_h)
% DCM from orbital frame to inertial frame]
IO = [R_h S_h W_h];

% Inverse and transpose
IO_inv = inv(IO);
IO_T = IO';

% Given BO matrix
BO = [0.9397 0.1710 -0.2962;
      0.0594 0.7713 0.6337;
      0.3368 -0.6131 0.7146];

% Compute BI
OI = IO';
BI = BO * OI;
fprintf('[IO]=\n');
disp(IO)
fprintf('[IO_inv]=\n');
disp(IO_inv)
fprintf('[IO_T]=\n');
disp(IO_T)
fprintf('[BI]=\n');
disp(BI)
