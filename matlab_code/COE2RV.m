function X = COE2RV(coe, mu)
a = coe(1);
e = coe(2);
i = coe(3);
RAAN = coe(4);
omega = coe(5);
theta = coe(6);
%All the formulas are taken from Week 3 notes
rp = a*(1-e^2)/(1+e*cos(theta));
r_pf = [rp*cos(theta); 
        rp*sin(theta); 
        0];
h = sqrt(mu*a*(1-e^2));
v_pf = (mu/h)*[-sin(theta);
                e+cos(theta); 
                0];
%Already converted from PI to IP frame
R3_RAAN = [cos(RAAN) -sin(RAAN) 0; sin(RAAN) cos(RAAN) 0; 0 0 1];
R1_i = [1 0 0; 0 cos(i) -sin(i); 0 sin(i) cos(i)];
R3_omega = [cos(omega) -sin(omega) 0; sin(omega) cos(omega) 0; 0 0 1];
IP = R3_RAAN*R1_i*R3_omega;
r_ECI = IP * r_pf;
v_ECI = IP * v_pf;
X = [r_ECI; v_ECI];
end
