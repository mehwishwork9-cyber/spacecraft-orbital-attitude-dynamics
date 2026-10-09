# Spacecraft Orbital and Attitude Dynamics Simulation

**MATLAB | Orbital Mechanics | Spacecraft Dynamics | Numerical Integration | Attitude Kinematics**

## 1. Project Overview

This project explores the fundamental principles of spacecraft orbital mechanics and attitude dynamics through mathematical modelling and numerical simulations developed in MATLAB.

The work was undertaken as part of my MSc in Astronautics & Space Engineering and investigates two key areas of spacecraft motion:

- **Orbital Dynamics:** Modelling and propagating satellite trajectories under the two-body gravitational model, analysing orbital elements, and transforming spacecraft states between inertial and rotating reference frames.
- **Attitude Dynamics:** Investigating spacecraft orientation, rotation matrices, quaternion representations, Euler angles, and torque-free rigid-body rotational motion.

The project combines analytical solutions with numerical integration techniques to investigate spacecraft behaviour, evaluate numerical accuracy, and explore fundamental conservation laws.

## 2. Project Objectives

The primary objectives of this project are to:

- Solve Kepler's equation using Newton's iterative method.
- Convert classical orbital elements into Cartesian position and velocity vectors.
- Numerically propagate a satellite trajectory using the two-body equations of motion.
- Compare numerical orbit propagation against analytical Keplerian solutions.
- Investigate conservation of specific orbital angular momentum.
- Model spacecraft motion in Earth-Centred Inertial (ECI) and Earth-Centred Earth-Fixed (ECEF) reference frames.
- Implement and analyse Direction Cosine Matrices (DCMs).
- Investigate Euler's principal rotation theorem and quaternion attitude representations.
- Examine Euler angle kinematics and representation singularities.
- Simulate torque-free spacecraft rotational dynamics.
- Investigate conservation of angular momentum and rotational kinetic energy.

---

## 3. Part I — Spacecraft Orbital Mechanics

### 3.1 Kepler's Equation and Newton's Method

Kepler's equation describes the relationship between the mean anomaly and eccentric anomaly of a spacecraft travelling along an elliptical orbit.

The equation is:

\[
M = E - e\sin E
\]

Where:

- **M** — Mean anomaly (rad).
- **E** — Eccentric anomaly (rad).
- **e** — Orbital eccentricity.

Since Kepler's equation cannot generally be solved explicitly for eccentric anomaly, Newton's iterative numerical method was applied.

The iteration formula is:

\[
E_{n+1}=E_n-\frac{E_n-e\sin E_n-M}{1-e\cos E_n}
\]

Where:

- **Eₙ** — Eccentric anomaly estimate at iteration n.
- **Eₙ₊₁** — Updated estimate.
- **e** — Orbital eccentricity.
- **M** — Mean anomaly.

**Simulation results:**

- Initial mean anomaly: 15.75°
- Orbital eccentricity: 0.6603
- Numerical convergence: 5 iterations
- Calculated eccentric anomaly: 0.70053788 rad
- Calculated true anomaly: approximately 77.85°

The implementation demonstrates iterative numerical root-finding applied to orbital mechanics.

### 3.2 Classical Orbital Elements to Cartesian State Vectors

A spacecraft's orbit can be described using six classical orbital elements:

\[
COE=[a,e,i,\Omega,\omega,\theta]
\]

Where:

- **a** — Semi-major axis.
- **e** — Eccentricity.
- **i** — Orbital inclination.
- **Ω** — Right Ascension of the Ascending Node (RAAN).
- **ω** — Argument of periapsis.
- **θ** — True anomaly.

The MATLAB implementation converts these orbital elements into Cartesian position and velocity vectors.

The conversion uses position and velocity representations in the perifocal reference frame and rotation matrices to transform them into the ECI frame.

This transformation provides the Cartesian initial conditions required for numerical orbit propagation.

### 3.3 Two-Body Orbit Propagation in the ECI Frame

The spacecraft's orbital motion was modelled using the two-body gravitational equation:

\[
\ddot{\mathbf r}=-\frac{\mu}{r^3}\mathbf r
\]

Where:

- **r** — Spacecraft position vector relative to Earth's centre.
- **r** (scalar) — Magnitude of the spacecraft position vector.
- **r̈** — Spacecraft acceleration vector.
- **μ** — Earth's gravitational parameter.

The second-order differential equation was converted into a system of first-order equations and integrated numerically using MATLAB's `ode45` solver.

The simulation generated the spacecraft position and velocity over time.

### 3.4 Numerical vs Analytical Orbit Propagation

The numerical solution obtained using `ode45` was compared against the analytical Keplerian solution.

The objective was to assess the agreement between both methods and examine accumulated numerical propagation error.

**Reported results:**

| Performance metric | Result |
|---|---|
| Position error at initial time | 0 m |
| Position error after one orbital period | Approximately 0.105 m |
| Maximum position error | Approximately 0.132 m |
| Maximum velocity error | Approximately 7.46 × 10⁻⁵ m/s |

These results demonstrate close agreement between the numerical and analytical solutions under the selected two-body modelling assumptions and numerical settings.

### 3.5 Specific Angular Momentum Conservation

For an ideal two-body gravitational system, the specific orbital angular momentum remains constant.

\[
\mathbf h=\mathbf r\times\mathbf v
\]

Where:

- **h** — Specific orbital angular momentum vector.
- **r** — Spacecraft position vector.
- **v** — Spacecraft velocity vector.

The numerical and analytical solutions were examined to investigate conservation of specific angular momentum throughout the orbital trajectory.

**Reported theoretical magnitude:**

\[
|\mathbf h|\approx7.727486\times10^{10}\ \text{m}^2/\text{s}
\]

The reported analytical mean agreed with the theoretical value.

### 3.6 Orbit Propagation in the ECEF Reference Frame

Orbital propagation was also investigated in the Earth-Centred Earth-Fixed reference frame.

Unlike ECI, the ECEF frame rotates with Earth.

The transformation between inertial and rotating frames requires accounting for additional acceleration terms, including:

- Coriolis acceleration
- Centrifugal acceleration
- Euler acceleration, when the reference-frame rotation rate varies

The transport theorem was used to formulate the relationship between the reference frames.

The ECEF equations were considered to investigate how Earth's rotation affects the representation of satellite position and velocity.

---

## 4. Part II — Spacecraft Attitude Kinematics and Dynamics

### 4.1 Direction Cosine Matrices

Direction Cosine Matrices (DCMs) were investigated as a method of transforming vectors between coordinate reference frames.

A DCM represents the relative orientation of two reference frames using an orthogonal rotation matrix.

The project examined transformations between:

- Earth-Centred Inertial (ECI) frame
- Orbital reference frame
- Spacecraft body-fixed frame

DCM relationships and matrix properties were applied to verify coordinate transformations.

### 4.2 Euler's Principal Rotation Theorem

Euler's principal rotation theorem states that the orientation of a rigid body can be represented using a single rotation about a principal axis.

The project investigated the extraction of the principal rotation angle and axis from a rotation matrix.

**Reported results:**

- Principal rotation angle: approximately 111.41°
- Principal rotation axis: approximately [0.5477, 0.1040, 0.8301]

This representation provides an alternative method of describing spacecraft attitude.

### 4.3 Quaternion Attitude Representation

Quaternions provide a four-parameter representation of spacecraft orientation.

They are widely used in spacecraft attitude applications because they avoid the kinematic singularities associated with three-angle representations.

The project examined quaternion calculations from principal rotation parameters and evaluated quaternion normalisation.

The unit quaternion condition is:

\[
q_0^2+q_1^2+q_2^2+q_3^2=1
\]

Where **q₀, q₁, q₂ and q₃** are quaternion components.

Quaternion normalisation is important for maintaining a valid attitude representation.

### 4.4 Euler Angle Kinematics

Euler angles were investigated as an alternative representation of spacecraft orientation.

The coursework examined the **3-1-3 Euler rotation sequence** and its associated transformation matrices.

The relationship between body angular velocity and Euler angle rates was analysed.

The investigation also considered singularities that occur when the kinematic transformation becomes undefined for particular angular configurations.

### 4.5 Torque-Free Spacecraft Rotational Dynamics

Spacecraft rotational motion was investigated using Euler's rigid-body equations.

For a rigid spacecraft without external torque:

\[
\mathbf I\dot{\boldsymbol\omega}+
\boldsymbol\omega\times(\mathbf I\boldsymbol\omega)=0
\]

Where:

- **I** — Spacecraft inertia matrix.
- **ω** — Spacecraft body angular velocity vector.
- **ω̇** — Angular acceleration vector.
- **×** — Vector cross product.

The equations were numerically integrated to investigate spacecraft angular velocity and attitude evolution.

The simulation provides insight into how an asymmetric rigid spacecraft can exhibit changing body-axis angular velocity components even in the absence of external torque.

### 4.6 Conservation of Angular Momentum and Rotational Kinetic Energy

The final investigation examined two conserved quantities in torque-free rigid-body motion.

**Angular momentum:**

\[
\mathbf H=\mathbf I\boldsymbol\omega
\]

**Rotational kinetic energy:**

\[
T=\frac12\boldsymbol\omega^T\mathbf I\boldsymbol\omega
\]

Where:

- **H** — Spacecraft angular momentum vector.
- **T** — Rotational kinetic energy.
- **I** — Moment of inertia matrix.
- **ω** — Angular velocity vector.

For an ideal torque-free rigid body, the inertial angular momentum vector and rotational kinetic energy are conserved.

The MATLAB simulations investigated these properties and their behaviour over time.

---

## 5. Simulation Parameters

| Parameter | Value |
|---|---|
| Programming environment | MATLAB |
| Numerical integration | ODE45 |
| Earth's gravitational parameter | 398600.4418 km³/s² |
| Earth's mean equatorial radius | 6378.137 km |
| Earth's angular velocity | 7.2921 × 10⁻⁵ rad/s |
| Orbital semi-major axis | 26561.74 km |
| Orbital eccentricity | 0.6603 |
| Orbital inclination | 67.95° |
| RAAN | 268.72° |
| Argument of periapsis | 321.24° |
| Initial mean anomaly | 15.75° |
| Spacecraft Ixx | 2500 kg·m² |
| Spacecraft Iyy | 5000 kg·m² |
| Spacecraft Izz | 6500 kg·m² |

These values correspond to the academic simulation scenario.

---

## 6. Repository Structure

```text
spacecraft-orbital-attitude-dynamics/
│
├── matlab_code/
│   ├── Kepler.m
│   ├── Kepler_Script.m
│   ├── COE2RV.m
│   ├── COE2RV_Script.m
│   ├── TBP_ECI_Trial2.m
│   ├── TBP_ECI_Trial2_Script.m
│   ├── TBP_ECEF_trial.m
│   ├── TBP_ECEF_trial_Script.m
│   ├── DCM.m
│   ├── W7_Attitude.m
│   ├── AttitudeDynamics_2.m
│   └── AttitudeDynamics_2_Script.m
│
├── simulation_results/
│   └── MATLAB-generated simulation figures
│
├── documentation/
│   └── Technical coursework report
│
└── README.md
```

## 7. Running the MATLAB Simulations

1. Download or clone the repository.
2. Open MATLAB.
3. Navigate to the `matlab_code` directory.
4. Add this directory to the MATLAB path if required.
5. Open the relevant MATLAB script.
6. Run the script and examine the generated numerical outputs and figures.

Example MATLAB scripts include:

- `Kepler_Script.m` — Kepler's equation calculations.
- `COE2RV_Script.m` — Orbital elements to Cartesian state-vector conversion.
- `TBP_ECI_Trial2_Script.m` — Two-body orbital propagation in the ECI frame.
- `TBP_ECEF_trial_Script.m` — Orbital calculations in the ECEF frame.
- `AttitudeDynamics_2_Script.m` — Rigid-body attitude dynamics investigation.

Some scripts may require supporting functions from the same directory.

## 8. Tools and Technical Skills Demonstrated

**Programming and Numerical Methods**
- MATLAB programming
- Numerical integration using ODE45
- Newton's iterative method
- Mathematical modelling
- Analytical and numerical solution comparison
- Scientific data visualisation

**Spacecraft Engineering**
- Keplerian orbital mechanics
- Two-body orbit propagation
- Orbital state-vector transformations
- ECI and ECEF reference frames
- Direction Cosine Matrices
- Quaternion and Euler angle representations
- Spacecraft rotational dynamics
- Conservation laws in orbital and rigid-body mechanics

## 9. Assumptions and Limitations

The simulations are based on simplified analytical and numerical spacecraft models.

Key limitations include:

- Orbital propagation primarily considers ideal two-body gravitational dynamics.
- Additional orbital perturbations, such as atmospheric drag and Earth's oblateness, are not included in the main two-body propagation model.
- Attitude dynamics are investigated under torque-free rigid-body assumptions.
- The project does not implement an active attitude controller.
- Simulation results are based on academic spacecraft parameters rather than a validated flight spacecraft model.
- Numerical accuracy depends on integration settings, tolerances and modelling assumptions.

These limitations define the scope of the project and provide opportunities for further development.

## 10. Potential Future Improvements

Future extensions could include:

- Modelling Earth's J2 gravitational perturbation.
- Adding atmospheric drag to orbital propagation.
- Implementing orbit-dependent environmental disturbance models.
- Extending attitude propagation using quaternions.
- Comparing the numerical performance of multiple integration techniques.
- Performing systematic numerical sensitivity and convergence studies.
- Integrating active attitude control algorithms.
- Developing a coupled spacecraft orbital and attitude simulation.

## 11. Conclusion

This project strengthened my understanding of spacecraft orbital mechanics, numerical integration, coordinate transformations and rigid-body attitude dynamics.

It also provided practical experience implementing mathematical models in MATLAB, evaluating simulation results, and examining fundamental spacecraft conservation laws.

The work provides a foundation for further development in **Spacecraft Dynamics, AOCS/GNC, Flight Dynamics and Mission Simulation**.

## 12. Author

**Mehwish Akram**

MSc Astronautics & Space Engineering

**Technical Interests:** Spacecraft Systems Engineering | AOCS/GNC | Flight Dynamics | Orbital Mechanics | MATLAB Simulation
