# Launch Vehicle GNC 
This folder contains the GNC sub-team project.

## Folder Structure
- **docs/mission_requirements**: Requirements/objective, orbital params, constraints, etc...
- **environment**: Atmospheric, gravity & other env models used in the sim.
- **vehicle**: Primary 6DOF dynamics
  - **vehicle/propellant**: Propellant slosh modeling.
  - **vehicle/actuators**: Linear actuators, gimbals, etc...
  - **vehicle/propulsion**: Engine performance and related models.
- **guidance**: Guidance algorithms.
- **navigation**: Sensor fusion & state estimation.
- **control**: Control laws.
- **simulation**: Main access point for running sims.
- **test**: Scripts for unit testing.

